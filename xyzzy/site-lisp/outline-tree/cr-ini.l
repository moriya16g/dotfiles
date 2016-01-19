;;; -*- Mode: Lisp; Package: OUTLINE-TREE2 -*-
;;; cr-ini.l --- outline-tree

;; Copyright (C) 2001-2004 OHKUBO Hiroshi <ohkubo@s53.xrea.com>

;; Author: OHKUBO Hiroshi <ohkubo@s53.xrea.com>
;; Time-stamp: <2005/11/12 14:26:24 +0900>

;;; Code:

(provide "outline-tree/cr-ini")

(require "outline-tree/outline-tree")
(require "outline-tree/cr-regexp-internal")
(require "outline-tree/cr-range-internal")

(in-package "outline-tree2")

;; INI ファイル (Section のみ) 解析
(defun outline-tree-create-outline-ini-section (root-node)
  (outline-tree-create-outline-regexp-internal
   :root-node root-node
   :layer-regexp-list '("^\\(\\[.+\\]\\)$")
   :layer-regexp-list-case-fold nil
   :layer-regexp-list-order :non-miss
   :sub-type :heading-node
   :line-oriented t))
(outline-tree-add-create-outline-function
 'outline-tree-create-outline-ini-section "INI (セクションのみ)" '(:format :line-oriented :sequential)
 "INI ファイルをセクション毎に表示します。")

;; INI ファイル 解析
(defun outline-tree-create-outline-ini (root-node)
  (outline-tree-create-outline-regexp-internal
   :root-node root-node
   :layer-regexp-list '("^\\(\\[.+\\]\\)$")
   :layer-regexp-list-case-fold nil
   :layer-regexp-list-order :non-miss
   :sub-type :heading-node
   :line-oriented t
   :create-sub-outline-func
   #'(lambda (root-node)
       (outline-tree-create-outline-range-internal
        :root-node root-node
        :get-range-func #'outline-tree-create-outline-ini-get-range-item))))
(outline-tree-add-create-outline-function
 'outline-tree-create-outline-ini "INI" '(:format :line-oriented :sequential)
 "INI ファイルをセクション、項目毎に表示します。")

;;
(defun outline-tree-create-outline-ini-get-range-item ()
  (let (begin-range end-range name)
    (save-excursion
      (when (scan-buffer "^.*[^ \t\n].*$" :regexp t)
        (setq begin-range (cons (point) (point)))
        (setq name (match-string 0))
        (goto-eol)
        (if (forward-char)
            (setq end-range (cons (point) (point)))
          (setq end-range (cons nil nil)))))
    (values begin-range end-range name)))

;;; cr-ini.l ends here
