;;; -*- Mode: Lisp; Package: OUTLINE-TREE2 -*-
;;; get-outline-function.l --- outline-tree

;; Copyright (C) 2001-2006 OHKUBO Hiroshi <ohkubo@s53.xrea.com>

;; Author: OHKUBO Hiroshi <ohkubo@s53.xrea.com>
;; Time-stamp: <2006/10/21 17:16:37 +0900>

;;; Code:

(provide "outline-tree/get-outline-function")

(require "outline-tree/outline-tree")

(in-package "outline-tree2")

(defvar *outline-tree-get-default-create-outline-function-advice-func* nil
  "buffer を与えられて、アウトライン作成関数を返す関数
outline-tree-get-default-create-outline-function の初めの判定で用いる。")

(let (cache-buffer cache-buffer-modified-count cache-func)
  (defun outline-tree-get-default-create-outline-function (&optional buffer)
    (unless buffer
      (setq buffer (outline-tree-get-target-buffer)))
    ;; 判定結果をキャッシュから返す。
    ;; buffer と buffer-modified-count のチェックのみで、完全なチェックではない。
    ;; 完全ではないが、実用上問題ないと判断。
    (when (and (eq cache-buffer buffer)
               (eql cache-buffer-modified-count (buffer-modified-count buffer)))
      (return-from outline-tree-get-default-create-outline-function cache-func))
    ;; キャッシュの更新
    (setq cache-buffer buffer
          cache-buffer-modified-count (buffer-modified-count buffer))
    ;; 判定
    (let ((buffer-name (buffer-name buffer))
          (buffer-mode (save-excursion (set-buffer buffer) buffer-mode))
          (mode-name (save-excursion (set-buffer buffer) mode-name))
          func)
      ;; ユーザ指定
      (when (and *outline-tree-get-default-create-outline-function-advice-func*
                 (setq func (funcall *outline-tree-get-default-create-outline-function-advice-func* buffer)))
        (setq cache-func func)
        (return-from outline-tree-get-default-create-outline-function func))
      ;; 組み込み指定
      (when (string-match "\\(.+\\)\\(<[0-9]+>\\)$" buffer-name)
        (setq buffer-name (match-string 1)))
      (setq cache-func
            (cond
             ((member buffer-mode '(ed::html-mode))
              'outline-tree-create-outline-html-info-and-heading)
             ((string-equal "HTML+" mode-name)
              'outline-tree-create-outline-html-info-and-heading)
             ((string-matchp "\\.\\(html\\|htm\\)$" buffer-name)
              'outline-tree-create-outline-html-info-and-heading)
             ((string-matchp "\\.xml$" buffer-name)
              'outline-tree-create-outline-tag)
             ((member buffer-mode '(ed::css-mode))
              'outline-tree-create-outline-css)
             ((string-matchp "\\.css$" buffer-name)
              'outline-tree-create-outline-css)
             ((member buffer-mode '(ed::lisp-mode ed::lisp-interaction-mode))
              'outline-tree-create-outline-lisp)
             ((or (string-matchp "\\.l$" buffer-name)
                  (string-matchp "^\\.xyzzy$" buffer-name))
              'outline-tree-create-outline-lisp)
             ((member buffer-mode '(ed::c-mode ed::c++-mode ed::csharp-mode))
              'outline-tree-create-outline-XTAGS)
             ((string-matchp "\\.\\(c\\|cc\\|cpp\\)$" buffer-name)
              'outline-tree-create-outline-XTAGS)
             ((string-matchp "\\.java$" buffer-name)
              'outline-tree-create-outline-java)
             ((string-matchp "\\.pl$" buffer-name)
              'outline-tree-create-outline-perl)
             ((string-matchp "\\.\\(ini\\|reg\\)$" buffer-name)
              'outline-tree-create-outline-ini)
             ((string-matchp "\\.tex$" buffer-name)
              'outline-tree-create-outline-LaTeX)
             ((string-matchp "\\.rd$" buffer-name)
              'outline-tree-create-outline-rd)
             ((string-matchp "\\.edf$" buffer-name)
              'outline-tree-create-outline-eMemoPad)
             ((string-matchp "\\.info$" buffer-name)
              'outline-tree-create-outline-info)
             ((string-matchp "\\.texinfo$" buffer-name)
              'outline-tree-create-outline-texinfo)
             ((string-matchp "\\.pdf$" buffer-name)
              'outline-tree-create-outline-xdoc2txt-pdf)
             ((string-matchp "\\.xls$" buffer-name)
              'outline-tree-create-outline-xdoc2txt-excel)
             ((string-matchp "\\.\\(bas\\|frm\\|mb\\|cls\\)$" buffer-name)
              'outline-tree-create-outline-VB-like)
             ((string-matchp "\\.asp$" buffer-name)
              'outline-tree-create-outline-ASP-VBScript)
             ((string-matchp "changelog" buffer-name)
              'outline-tree-create-outline-changelog)
             ((string-matchp "hiki" buffer-name)
              'outline-tree-create-outline-hiki)
             ((string-matchp "sted" buffer-name)
              'outline-tree-create-outline-sted)
             ((string-matchp "^rfc.*\\.txt$" buffer-name)
              'outline-tree-create-outline-RFC)
             ((string-matchp "2ch: Thread:" buffer-name)
              'outline-tree-create-outline-2ch-thread)
             ((buffer-local-value buffer 'ed::*find-error-scanner*)
              'outline-tree-create-outline-grep)
             ((let ((table (syntax-table buffer)))
                (and (syntax-open-tag-p #\< table)
                     (syntax-close-tag-p #\> table)))
              'outline-tree-create-outline-tag)
             ((save-excursion
                (set-buffer buffer)
                (and (boundp 'ed::build-summary-function)
                     ed::build-summary-function))
              'outline-tree-create-outline-list-function)
             ((member buffer-mode '(ed::text-mode ed::fundamental-mode))
              'outline-tree-create-outline-topic)
             (t
              'outline-tree-create-outline-blank-line))))))

;;; get-outline-function.l ends here
