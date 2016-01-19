;;; -*- Mode: Lisp; Package: OUTLINE-TREE2 -*-
;;; cr-lisp.l --- outline-tree

;; Copyright (C) 2001-2006 OHKUBO Hiroshi <ohkubo@s53.xrea.com>

;; Author: OHKUBO Hiroshi <ohkubo@s53.xrea.com>
;; Time-stamp: <2006/10/21 17:16:42 +0900>

;;; Code:

(provide "outline-tree/cr-lisp")

(require "outline-tree/outline-tree")

(in-package "outline-tree2")

;; lisp ���
(defun outline-tree-create-outline-lisp (root-node)
  (let (package)
    (unwind-protect
        (progn
          (do ((i 0 (+ i 1)))
              ((let ((name (format nil "OUTLINE-TREE2-CR-LISP-~D" i)))
                 (unless (find-package name)
                   (setq package (make-package name :external-size 0))))))
          (labels ((trim-text (str)
                     (substitute-string str "^OUTLINE-TREE2-CR-LISP-[0-9]+::" ""))
                   (outline-tree-create-outline-lisp-defvar-type (root-node section-name regexp)
                     (let (section-node range-node from to lst name val doc pos)
                       (goto-char (point-min))
                       (setq section-node (outline-tree-insert-section-node section-name root-node))
                       (while (scan-buffer regexp :regexp t)
                         (setq pos (match-end 0))
                         (setq from (point))
                         (skip-chars-forward " \t")
                         (when (and (eq (parse-point-syntax) nil)
                                    (not (find (char-before (point)) '(#\' #\`)))
                                    (goto-matched-parenthesis))
                           (setq to (1+ (point)))
                           (with-input-from-buffer ((selected-buffer) from)
                             (let ((*package* package))
                               (handler-case
                                   (setq lst (read *standard-input* nil))
                                 (error (c)
                                   (setq lst nil)))))
                           (when lst
                             (when (<= 2 (length lst))
                               (setq name (nth 1 lst)))
                             (setq range-node (outline-tree-insert-range-node
                                               (trim-text (format nil "~S" name)) section-node :whole-range (cons from to)))
                             (when (setq doc (and (stringp (cadddr lst)) (cadddr lst)))
                               (outline-tree-insert-info-node (concat "�y" doc "�z") range-node))
                             (when (<= 3 (length lst))
                               (setq val (nth 2 lst))
                               (outline-tree-insert-info-node (trim-text (format nil "~S" val)) range-node))))
                         (goto-char pos))
                       (unless range-node
                         (outline-tree-remove-section-node section-node))))
                   (outline-tree-create-outline-lisp-defun-type (root-node section-name regexp commandp)
                     (let (section-node range-node from to lst name doc args pos)
                       (goto-char (point-min))
                       (setq section-node (outline-tree-insert-section-node section-name root-node))
                       (while (scan-buffer regexp :regexp t)
                         (setq pos (match-end 0))
                         (setq from (point))
                         (skip-chars-forward " \t")
                         (when (and (eq (parse-point-syntax) nil)
                                    (not (find (char-before (point)) '(#\' #\`)))
                                    (goto-matched-parenthesis))
                           (setq to (1+ (point)))
                           (with-input-from-buffer ((selected-buffer) from)
                             (let ((*package* package))
                               (handler-case
                                   (setq lst (read *standard-input* nil))
                                 (error (c)
                                   (setq lst nil)))))
                           (when lst
                             (when (<= 2 (length lst))
                               (setq name (nth 1 lst)))
                             (when (if commandp
                                       (lisp::find-interactive (cdddr lst))
                                     (not (lisp::find-interactive (cdddr lst))))
                               (setq range-node (outline-tree-insert-range-node
                                                 (trim-text (format nil "~S" name)) section-node :whole-range (cons from to)))
                               (when (setq doc (lisp::find-documentation (cdddr lst)))
                                 (outline-tree-insert-info-node (concat "�y" doc "�z") range-node))
                               (when (<= 3 (length lst))
                                 (setq args (nth 2 lst))
                                 (dolist (arg args)
                                   (outline-tree-insert-info-node (trim-text (format nil "~S" arg)) range-node))))))
                         (goto-char pos))
                       (unless range-node
                         (outline-tree-remove-section-node section-node)))))
            (outline-tree-create-outline-lisp-defvar-type
             root-node "[defconstant]" (compile-regexp "[ \t]*(defconstant\\_S"))
            (outline-tree-create-outline-lisp-defvar-type
             root-node "[defvar-local]" (compile-regexp "[ \t]*(defvar-local\\_S"))
            (outline-tree-create-outline-lisp-defvar-type
             root-node "[defvar]" (compile-regexp "[ \t]*(defvar\\_S"))
            (outline-tree-create-outline-lisp-defvar-type
             root-node "[defparameter]" (compile-regexp "[ \t]*(defparameter\\_S"))
            (outline-tree-create-outline-lisp-defvar-type
             root-node "[define-history-variable]"
             (compile-regexp "[ \t]*(define-history-variable\\_S"))
            (outline-tree-create-outline-lisp-defun-type
             root-node "[defun (not command)]" (compile-regexp "[ \t]*(defun\\_S") nil)
            (outline-tree-create-outline-lisp-defun-type
             root-node "[defun (command)]" (compile-regexp "[ \t]*(defun\\_S") t)
            (outline-tree-create-outline-lisp-defun-type
             root-node "[defmacro (not command)]" (compile-regexp "[ \t]*(defmacro\\_S") nil)
            (outline-tree-create-outline-lisp-defun-type
             root-node "[defmacro (command)]" (compile-regexp "[ \t]*(defmacro\\_S") t)))
      (when package
        (delete-package package)))))
(outline-tree-add-create-outline-function
 'outline-tree-create-outline-lisp "LISP" '(:language)
 "LISP �t�@�C���̊֐��E�ϐ���`��񋓂��܂��B")

;;; cr-lisp.l ends here