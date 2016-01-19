;;; -*- Mode: Lisp; Package: OUTLINE-TREE2 -*-
;;; app-menu.l --- outline-tree

;; Copyright (C) 2001-2006 OHKUBO Hiroshi <ohkubo@s53.xrea.com>

;; Author: OHKUBO Hiroshi <ohkubo@s53.xrea.com>
;; Time-stamp: <2006/10/21 17:15:12 +0900>

;;; Code:

(provide "outline-tree/app-menu")

(require "outline-tree/defs")
(require "outline-tree/outline-tree")

(in-package "outline-tree2")

(defun outline-tree-create-app-menu ()
  "���j���[���쐬"
  (setq *outline-tree-app-menu* nil)
  (unless *outline-tree-app-menu*
    (let ((menu (create-popup-menu 'outline-tree)))
      (add-menu-item menu 'outline-tree-create-outline-by-node
                     "�A�E�g���C���̍쐬/�X�V(&A)"
                     'outline-tree-create-outline-by-node
                     #'(lambda () (or (and (outline-tree-exist-p)
                                           (outline-tree-get-buffer-by-node)) :disable)))
      (add-menu-item menu 'outline-tree-delete-outline-by-node
                     "�A�E�g���C���̍폜(&B)"
                     'outline-tree-delete-outline-by-node
                     #'(lambda ()
                         (or (and (outline-tree-exist-p)
                                  (outline-tree-exist-outline-p-by-node)) :disable)))
      (add-popup-menu menu
                      *outline-tree-create-outline-function-menu*
                      "�A�E�g���C���^�C�v�I��(&S)")
      (add-popup-menu menu
                      *outline-tree-create-outline-function-info-menu*
                      "�A�E�g���C���^�C�v����(&P)")
      (add-popup-menu menu
                      (define-popup-menu
                        (:item 'outline-tree-gen-cr-user-topic
                         "�u���o����́v�ݒ肩��(&T)"
                         #'(lambda () (interactive)
                             (treeview::treeview-focus-editor)
                             (outline-tree-gen-cr-user-topic))
                         #'(lambda () (or (and (outline-tree-exist-p)
                                               (outline-tree-get-buffer-node-by-node)) :disable)))
                        (:item 'outline-tree-gen-cr-user-regexp
                         "�u���K�\���v�ݒ肩��(&R)"
                         #'(lambda () (interactive)
                             (treeview::treeview-focus-editor)
                             (outline-tree-gen-cr-user-regexp))
                         #'(lambda () (or (and (outline-tree-exist-p)
                                               (outline-tree-get-buffer-node-by-node)) :disable))))
                      "�A�E�g���C���쐬�֐��̐���(&G)")
      (add-menu-separator menu)
      ;; �m�[�h�̊J��
      (add-popup-menu menu
                      (define-popup-menu
                        (:item nil
                         "��������S�ĊJ��(&C)"
                         #'(lambda () (interactive) (outline-tree-expand-expand-subtree
                                                     (outline-tree-get-selected-node)))
                         #'(lambda ()
                             (or (and (outline-tree-exist-p)
                                      (let ((node (outline-tree-get-selected-node)))
                                        (and (outline-tree-node-valid-p node)
                                             (outline-tree-node-has-children-p node))))
                                 :disable)))
                        (:item nil
                         "��������S�ĕ���(&D)"
                         #'(lambda () (interactive) (outline-tree-expand-collapse-subtree
                                                     (outline-tree-get-selected-node)))
                         #'(lambda ()
                             (or (and (outline-tree-exist-p)
                                      (let ((node (outline-tree-get-selected-node)))
                                        (and (outline-tree-node-valid-p node)
                                             (outline-tree-node-has-children-p node))))
                                 :disable)))
                        :sep
                        (:item nil
                         "�������� 2 �K�w�J��(&2)"
                         #'(lambda () (interactive) (outline-tree-expand-expand-subtree
                                                     (outline-tree-get-selected-node) 2))
                         #'(lambda ()
                             (or (and (outline-tree-exist-p)
                                      (let ((node (outline-tree-get-selected-node)))
                                        (and (outline-tree-node-valid-p node)
                                             (outline-tree-node-has-children-p node))))
                                 :disable)))
                        (:item nil
                         "�������� 3 �K�w�J��(&3)"
                         #'(lambda () (interactive) (outline-tree-expand-expand-subtree
                                                     (outline-tree-get-selected-node) 3))
                         #'(lambda ()
                             (or (and (outline-tree-exist-p)
                                      (let ((node (outline-tree-get-selected-node)))
                                        (and (outline-tree-node-valid-p node)
                                             (outline-tree-node-has-children-p node))))
                                 :disable)))
                        :sep
                        (:item nil
                         "�ȉ��̌��o���m�[�h���S�Č�����悤�ɊJ��(&H)"
                         #'(lambda () (interactive) (outline-tree-expand-expand-subtree-show-heading-node
                                                     (outline-tree-get-selected-node)))
                         #'(lambda ()
                             (or (and (outline-tree-exist-p)
                                      (let ((node (outline-tree-get-selected-node)))
                                        (and (outline-tree-node-valid-p node)
                                             (outline-tree-node-has-children-p node))))
                                 :disable)))
                        :sep
                        (:item nil
                         "�m�[�h��S�ĊJ��(&A)"
                         #'(lambda () (interactive) (outline-tree-expand-expand-subtree 0))
                         #'(lambda () (or (outline-tree-exist-p) :disable)))
                        (:item nil
                         "�m�[�h��S�ĕ���(&B)"
                         #'(lambda () (interactive) (outline-tree-expand-collapse-subtree 0))
                         #'(lambda () (or (outline-tree-exist-p) :disable))))
                      "�m�[�h�J��(&E)")
      (add-menu-separator menu)
      ;; �͈̓m�[�h����
      (add-popup-menu menu
                      (define-popup-menu
                        (:item nil
                         "�m�[�h����ֈړ�(&P)"
                         #'(lambda () (interactive)
                             (outline-tree-swap-region-by-prev-range-node))
                         #'(lambda ()
                             (or (and (outline-tree-exist-p)
                                      (outline-tree-get-swap-target-range-node
                                       (outline-tree-get-selected-node) t))
                                 :disable)))
                        (:item nil
                         "�m�[�h�����ֈړ�(&N)"
                         #'(lambda () (interactive)
                             (outline-tree-swap-region-by-next-range-node))
                         #'(lambda ()
                             (or (and (outline-tree-exist-p)
                                      (outline-tree-get-swap-target-range-node
                                       (outline-tree-get-selected-node) nil))
                                 :disable)))
                        (:item nil
                         "�m�[�h���폜(&D)"
                         #'(lambda () (interactive)
                             (outline-tree-delete-region-by-range-node))
                         #'(lambda ()
                             (or (and (outline-tree-exist-p)
                                      (let ((node (outline-tree-get-selected-node)))
                                        (and (outline-tree-range-node-p node)
                                             (outline-tree-data-get-whole-range node))))
                                 :disable)))
                        :separator
                        (:item nil
                         "�m�[�h�̃R�s�[(&C)"
                         #'(lambda () (interactive)
                             (let ((node (outline-tree-get-selected-node)) whole-range)
                               (when (and (outline-tree-range-node-p node)
                                          (setq whole-range (outline-tree-data-get-whole-range node)))
                                 (copy-region-to-clipboard
                                  (outline-tree-get-range-from whole-range)
                                  (outline-tree-get-range-to whole-range)))))
                         #'(lambda ()
                             (or (and (outline-tree-exist-p)
                                      (let ((node (outline-tree-get-selected-node)))
                                        (and (outline-tree-range-node-p node)
                                             (outline-tree-data-get-whole-range node))))
                                 :disable)))
                        (:item nil
                         "�m�[�h�̐擪�Ɉړ�(&<)"
                         #'(lambda () (interactive)
                             (let ((node (outline-tree-get-selected-node)) whole-range)
                               (when (and (outline-tree-range-node-p node)
                                          (setq whole-range (outline-tree-data-get-whole-range node)))
                                 (goto-char (outline-tree-get-range-from whole-range))
                                 (refresh-screen))))
                         #'(lambda ()
                             (or (and (outline-tree-exist-p)
                                      (let ((node (outline-tree-get-selected-node)))
                                        (and (outline-tree-range-node-p node)
                                             (outline-tree-data-get-whole-range node))))
                                 :disable)))
                        (:item nil
                         "�m�[�h�̖����Ɉړ�(&>)"
                         #'(lambda () (interactive)
                             (let ((node (outline-tree-get-selected-node)) whole-range)
                               (when (and (outline-tree-range-node-p node)
                                          (setq whole-range (outline-tree-data-get-whole-range node)))
                                 (goto-char (1- (outline-tree-get-range-to whole-range)))
                                 (refresh-screen))))
                         #'(lambda ()
                             (or (and (outline-tree-exist-p)
                                      (let ((node (outline-tree-get-selected-node)))
                                        (and (outline-tree-range-node-p node)
                                             (outline-tree-data-get-whole-range node))))
                                 :disable))))
                      "�͈̓m�[�h����(&F)")
      (add-menu-separator menu)
      ;; �o��
      (add-popup-menu menu
                      (define-popup-menu
                        (:popup 'tree-text "�c���[�\��(&T)"
                         (:item 'outline-tree-insert-tree-text-root
                          "�c���[�\���S�Ă��e�L�X�g�o��(&A)"
                          #'(lambda () (interactive)
                              (treeview::with-app (*outline-tree-app-id*)
                                (treeview::treeview-insert-tree-text 0);node
                                (treeview::treeview-focus-editor)))
                          #'(lambda () (or (outline-tree-exist-p) :disable)))
                         (:item 'outline-tree-insert-tree-text-node
                          "���̃m�[�h�ȉ��̃c���[�\�����e�L�X�g�o��(&B)"
                          #'(lambda () (interactive)
                              (treeview::with-app (*outline-tree-app-id*)
                                (treeview::treeview-insert-tree-text
                                 (outline-tree-get-selected-node))
                                (treeview::treeview-focus-editor)))
                          #'(lambda () (or (outline-tree-exist-p) :disable))))
                        :sep
                        (:popup 'heading-node "���o���m�[�h(&H)"
                         (:popup 'buffer "�o�b�t�@�S��(&B)"
                          (:item 'outline-tree-output-heading-html-buffer
                           "�o�b�t�@�S�̂� 1�t�@�C�� HTML �o��(&A)"
                           #'(lambda () (interactive)
                               (outline-tree-output-heading-html
                                (outline-tree-get-buffer-node-by-node)))
                           #'(lambda () (or (and (outline-tree-exist-p)
                                                 (outline-tree-latest-outline-p-by-node)) :disable)))
                          (:item 'outline-tree-output-heading-html-frame-buffer
                           "�o�b�t�@�S�̂� FRAME HTML �o��(&B)"
                           #'(lambda () (interactive)
                               (outline-tree-output-heading-html-frame
                                (outline-tree-get-buffer-node-by-node)))
                           #'(lambda () (or (and (outline-tree-exist-p)
                                                 (outline-tree-latest-outline-p-by-node)) :disable)))
                          :sep
                          (:item 'outline-tree-output-heading-html-buffer-expand
                           "�o�b�t�@�S�̂̕\���m�[�h�� 1�t�@�C�� HTML �o��(&C)"
                           #'(lambda () (interactive)
                               (outline-tree-output-heading-html
                                (outline-tree-get-buffer-node-by-node) :expand))
                           #'(lambda () (or (and (outline-tree-exist-p)
                                                 (outline-tree-latest-outline-p-by-node)) :disable)))
                          (:item 'outline-tree-output-heading-html-frame-buffer-expand
                           "�o�b�t�@�S�̂̕\���m�[�h�� FRAME HTML �o��(&D)"
                           #'(lambda () (interactive)
                               (outline-tree-output-heading-html-frame
                                (outline-tree-get-buffer-node-by-node) :expand))
                           #'(lambda () (or (and (outline-tree-exist-p)
                                                 (outline-tree-latest-outline-p-by-node)) :disable)))
                          )
                         (:popup 'node "��������(&H)"
                          (:item 'outline-tree-output-heading-html-node
                           "�������� 1�t�@�C�� HTML �o��(&A)"
                           #'(lambda () (interactive) (outline-tree-output-heading-html
                                                       (outline-tree-get-selected-node)))
                           #'(lambda ()
                               (when (or (not (outline-tree-exist-p))
                                         (let ((node (outline-tree-get-selected-node)))
                                           (or (outline-tree-buffer-node-p node)
                                               (not (outline-tree-latest-outline-p-by-node node)))))
                                 :disable)))
                          (:item 'outline-tree-output-heading-html-frame-node
                           "�������� FRAME HTML �o��(&B)"
                           #'(lambda () (interactive) (outline-tree-output-heading-html-frame
                                                       (outline-tree-get-selected-node)))
                           #'(lambda ()
                               (when (or (not (outline-tree-exist-p))
                                         (let ((node (outline-tree-get-selected-node)))
                                           (or (outline-tree-buffer-node-p node)
                                               (not (outline-tree-latest-outline-p-by-node node)))))
                                 :disable)))
                          :sep
                          (:item 'outline-tree-output-heading-html-node-expand
                           "��������\���m�[�h�� 1�t�@�C�� HTML �o��(&C)"
                           #'(lambda () (interactive) (outline-tree-output-heading-html
                                                       (outline-tree-get-selected-node) :expand))
                           #'(lambda ()
                                 (when (or (not (outline-tree-exist-p))
                                           (let ((node (outline-tree-get-selected-node)))
                                             (or (outline-tree-buffer-node-p node)
                                                 (not (outline-tree-latest-outline-p-by-node node)))))
                                   :disable)))
                          (:item 'outline-tree-output-heading-html-frame-node-expand
                           "��������\���m�[�h�� FRAME HTML �o��(&D)"
                           #'(lambda () (interactive) (outline-tree-output-heading-html-frame
                                                       (outline-tree-get-selected-node) :expand))
                           #'(lambda ()
                                 (when (or (not (outline-tree-exist-p))
                                           (let ((node (outline-tree-get-selected-node)))
                                             (or (outline-tree-buffer-node-p node)
                                                 (not (outline-tree-latest-outline-p-by-node node)))))
                                   :disable)))
                          ))
                        (:popup 'range-node "�͈̓m�[�h(&R)"
                         (:popup 'buffer "�o�b�t�@�S��(&B)"
                          (:item 'outline-tree-output-range-html-buffer
                           "�o�b�t�@�S�̂� 1�t�@�C�� HTML �o��(&A)"
                           #'(lambda () (interactive)
                               (outline-tree-output-range-html
                                (outline-tree-get-buffer-node-by-node)))
                           #'(lambda () (or (and (outline-tree-exist-p)
                                                 (outline-tree-latest-outline-p-by-node)) :disable)))
                          (:item 'outline-tree-output-range-html-frame-buffer
                           "�o�b�t�@�S�̂� FRAME HTML �o��(&B)"
                           #'(lambda () (interactive)
                               (outline-tree-output-range-html-frame
                                (outline-tree-get-buffer-node-by-node)))
                           #'(lambda () (or (and (outline-tree-exist-p)
                                                 (outline-tree-latest-outline-p-by-node)) :disable)))
                          :sep
                          (:item 'outline-tree-output-range-html-buffer-expand
                           "�o�b�t�@�S�̂̕\���m�[�h�� 1�t�@�C�� HTML �o��(&C)"
                           #'(lambda () (interactive)
                               (outline-tree-output-range-html
                                (outline-tree-get-buffer-node-by-node) :expand))
                           #'(lambda () (or (and (outline-tree-exist-p)
                                                 (outline-tree-latest-outline-p-by-node)) :disable)))
                          (:item 'outline-tree-output-range-html-frame-buffer-expand
                           "�o�b�t�@�S�̂̕\���m�[�h�� FRAME HTML �o��(&D)"
                           #'(lambda () (interactive)
                               (outline-tree-output-range-html-frame
                                (outline-tree-get-buffer-node-by-node) :expand))
                           #'(lambda () (or (and (outline-tree-exist-p)
                                                 (outline-tree-latest-outline-p-by-node)) :disable)))
                          )
                         (:popup 'node "��������(&H)"
                          (:item 'outline-tree-output-range-html-node
                           "�������� 1�t�@�C�� HTML �o��(&A)"
                           #'(lambda () (interactive) (outline-tree-output-range-html
                                                       (outline-tree-get-selected-node)))
                           #'(lambda ()
                               (when (or (not (outline-tree-exist-p))
                                         (let ((node (outline-tree-get-selected-node)))
                                           (or (outline-tree-buffer-node-p node)
                                               (not (outline-tree-latest-outline-p-by-node node)))))
                                 :disable)))
                          (:item 'outline-tree-output-range-html-frame-node
                           "�������� FRAME HTML �o��(&B)"
                           #'(lambda () (interactive) (outline-tree-output-range-html-frame
                                                       (outline-tree-get-selected-node)))
                           #'(lambda ()
                               (when (or (not (outline-tree-exist-p))
                                         (let ((node (outline-tree-get-selected-node)))
                                           (or (outline-tree-buffer-node-p node)
                                               (not (outline-tree-latest-outline-p-by-node node)))))
                                 :disable)))
                          :sep
                          (:item 'outline-tree-output-range-html-node-expand
                           "��������\���m�[�h�� 1�t�@�C�� HTML �o��(&C)"
                           #'(lambda () (interactive) (outline-tree-output-range-html
                                                       (outline-tree-get-selected-node) :expand))
                           #'(lambda ()
                               (when (or (not (outline-tree-exist-p))
                                         (let ((node (outline-tree-get-selected-node)))
                                           (or (outline-tree-buffer-node-p node)
                                               (not (outline-tree-latest-outline-p-by-node node)))))
                                 :disable)))
                          (:item 'outline-tree-output-range-html-frame-node-expand
                           "��������\���m�[�h�� FRAME HTML �o��(&D)"
                           #'(lambda () (interactive) (outline-tree-output-range-html-frame
                                                       (outline-tree-get-selected-node) :expand))
                           #'(lambda ()
                               (when (or (not (outline-tree-exist-p))
                                         (let ((node (outline-tree-get-selected-node)))
                                           (or (outline-tree-buffer-node-p node)
                                               (not (outline-tree-latest-outline-p-by-node node)))))
                                 :disable)))
                          )))
                      "�o��(&O)")
      (add-menu-separator menu)
      (add-popup-menu menu
                      (outline-tree-define-target-window-popup-menu)
                      "�A�E�g���C���ΏۃE�B���h�E(&U)")
      ;; �A�E�g���C���c���[�ȈՐݒ�
      (add-popup-menu menu
                      (define-popup-menu
                        (:item 'outline-tree-toggle-chase-cursor
                         "�J�[�\���Ǐ](&C)"
                         'outline-tree-toggle-chase-cursor
                         #'(lambda ()
                             (and (outline-tree-chase-cursor-p) :check)))
                        (:item 'outline-tree-toggle-chase-node
                         "�m�[�h�Ǐ](&N)"
                         'outline-tree-toggle-chase-node
                         #'(lambda ()
                             (and (outline-tree-chase-node-p) :check)))
                        (:item 'outline-tree-toggle-text-highlight
                         "�m�[�h�͈̓n�C���C�g(&H)"
                         'outline-tree-toggle-text-highlight
                         #'(lambda ()
                             (and (outline-tree-text-highlight-p) :check)))
                        (:item 'outline-tree-toggle-text-highlight-always
                         "�m�[�h�͈͂���Ƀn�C���C�g(&A)"
                         'outline-tree-toggle-text-highlight-always
                         #'(lambda ()
                             (and (outline-tree-text-highlight-always-p) :check)))
                        (:item 'outline-tree-toggle-available-swap-discontinuous-range-node
                         "�s�A���m�[�h���ւ���(&D)"
                         'outline-tree-toggle-available-swap-discontinuous-range-node
                         #'(lambda ()
                             (and (outline-tree-available-swap-discontinuous-range-node-p) :check))))
                      "�A�E�g���C���c���[�ȈՐݒ�(&Y)")
      (add-menu-item menu 'outline-tree-option-property-sheet
                     "�A�E�g���C���c���[�ݒ�(&Z)..."
                     #'(lambda () (interactive)
                         (save-window-excursion
                           (save-excursion
                             (if (outline-tree-exist-p)
                                 (set-buffer (outline-tree-get-buffer-by-node)))
                             (outline-tree-option-property-sheet)))))
      (add-menu-separator menu)
      (add-menu-item menu 'treeview::treeview-std-dialog
                     "TreeView �ݒ�(&D)..."
                     #'(lambda () (interactive)
                         (treeview::with-app (*outline-tree-app-id*)
                           (treeview::treeview-std-dialog)
                           (treeview::treeview-focus-treeview))))
      (treeview::with-app (*outline-tree-app-id*)
        (add-popup-menu menu
                        (treeview::treeview-popup-menu-position)
                        "�E�B���h�E�ʒu�ύX(&W)"))
      (add-popup-menu menu
                      (define-popup-menu
                        (:item 'treeview::treeview-describe-bindings
                         "�L�[���蓖�Ĉꗗ(&K)"
                         #'(lambda () (interactive)
                             (treeview::with-app (*outline-tree-app-id*)
                               (treeview::treeview-describe-bindings))))
                        (:item 'treeview::treeview-describe-key-briefly
                         "�L�[����(&B)"
                         #'(lambda () (interactive)
                             (treeview::with-app (*outline-tree-app-id*)
                               (call-interactively 'treeview::treeview-describe-key-briefly)))))
                      "�w���v(&?)")
      (add-menu-separator menu)
      (add-menu-item menu 'outline-tree-folder-close
                     "�t�H���_�����(&C)"
                     #'(lambda () (interactive)
                         (let ((folder (outline-tree-get-folder-by-node)))
                           (outline-tree-kill-folder-file-buffers folder)))
                     #'(lambda ()
                         (or (and (outline-tree-exist-p)
                                  (outline-tree-folder-node-p (outline-tree-get-selected-node)))
                             :disable)))
      (add-menu-item menu 'outline-tree-category-close
                     "�J�e�S�������(&C)"
                     #'(lambda () (interactive)
                         (outline-tree-delete-category-buffers (outline-tree-get-category-node-by-node)))
                     #'(lambda ()
                         (or (and (outline-tree-exist-p)
                                  (outline-tree-category-node-p (outline-tree-get-selected-node)))
                             :disable)))
      (add-menu-item menu 'kill-buffer
                     "�o�b�t�@�����(&C)"
                     #'(lambda () (interactive)
                         (treeview::with-app (*outline-tree-app-id*)
                           (let ((buffer (outline-tree-get-buffer-by-node)))
                             (kill-buffer buffer)
                             (winapi:InvalidateRect (get-window-handle) 0 1)
                             (winapi:UpdateWindow (get-window-handle))
                             (refresh-screen))))
                     #'(lambda ()
                         (or (and (outline-tree-exist-p)
                                  (outline-tree-get-buffer-by-node))
                             :disable)))
      (add-menu-separator menu)
      (add-popup-menu menu ed::*buffer-bar-context-menu*
                      "�o�b�t�@�o�[���j���[(&M)")
      (add-menu-separator menu)
      (add-menu-item menu 'outline-tree-open
                     "outline-tree ���J��(&T)"
                     'outline-tree2::outline-tree-open
                     #'(lambda () (or (and (outline-tree-exist-p)
                                           (outline-tree-close-p))
                                      :disable)))
      (add-menu-item menu 'outline-tree-close
                     "outline-tree �����(&T)"
                     'outline-tree2::outline-tree-close
                     #'(lambda () (or (and (outline-tree-exist-p)
                                           (outline-tree-open-p))
                                      :disable)))
      (add-menu-separator menu)
      (add-menu-item menu 'outline-tree-create
                     "outline-tree �̋N��(&X)"
                     'outline-tree2::outline-tree-create
                     #'(lambda () (and (outline-tree-exist-p) :disable)))
      (add-menu-item menu 'outline-tree-delete
                     "outline-tree �̏I��(&X)"
                     'outline-tree2::outline-tree-delete
                     #'(lambda ()
                         ;; �C���M�����[�����A�����ő��̃��j���[�̍X�V���s���B
                         (ignore-errors
                          (when (menup *outline-tree-app-menu*)
                            ;; �u�A�E�g���C���ΏۃE�B���h�E�v���j���[�̍X�V
                            (let ((pos (get-menu-position
                                        *outline-tree-app-menu*
                                        'outline-tree-define-target-window)))
                              (when pos
                                (delete-menu *outline-tree-app-menu* 'outline-tree-define-target-window)
                                (insert-popup-menu *outline-tree-app-menu* pos
                                                   (outline-tree-define-target-window-popup-menu)
                                                   "�A�E�g���C���ΏۃE�B���h�E(&U)")))
                            ;; ed::*buffer-bar-context-menu-buffer* �̍X�V
                            (setq ed::*buffer-bar-context-menu-buffer*
                                  (outline-tree-get-buffer-by-node))
                            ))
                         ;; INIT �{���̓���͂�������
                         (and (not (outline-tree-exist-p)) :disable)))
      (setq *outline-tree-app-menu* menu)))
  *outline-tree-app-menu*)

(defun outline-tree-delete-app-menu (&optional (menu (current-menu)))
  (when (menup menu)
    (while (delete-menu menu 'outline-tree))))

(defun outline-tree-insert-app-menu (&key (menu (current-menu))
                                          (position *outline-tree-app-menu-position*)
                                          (menu-name *outline-tree-app-menu-name*))
  (outline-tree-create-app-menu)
  (when (menup menu)
    (outline-tree-delete-app-menu menu)
    (cond
     ((and (numberp position) (integerp position))
      (insert-popup-menu menu position *outline-tree-app-menu* menu-name))
     ((and (symbolp position) (get-menu-position menu position))
      (insert-popup-menu menu (get-menu-position menu position)
                         *outline-tree-app-menu* menu-name))
     (t
      (add-popup-menu menu *outline-tree-app-menu* menu-name)))))

(defun outline-tree-startup-app-menu ()
  (when *outline-tree-set-app-menu*
    (if (menup ed::*app-menu*)
        (outline-tree-insert-app-menu)
      (add-hook 'ed::*init-app-menus-hook* 'outline-tree-insert-app-menu))))

(add-hook '*outline-tree-startup-hook* 'outline-tree-startup-app-menu)
(add-hook '*outline-tree-uninstall-hook* 'outline-tree-delete-app-menu)

;;; app-menu.l ends here