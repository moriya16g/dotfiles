;;; -*- Mode: Lisp; Package: OUTLINE-TREE2 -*-
;;; cr-hierarchy-inheritance.l --- outline-tree

;; Copyright (C) 2001-2006 OHKUBO Hiroshi <ohkubo@s53.xrea.com>

;; Author: OHKUBO Hiroshi <ohkubo@s53.xrea.com>
;; Time-stamp: <2006/10/21 17:15:52 +0900>

;;; Code:

(provide "outline-tree/cr-hierarchy-inheritance")

(require "outline-tree/outline-tree")
(require "outline-tree/cr-hierarchy-internal")

(in-package "outline-tree2")

;; �K�w�t���e�L�X�g�t�H�[�}�b�g
(defun outline-tree-create-outline-hierarchy-dot (root-node)
  (outline-tree-create-outline-hierarchy-internal
   :root-node root-node
   :char #\.
   :sub-type :heading-node))
(outline-tree-add-create-outline-function
 'outline-tree-create-outline-hierarchy-dot "�K�w�t���e�L�X�g" '(:format :line-oriented :sequential)
 "�K�w�t���e�L�X�g���K�w�\�����܂��B
�K�w���x���͍s���� . (�h�b�g)�̐��Ŏw�肵�܂��B")

;;; cr-hierarchy-inheritance.l ends here