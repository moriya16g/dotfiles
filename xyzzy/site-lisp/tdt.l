; フック
(defvar *tdt-mode-hook* nil)

; キーマップ
(defvar *tdt-mode-map* nil)
(unless *tdt-mode-map*
  (setq *tdt-mode-map* (make-sparse-keymap)))

; キーワード
(defvar *tdt-keyword-hash-table* nil)
(defvar *tdt-keyword-file* "TDT")

; シンタックステーブル
; コメント表示処理
(defvar *tdt-mode-syntax-table* nil)
(unless *tdt-mode-syntax-table*
  (setq *tdt-mode-syntax-table* (make-syntax-table))
  (set-syntax-symbol *tdt-mode-syntax-table* #\$)
  (set-syntax-start-comment *tdt-mode-syntax-table* #\# t)
  (set-syntax-end-comment *tdt-mode-syntax-table* #\LFD t t))

 



(defun tdt-mode ()
  (interactive)
  (kill-all-local-variables)
  (setq buffer-mode 'tdt-mode)
  (setq mode-name "TDT")
  (use-keymap *tdt-mode-map*)
  (use-syntax-table *tdt-mode-syntax-table*)
  ; キーワードのロード
  (and *tdt-keyword-file*
       (null *tdt-keyword-hash-table*)
       (setq *tdt-keyword-hash-table*
	     (load-keyword-file *tdt-keyword-file* t)))
  (when *tdt-keyword-hash-table*
    (make-local-variable 'keyword-hash-table)
    (setq keyword-hash-table *tdt-keyword-hash-table*))
  ; フックの実行
  (run-hooks '*tdt-mode-hook*))

