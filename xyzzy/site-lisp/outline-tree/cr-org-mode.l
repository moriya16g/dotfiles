;;; -*- Mode: Lisp; Package: OUTLINE-TREE2 -*-
;;; cr-org-mode.l --- outline-tree

;; Copyright (C) 2020 Shigeru Moriya

;; Author: Shigeru Moriya
;; Time-stamp: <2020/04/28 16:47:00 +0900>

;;; Code:

(provide "outline-tree/cr-org-mode")

(require "outline-tree/outline-tree")
(require "outline-tree/cr-regexp-internal")

(in-package "outline-tree2")

;; Markdown フォーマット
(defun outline-tree-create-outline-org-mode (root-node)
  (outline-tree-create-outline-regexp-internal
   :root-node root-node
   :layer-regexp-list-order :any-miss
   :layer-regexp-list '("^\\(\\(\* .+\\)\\|\\(.+\\)\n=+\\)"
                        "^\\(\\(\*\* .+\\)\\|\\(.+\\)\n-+\\)"
                        "^\\(\*\*\* .+\\)"
                        "^\\(\*\*\*\* .+\\)"
                        "^\\(\*\*\*\*\* .+\\)"
                        "^\\(\*\*\*\*\*\* .+\\)")
   :layer-regexp-list-case-fold nil
   :sub-type :heading-node
   :line-oriented nil
   :title-converter #'outline-tree-create-outline-org-mode-title-converter))
(outline-tree-add-create-outline-function
 'outline-tree-create-outline-org-mode "org-mode" '(:type-document :line-oriented :sequential)
 "org-mode フォーマットをアウトライン表示します。")

;;
(defun outline-tree-create-outline-org-mode-title-converter (str)
  (if (string-match "^\*" str)
      (progn
        (setq str (substitute-string str "^\*+ " ""))
        (setq str (substitute-string str "\*+$" ""))
        str)
    str))

;;; cr-org-mode.l ends here
