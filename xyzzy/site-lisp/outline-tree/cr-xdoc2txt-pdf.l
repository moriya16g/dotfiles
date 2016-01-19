;;; -*- Mode: Lisp; Package: OUTLINE-TREE2 -*-
;;; cr-xdoc2txt-pdf.l --- outline-tree

;; Copyright (C) 2001-2005 OHKUBO Hiroshi <ohkubo@s53.xrea.com>

;; Author: OHKUBO Hiroshi <ohkubo@s53.xrea.com>
;; Time-stamp: <2005/11/12 14:11:01 +0900>

;;; Code:

(provide "outline-tree/cr-xdoc2txt-pdf")

(require "outline-tree/outline-tree")

(in-package "outline-tree2")

;; xdoc2txt PDF �y�[�W��؂�
(defun outline-tree-create-outline-xdoc2txt-pdf (root-node)
  (let (from to title-range title)
    (goto-char (point-min))
    (loop
      (setq from (point))
      (if (scan-buffer "^--[0-9]+/[0-9]+--$" :regexp t)
          (progn
            (setq title (match-string 0))
            (setq title-range (cons (match-beginning 0) (match-end 0)))
            (goto-eol)
            (forward-char)
            (setq to (point))
            (outline-tree-insert-range-node
             title root-node
             :title-range title-range :whole-range (cons from to)
             :sub-type :heading-node))
        (progn
          (goto-char (point-max))
          (when (= from (point))
            (return))
          (outline-tree-insert-range-node
           "" root-node
           :title-range nil :whole-range (cons from nil)
           :sub-type :heading-node)
          (return))))))
(outline-tree-add-create-outline-function
 'outline-tree-create-outline-xdoc2txt-pdf "xdoc2txt : PDF (�y�[�W��؂�)" '(:format :line-oriented :sequential)
 "xdoc2txt �ɂ���ĕϊ����ꂽ PDF �t�H�[�}�b�g���A�y�[�W�ԍ��ŋ�؂�ꂽ
�e�L�X�g�� 1 �m�[�h�Ƃ��ăA�E�g���C���\�����܂��B
�A�E�g���C����ɂ̓y�[�W�ԍ���\�����܂��B")

;;; cr-xdoc2txt-pdf.l ends here