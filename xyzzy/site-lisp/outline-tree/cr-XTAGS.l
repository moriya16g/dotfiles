;;; -*- Mode: Lisp; Package: OUTLINE-TREE2 -*-
;;; cr-XTAGS.l --- outline-tree

;; Copyright (C) 2001-2005 OHKUBO Hiroshi <ohkubo@s53.xrea.com>

;; Author: OHKUBO Hiroshi <ohkubo@s53.xrea.com>
;; Time-stamp: <2005/11/12 14:10:07 +0900>

;;; Code:

(provide "outline-tree/cr-XTAGS")

(require "outline-tree/outline-tree")

(in-package "outline-tree2")

(defvar *outline-tree-create-outline-XTAGS-buffer* "*outline-tree: XTAGS*")

;; XTAGS 解析
(defun outline-tree-create-outline-XTAGS (root-node)
  (treeview::with-app (*outline-tree-app-id*)
    (flet ((outline-tree-create-outline-XTAGS-buffer ()
             (let (working-buffer)
               (save-excursion
                 (setq working-buffer (create-new-buffer *outline-tree-create-outline-XTAGS-buffer*))
                 (set-buffer working-buffer)
                 (make-local-variable 'need-not-save)
                 (setq need-not-save t)
                 (make-local-variable 'kept-undo-information)
                 (setq kept-undo-information nil))
               working-buffer)))
      (let* ((src-buffer (outline-tree-get-buffer-by-node root-node))
             src-buffer-mode working-buffer XTAGS-dir
             relative-path point-node
             S-section-node F-section-node V-section-node
             whole-range)
        (save-excursion
          (set-buffer src-buffer)
          (setq src-buffer-mode buffer-mode)
          (unless (get-buffer-file-name)
            (treeview::treeview-message "ファイル名がありません。")
            (return-from outline-tree-create-outline-XTAGS))
          (setq relative-path (get-buffer-file-name))
          (setq XTAGS-dir (directory-namestring (get-buffer-file-name)))
          (setq working-buffer (outline-tree-create-outline-XTAGS-buffer))
          (set-buffer working-buffer)
          (loop
            (unless (file-exist-p (merge-pathnames "XTAGS" XTAGS-dir))
              (delete-buffer working-buffer)
              (treeview::treeview-message "適切な XTAGS ファイルが存在しません。")
              (return-from outline-tree-create-outline-XTAGS))
            (insert-file (merge-pathnames "XTAGS" XTAGS-dir))
            (if (looking-at "^#USE \\(.+\\)$")
                (progn
                  (setq XTAGS-dir (merge-pathnames (match-string 1) XTAGS-dir))
                  (delete-region (point-min) (point-max)))
              (return)))
          ;; 相対パスを単純に長さのみで生成している。危険か？
          (setq relative-path
                (concat "" (substring relative-path (length (append-trail-slash XTAGS-dir))) ""))
          (setq S-section-node (outline-tree-insert-section-node "[S]" root-node))
          (setq F-section-node (outline-tree-insert-section-node "[F]" root-node))
          (setq V-section-node (outline-tree-insert-section-node "[V]" root-node))
          (let (class sep name args file type point node-name)
            (while (scan-buffer relative-path :case-fold t)
              (goto-bol)
              (setq class "" sep "")
              (unless (looking-at "[]")
                (setq class (buffer-substring
                             (point) (progn (skip-chars-forward "^") (point)))
                      sep ed::tags-class-method-separator))
              (setq type (ed::tags-looking-entry-type))
              (setq name (buffer-substring
                          (1+ (point)) (progn (skip-chars-forward "^") (point)))
                    file (progn
                           (forward-char 1)
                           (buffer-substring
                            (point) (progn (skip-chars-forward "^") (point))))
                    point (parse-integer
                           (buffer-substring
                            (1+ (point)) (progn (skip-chars-forward "^\n") (point))))
                    args (progn
                           (skip-chars-forward "^\n")
                           (if (looking-for "")
                               (buffer-substring (1+ (point)) (progn (goto-eol) (point)))
                             "")))
              (setq whole-range nil)
              (cond
               ((member src-buffer-mode '(ed::lisp-mode ed::lisp-interaction-mode))
                (save-excursion
                  (set-buffer src-buffer)
                  (goto-char (1- point))
                  (if (goto-matched-parenthesis)
                      (setq whole-range (cons (point) point))))))
              (setq node-name (concat class sep name " " args))
              (case type
                ('ed::structure
                 (if whole-range
                     (outline-tree-insert-range-node node-name S-section-node :whole-range whole-range)
                   (outline-tree-insert-point-node node-name S-section-node :point point)))
                ('ed::function
                 (if whole-range
                     (outline-tree-insert-range-node node-name F-section-node :whole-range whole-range)
                   (outline-tree-insert-point-node node-name F-section-node :point point)))
                (t
                 (if whole-range
                     (outline-tree-insert-range-node node-name V-section-node :whole-range whole-range)
                   (outline-tree-insert-point-node node-name V-section-node :point point)))))))
        (delete-buffer working-buffer)
        (unless (outline-tree-node-has-children-p S-section-node)
          (outline-tree-remove-section-node S-section-node))
        (unless (outline-tree-node-has-children-p F-section-node)
          (outline-tree-remove-section-node F-section-node))
        (unless (outline-tree-node-has-children-p V-section-node)
          (outline-tree-remove-section-node V-section-node))))))
(outline-tree-add-create-outline-function
 'outline-tree-create-outline-XTAGS "XTAGS" '()
 "バッファに対応する XTAGS ファイルを元に、S,F,V 情報を表示します。
XTAGS ファイルとは、[メニュー]-[ツール]-[TAGSファイルの作成] により
生成されるファイルです。")

;;; cr-XTAGS.l ends here
