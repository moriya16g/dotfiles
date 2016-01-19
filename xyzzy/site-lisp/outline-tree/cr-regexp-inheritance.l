;;; -*- Mode: Lisp; Package: OUTLINE-TREE2 -*-
;;; cr-regexp-inheritance.l --- outline-tree

;; Copyright (C) 2001-2006 OHKUBO Hiroshi <ohkubo@s53.xrea.com>

;; Author: OHKUBO Hiroshi <ohkubo@s53.xrea.com>
;; Time-stamp: <2006/08/25 12:07:17 +0900>

;;; Code:

(provide "outline-tree/cr-regexp-inheritance")

(require "outline-tree/outline-tree")
(require "outline-tree/cr-regexp-internal")

(in-package "outline-tree2")

;; �s����؂�
(defun outline-tree-create-outline-line (root-node)
  (outline-tree-create-outline-regexp-internal
   :root-node root-node
   :layer-regexp-list '("^\\(.+$\\|\n\\)")
   :layer-regexp-list-case-fold nil
   :layer-regexp-list-order :non-miss
   :line-oriented t
   :title-converter #'(lambda (str) (if (string= "\n" str) "" str))))
(outline-tree-add-create-outline-function
 'outline-tree-create-outline-line "�s����؂�(�S�s)" '(:generic :line-oriented :sequential)
 "�e�s��S�ĕ\�����܂��B
�e�s�̓��ւ������ɓK���Ă��܂��B")

;; �C���f���g�����s����؂�
(defun outline-tree-create-outline-no-space-line (root-node)
  (outline-tree-create-outline-regexp-internal
   :root-node root-node
   :layer-regexp-list '("^[^ �@\t\n].*$")
   :layer-regexp-list-case-fold nil
   :layer-regexp-list-order :non-miss
   :line-oriented t))
(outline-tree-add-create-outline-function
 'outline-tree-create-outline-no-space-line "�s����؂�(�C���f���g�����s��)" '(:generic :line-oriented :sequential)
 "�s���ɃC���f���g���Ȃ��s�ŋ�؂�܂��B")

;; �o�b�`�t�@�C�� ���
(defun outline-tree-create-outline-bat (root-node)
  (outline-tree-create-outline-regexp-internal
   :root-node root-node
   :layer-regexp-list '("^\\(:\\S+\\)$")
   :layer-regexp-list-case-fold t
   :layer-regexp-list-order :non-miss
   :line-oriented t))
(outline-tree-add-create-outline-function
 'outline-tree-create-outline-bat "BAT (���x��)" '(:misc :line-oriented :sequential)
 "�o�b�`�t�@�C�� (*.bat) ���s���̃��x�� (:***) ���ɕ\�����܂��B")

;; LISP �R�����g ���
(defun outline-tree-create-outline-lisp-comment (root-node)
  (outline-tree-create-outline-regexp-internal
   :root-node root-node
   :layer-regexp-list
   '("^;;;?"
     "^ *(\\(?:[a-zA-Z]+::?\\)?\\(?:defun\\|defmacro\\|defvar\\|defvar-local\\|defconstant\\|define-dll-entry\\)")
   :layer-regexp-list-case-fold nil
   :layer-regexp-list-order :top-miss))
(outline-tree-add-create-outline-function
 'outline-tree-create-outline-lisp-comment "LISP (�R�����g)" '(:language :line-oriented :sequential)
 "LISP �t�@�C�����s���� \";;\" �Ŏn�܂�R�����g�ƁA�e���` S ����
�A�E�g���C���\�����܂��B")

;; info �t�H�[�}�b�g
(defun outline-tree-create-outline-info (root-node)
  (outline-tree-create-outline-regexp-internal
   :root-node root-node
   :layer-regexp-list
   '("^\\([^ \t\n].+\\)\n\\*\\{2,\\}$"
     "^\\([^ \t\n].+\\)\n=\\{2,\\}$"
     "^\\([^ \t\n].+\\)\n-\\{2,\\}$"
     "^\\([^ \t\n].+\\)\n\\.\\{2,\\}$")
   :layer-regexp-list-case-fold nil
   :layer-regexp-list-order :top-miss
   :sub-type :heading-node))
(outline-tree-add-create-outline-function
 'outline-tree-create-outline-info "info" '(:format :line-oriented :sequential)
 "info �t�H�[�}�b�g���A�E�g���C���\�����܂��B")

;; ChangeLog �t�H�[�}�b�g
(defun outline-tree-create-outline-changelog (root-node)
  (outline-tree-create-outline-regexp-internal
   :root-node root-node
   :layer-regexp-list
   '("^\\([^ \t\n].+\\)"
     "^\t\\* \\(.+\\)")
   :layer-regexp-list-case-fold nil
   :layer-regexp-list-order :non-miss
   :sub-type :heading-node
   :line-oriented t))
(outline-tree-add-create-outline-function
 'outline-tree-create-outline-changelog "ChangeLog" '(:format :line-oriented :sequential)
 "ChangeLog �t�H�[�}�b�g���A�E�g���C���\�����܂��B")

;; roff �t�H�[�}�b�g
(defun outline-tree-create-outline-roff (root-node)
  (outline-tree-create-outline-regexp-internal
   :root-node root-node
   :layer-regexp-list
   '("^\\.TH \\(.+\\)$"
     "^\\.SH \"?\\(.+?\\)\"? *$"
     "^\\.[^ \n]+ \"?\\(.+?\\)\"? *$")
   :layer-regexp-list-case-fold nil
   :layer-regexp-list-order :any-miss
   :line-oriented t
   :sub-type :heading-node))
(outline-tree-add-create-outline-function
 'outline-tree-create-outline-roff "roff" '(:format :line-oriented :sequential)
 "roff �t�H�[�}�b�g���A�E�g���C���\�����܂��B")

;; Java ���
(defun outline-tree-create-outline-java (root-node)
  (outline-tree-create-outline-regexp-internal
   :root-node root-node
   :layer-regexp-list
   '("^[ \t]*\\(\\(?:package\\|import\\|[^{\n]*?class[ \t]+[a-zA-Z]+\\).*\\)[ \t]*[;{]"
     "^[ \t]*\\([^{\n()]*?\\(?:public\\|private\\)[^{\n()]*?[a-zA-Z]+[ \t]*(.*)[^(){}]*\\)[ \t]*{")
   :layer-regexp-list-case-fold nil
   :layer-regexp-list-order :non-miss))
(outline-tree-add-create-outline-function
 'outline-tree-create-outline-java "Java" '(:language :line-oriented :sequential)
 "Java �������ɊȈՓI�ȕ��@�ŃA�E�g���C���\�����܂��B
���p�ɑς�������ɂ͎����Ă��܂���B")

;;; cr-regexp-inheritance.l ends here