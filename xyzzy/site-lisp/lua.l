;;; -*- Mode: Lisp; Package: EDITOR -*-
;;;
;;; This file is not part of xyzzy.
;;;

; lua-mode.l 2008/02/10 17:19:31
;
; インデント計算を変更
;
; lua-mode.l 2005/04/23 02:13:22
;
; 未定義物や不要な物を整理。
; mk-lua-autoindentを作った。
;
; lua-mode.l 2004/07/20 21:16:48
;
; local functionとか ～= functionもインデント対象に
;
; lua-mode.l 2004/02/16 18:52:58
;
; ruby-mode for xyzzy (1.12 2001/11/11 10:52:53) by HATTORI Masashi <gyo@he.mirai.ne.jp>
; を改造してでっち上げた。
; 基本的に色分けとインデント。

; siteinit.lか.xyzzyに以下を追加。
;
;; (require "lua")
;; (push '("\\.lua$" . lua-mode) *auto-mode-alist*)


(provide "lua")

(in-package "editor")

(export '(lua-mode
	  *lua-mode-hook*
	  *lua-mode-map*
	  *lua-indent-column*
	  lua-electric-insert
	  lua-electric-close
	  lua-newline-and-indent
	  lua-indent-line
	  lua-completion
	  lua-autoindent-d
	  lua-autoindent-e))

(defvar *lua-mode-hook* nil)
(defvar *lua-comment-column* nil)

(defvar *lua-keyword-hash-table* nil)
(defvar *lua-keyword-file* "lua")
(defvar *lua-completion-list* nil)

(defvar *lua-indent-column* 2
  "インデントで入れるスペースの数（で、いいのかな？）")

(defvar *lua-variables-regexp*
  (compile-regexp-keyword-list
   '(
     ("\$[a-zA-Z_][a-zA-Z0-9_]+" t (:keyword 1))
     )))

(defvar *lua-mode-syntax-table* nil)
(unless *lua-mode-syntax-table*
  (setq *lua-mode-syntax-table* (make-syntax-table))
  (do ((x #x21 (1+ x)))
      ((>= x #x7f))
    (let ((c (code-char x)))
      (unless (alphanumericp c)
	(set-syntax-punctuation *lua-mode-syntax-table* c)))
  )
  (set-syntax-string *lua-mode-syntax-table* #\")
  (set-syntax-string *lua-mode-syntax-table* #\')
  (set-syntax-word *lua-mode-syntax-table* #\_)
  (set-syntax-escape *lua-mode-syntax-table* #\\)
  (set-syntax-symbol *lua-mode-syntax-table* #\?)
  (set-syntax-symbol *lua-mode-syntax-table* #\=)
  (set-syntax-match *lua-mode-syntax-table* #\( #\))
  (set-syntax-match *lua-mode-syntax-table* #\{ #\})
  (set-syntax-match *lua-mode-syntax-table* #\[ #\])
  (set-syntax-start-c++-comment *lua-mode-syntax-table* #\-)
  (set-syntax-end-c++-comment *lua-mode-syntax-table* #\LFD)
)

(defvar *lua-mode-map* nil)
(unless *lua-mode-map*
  (setq *lua-mode-map* (make-sparse-keymap))
  (define-key *lua-mode-map* #\{ 'lua-electric-insert)
  (define-key *lua-mode-map* #\} 'lua-electric-close)
  (define-key *lua-mode-map* #\C-h 'backward-delete-char-untabify-or-selection)
  (define-key *lua-mode-map* #\TAB 'lua-indent-line)
  (define-key *lua-mode-map* #\M-TAB 'lua-completion)
  (define-key *lua-mode-map* #\RET 'lua-newline-and-indent)
  (define-key *lua-mode-map* #\d 'lua-autoindent-d)
  (define-key *lua-mode-map* #\e 'lua-autoindent-e)
)

(defvar *lua-mode-abbrev-table* nil)
(unless *lua-mode-abbrev-table*
  (define-abbrev-table '*lua-mode-abbrev-table*))

(defun lua-newline-and-indent (&optional (arg 1))
  (interactive "*p")
  (delete-trailing-spaces)
  (insert #\LFD arg)
  (lua-indent-line))

(defun lua-electric-insert (&optional (arg 1))
  (interactive "*p")
  (self-insert-command arg)
  (lua-indent-line))

(defun lua-electric-close (&optional (arg 1))
  (interactive "*p")
  (self-insert-command arg)
  (lua-indent-line)
  (save-excursion
    (forward-char -1)
    (and (goto-matched-parenthesis)
	 (show-matched-parenthesis)))
  t)

; c-indent-lineから
(defun lua-indent-line ()
  (interactive "*")
  (if (or (not (interactive-p))
	  *c-tab-always-indent*
	  (save-excursion
	    (skip-chars-backward " \t")
	    (bolp)))
      ; ここを変えただけ
      (let ((column (calc-lua-indent)))
	(when (integerp column)
	  (save-excursion
	    (goto-bol)
	    (delete-region (point)
			   (progn
			     (skip-chars-forward " \t")
			     (point)))
	    (indent-to column)))
	(if (and (bolp) column)
	    (skip-chars-forward " \t")))
    (insert "\t"))
  t)

(defun lua-previous-line ()
  "空行じゃない行まで戻る"
  (while (forward-line -1)
    (unless (lua-space-line)
      (if (looking-at "\\[\\["); [[ ... ]] を飛ばす
	  (while (forward-line -1)
	    (when (looking-at "\\]\\]")
	      (forward-line -1)
	      (return)))
	(return-from lua-previous-line t)))))

(defun lua-space-line ()
  "空行かどうか（ってこうやって調べるものなのか？）"
  (save-excursion
    (goto-bol)
    (looking-at "[ \t]*$")))

(defvar *lua-block-keywords-re*
  (compile-regexp "[\(\)\{\}]\\|\\<\\(do\\|function\\|end\\|if\\|then\\|else\\elseif\\|repeat\\|until\\)\\>"))
(defvar *lua-block-beg-re*
  (compile-regexp "[\(\{]\\|\\<\\(function\\|do\\|if\\|repeat\\)\\>"))
(defvar *lua-block-mid-re*
  (compile-regexp "\\<\\(then\\|else\\|elseif\\)\\>"))
(defvar *lua-block-end-re*
  (compile-regexp "[\)\}]\\|\\<end\\|until\\>"))

(defun current-indent ()
  (save-excursion
    (goto-bol)
    (skip-chars-forward " \t")
    (current-column)))

(defvar *lua-block-pair*
  '(("(" . ")") ("{" . "}") ("do" . "end") ("repeat" . "until") ("function" . "end")
    ("if" . "then") ("then" . "else") ("then" . "elseif") ("else" . "end") ("elseif" . "end") ("then" . "end")))

(defun check-pair (beg end)
  (reduce (lambda (f pair) (or f (and (string= beg (car pair)) (string= end (cdr pair)))))
            *lua-block-pair* :initial-value nil))

(defun scan-parent ()
  (let ((stk '()))
    (while (scan-buffer *lua-block-keywords-re* :reverse t :no-dup t)
      (let ((key (match-string 0)))
        (cond
         ((string-looking-at *lua-block-end-re* key) (push key stk))
         ((string-looking-at *lua-block-beg-re* key)
          (if (null stk) (return (current-indent))
            (if (check-pair key (car stk)) (pop stk)
              (error "ネストの対応がとれません"))))
         ((string-looking-at *lua-block-mid-re* key)
          (if (null stk) (return (current-indent))
            (if (check-pair key (car stk)) (progn (pop stk) (push key stk))
              (error (format nil "ネストの対応がとれません(~A ～ ~A)" key (car stk)))))))))))

(defun calc-lua-indent ()
  "インデントする数を数える"
  (let ((column 0) (curp (point)) (parent 0) (ind 0))
    (save-excursion
      (when (lua-previous-line)
        (setq column (current-indent)))) ; 前の行のインデントを取得
    (save-excursion
      (goto-bol)
      (setq parent (scan-parent))
      (when (typep parent 'number)
        (setq column (+ parent *lua-indent-column*))))
    (save-excursion
      (goto-bol)
      (skip-chars-forward " \t")
      ; 行頭が閉じものであればインデント数を減らす
      (if (or (looking-at *lua-block-end-re*)
              (looking-at *lua-block-mid-re*))
          (setq column (- column *lua-indent-column*))))
    column))

(defun lua-completion ()
  "キーワードから補完"
  (interactive)
  (or *lua-completion-list*
      (setq *lua-completion-list* (make-list-from-keyword-table *lua-keyword-hash-table*))
      (return-from lua-completion nil))
  (let ((opoint (point)))
    (when (skip-syntax-spec-backward "w_")
      (let ((from (point)))
	(goto-char opoint)
	(do-completion from opoint :list *lua-completion-list*)))))

(defun lua-comment-start-skip ()
  "コメントが既にあるかどうか"
  (let ((eol (save-excursion (goto-eol) (point))))
    (while (scan-buffer "\\(^\\|[ \t]\\)\\(#+\\)[ \t]*"
			:regexp t :limit eol :tail t)
      (unless (eq (parse-point-syntax (match-end 2)) :string)
	(goto-char (match-beginning 2))
	(return-from lua-comment-start-skip (match-end 0)))))
  (goto-eol)
  nil)

(defun lua-comment-indent ()
  "コメント用インデントコマンド"
  (generic-comment-indent "--" #'calc-lua-indent))

; 直前にstrがあればインデントする関数fnを作る関数
(defun mk-lua-autoindent (fn str)
  (setf (symbol-function fn)
	(lambda (&optional (arg 1))
	  (interactive "*p")
	  (self-insert-command arg)
	  (if (and (not (eq (parse-point-syntax) :string)) (looking-back str))
	      (lua-indent-line)))))

; endを打ち終わったらインデント
(mk-lua-autoindent 'lua-autoindent-d "end")

; elseを打ち終わったらインデント
(mk-lua-autoindent 'lua-autoindent-e "else")


(defun lua-mode ()
  (interactive)
  (kill-all-local-variables)
  (setq mode-name "lua")
  (setq buffer-mode 'lua-mode)
  (use-syntax-table *lua-mode-syntax-table*)
  (use-keymap *lua-mode-map*)
  (make-local-variable 'mode-specific-indent-command)
  (setq mode-specific-indent-command #'lua-indent-line)
  (make-local-variable 'paragraph-start)
  (setq paragraph-start "^$\\|\f")
  (make-local-variable 'paragraph-separate)
  (setq paragraph-separate paragraph-start)
  (make-local-variable 'indent-tabs-mode)
  (setq indent-tabs-mode nil)
  (make-local-variable 'build-summary-function)
  (setq build-summary-function 'lua-build-summary-of-functions)
  (and *lua-keyword-file*
       (null *lua-keyword-hash-table*)
       (setq *lua-keyword-hash-table*
	     (load-keyword-file *lua-keyword-file*)))
  (when *lua-keyword-hash-table*
    (make-local-variable 'keyword-hash-table)
    (setq keyword-hash-table *lua-keyword-hash-table*))
  (make-local-variable 'regexp-keyword-list)
  (setq regexp-keyword-list *lua-variables-regexp*)
  (setq *local-abbrev-table* *lua-mode-abbrev-table*)
  (setq comment-start "-- ")
  (setq comment-end "")
  (setq comment-start-skip-function 'lua-comment-start-skip)
  (setq comment-indent-function 'lua-comment-indent)
  (when *lua-comment-column*
    (setq comment-column *lua-comment-column*))
  (run-hooks '*lua-mode-hook*)
)
