;;; -*- Mode: Lisp; Package: OUTLINE-TREE2 -*-
;;; public-utils.l

;; Copyright (C) 2001-2005 OHKUBO Hiroshi <ohkubo@s53.xrea.com>

;; Author: OHKUBO Hiroshi <ohkubo@s53.xrea.com>
;; Time-stamp: <2005/11/18 16:14:09 +0900>

;;; Code:

(provide "outline-tree/public-utils")

(require "outline-tree/defs")

(in-package "outline-tree2")

;; buffer
(defun outline-tree-buffer-read-only-p (&optional buffer)
  (if buffer
      (save-excursion
        (set-buffer buffer)
        (symbol-value 'buffer-read-only))
    (symbol-value 'buffer-read-only)))

;; filer
(defun outline-tree-filer-open-p ()
  (handler-case
      (progn
        (filer-reload)
        t)
    (error (c)
      nil)))

;; tag
(defun outline-tree-goto-next-tag ()
  (interactive)
  (unless (and (syntax-open-tag-p #\<) (syntax-close-tag-p #\>))
    (return-from outline-tree-goto-next-tag nil))
  (let (point)
    (save-excursion
      (while (scan-buffer "<" :no-dup t)
        (when (eq (parse-point-syntax) nil)
          (setq point (point))
          (return))))
    (when point
      (goto-char point))))

(defun outline-tree-goto-matched-tag (&optional point)
  (interactive)
  (let ((matched-tag-range (outline-tree-get-matched-tag)))
    (when matched-tag-range
      (goto-char (car matched-tag-range)))))

(defun outline-tree-get-current-tag (&optional point)
  (unless (and (syntax-open-tag-p #\<) (syntax-close-tag-p #\>))
    (return-from outline-tree-get-current-tag nil))
  (let (from to tag-range tag-type tagname)
    (save-excursion
      (when point
        (goto-char point))
      (cond
       ((eq (parse-point-syntax) :tag)
        (skip-syntax-spec-backward "^{")
        (backward-char))
       ((and (eq (parse-point-syntax) nil)
             (eq (parse-point-syntax (1+ (point))) :tag)))
       (t
        (return-from outline-tree-get-current-tag nil)))
      (setq from (point))
      (if (char/= #\/ (char-after (1+ from)))
          (setq tag-type :open)
        (setq tag-type :close))
      (skip-syntax-spec-forward "^}")
      (unless (char= (char-after (point)) #\>)
        (return-from outline-tree-get-current-tag nil))
      (setq to (1+ (point)))
      (setq tag-range (cons from to))
      (goto-char from)
      (if (eq tag-type :open)
          (looking-at "<[ \t\n]*\\([^ \t\n>]+\\)")
        (looking-at "</[ \t\n]*\\([^ \t\n>]+\\)"))
      (setq tagname (match-string 1))
      (values tag-range tag-type tagname))))

(defun outline-tree-get-matched-tag (&optional point)
  (unless (and (syntax-open-tag-p #\<) (syntax-close-tag-p #\>))
    (return-from outline-tree-get-matched-tag nil))
  (let (from to open-tag-range close-tag-range current-tag-type
        tagname nest regexp)
    (save-excursion
      (when point
        (goto-char point))
      (cond
       ((eq (parse-point-syntax) :tag)
        (skip-syntax-spec-backward "^{")
        (backward-char))
       ((and (eq (parse-point-syntax) nil)
             (eq (parse-point-syntax (1+ (point))) :tag)))
       (t
        (return-from outline-tree-get-matched-tag nil)))
      (setq from (point))
      (if (char/= #\/ (char-after (1+ from)))
          (setq current-tag-type :open)
        (setq current-tag-type :close))
      (skip-syntax-spec-forward "^}")
      (unless (char= (char-after (point)) #\>)
        (return-from outline-tree-get-matched-tag nil))
      (setq to (1+ (point)))
      (if (eq current-tag-type :open)
          (setq open-tag-range (cons from to))
        (setq close-tag-range (cons from to)))
      (goto-char from)
      (if (eq current-tag-type :open)
          (looking-at "<[ \t\n]*\\([^ \t\n>]+\\)")
        (looking-at "</[ \t\n]*\\([^ \t\n>]+\\)"))
      (setq tagname (match-string 1))
      (setq nest 1)
      (if (eq current-tag-type :open)
          (progn
            (goto-char to)
            (setq regexp (compile-regexp (concat "<\\(/\\)?" (regexp-quote tagname) "[ \t\n>]") t))
            (while (scan-buffer regexp :tail t)
              (when (eq (parse-point-syntax (match-beginning 0)) nil)
                (if (match-string 1)
                    (decf nest)
                  (incf nest))
                (when (= nest 0)
                  (setq close-tag-range (cons (match-beginning 0) (match-end 0)))
                  (return)))))
        (progn
          (goto-char from)
          (setq regexp (compile-regexp (concat "<\\(/\\)?" (regexp-quote tagname) "[ \t\n>]") t))
          (while (scan-buffer regexp :reverse t :no-dup t)
            (when (eq (parse-point-syntax (match-beginning 0)) nil)
              (if (match-string 1)
                  (incf nest)
                (decf nest))
              (when (= nest 0)
                (setq open-tag-range (cons (match-beginning 0) (match-end 0)))
                (return))))))
      (when (and open-tag-range close-tag-range)
        (if (eq current-tag-type :open)
            (values close-tag-range open-tag-range current-tag-type tagname)
          (values open-tag-range close-tag-range current-tag-type tagname))))))

;; public-utils.l ends here
