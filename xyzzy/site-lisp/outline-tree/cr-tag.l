;;; -*- Mode: Lisp; Package: OUTLINE-TREE2 -*-
;;; cr-tag.l --- outline-tree

;; Copyright (C) 2001-2006 OHKUBO Hiroshi <ohkubo@s53.xrea.com>

;; Author: OHKUBO Hiroshi <ohkubo@s53.xrea.com>
;; Time-stamp: <2006/02/27 10:05:51 +0900>

;;; Commentary:

;; Memo:
;;      ・#\< #\> が set-syntax-tag されているモードでのみ動作する。
;;

;;; Code:

(provide "outline-tree/cr-tag")

(require "outline-tree/outline-tree")
(require "outline-tree/cr-range-internal")
(require "outline-tree/public-utils")

(in-package "outline-tree2")

;; TAG 解析
(defun outline-tree-create-outline-tag (root-node)
  (outline-tree-create-outline-range-internal
   :root-node root-node
   :get-range-func #'outline-tree-create-outline-tag-get-range-tag
   :create-contents-outline-func
   #'(lambda (root-node range-name)
       (outline-tree-create-outline-tag root-node))))
(outline-tree-add-create-outline-function
 'outline-tree-create-outline-tag "タグ (HTML,XML)" '(:language)
 "開始タグ/終了タグのペアからなる階層構造を表示します。
<...> をタグと認識するモード (ex: html-mode) でのみ動作します。")

;;
(defun outline-tree-create-outline-tag-get-range-tag ()
  (let (begin-range end-range name
        matched-tag-range current-tag-range current-tag-type tagname)
    (save-excursion
      (loop
        (multiple-value-setq (matched-tag-range current-tag-range current-tag-type tagname)
          (outline-tree-get-matched-tag))
        (when (and matched-tag-range (eq current-tag-type :open))
          (setq begin-range current-tag-range
                end-range matched-tag-range
                name (buffer-substring (outline-tree-get-range-from begin-range)
                                       (outline-tree-get-range-to begin-range)))
          (setq name (substitute-string name "[\t\n]" " "))
          (setq name (substitute-string name " +" " "))
          (return-from outline-tree-create-outline-tag-get-range-tag
            (values begin-range end-range name)))
        (unless (outline-tree-goto-next-tag)
          (return))))))

;;; cr-tag.l ends here
