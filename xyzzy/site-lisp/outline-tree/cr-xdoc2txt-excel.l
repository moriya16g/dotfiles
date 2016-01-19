;;; -*- Mode: Lisp; Package: OUTLINE-TREE2 -*-
;;; cr-xdoc2txt-excel.l --- outline-tree

;; Copyright (C) 2001-2005 OHKUBO Hiroshi <ohkubo@s53.xrea.com>

;; Author: OHKUBO Hiroshi <ohkubo@s53.xrea.com>
;; Time-stamp: <2005/11/12 14:11:25 +0900>

;;; Code:

(provide "outline-tree/cr-xdoc2txt-excel")

(require "outline-tree/outline-tree")
(require "outline-tree/cr-regexp-internal")

(in-package "outline-tree2")

;; xdoc2txt Excel �t�H�[�}�b�g
(defun outline-tree-create-outline-xdoc2txt-excel (root-node)
  (outline-tree-create-outline-regexp-internal
   :root-node root-node
   :layer-regexp-list
   '("^\\[\\(.+\\)\\]$")
   :layer-regexp-list-case-fold nil
   :layer-regexp-list-order :non-miss
   :sub-type :heading-node))
(outline-tree-add-create-outline-function
 'outline-tree-create-outline-xdoc2txt-excel "xdoc2txt : Excel" '(:format :line-oriented :sequential)
 "xdoc2txt �ɂ���ĕϊ����ꂽ Excel �t�H�[�}�b�g���A�E�g���C���\�����܂��B
�A�E�g���C����ɂ̓V�[�g����\�����܂��B")

;;; cr-xdoc2txt-excel.l ends here