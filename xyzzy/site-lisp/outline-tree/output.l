;;; -*- Mode: Lisp; Package: OUTLINE-TREE2 -*-
;;; output.l --- outline-tree

;; Copyright (C) 2001-2005 OHKUBO Hiroshi <ohkubo@s53.xrea.com>

;; Author: OHKUBO Hiroshi <ohkubo@s53.xrea.com>
;; Time-stamp: <2005/11/12 14:04:39 +0900>

;;; Code:

(provide "outline-tree/output")

(require "buf2html")
(require "outline-tree/outline-tree")

(in-package "outline-tree2")

(defvar *outline-tree-output-directory* nil)
(defvar *outline-tree-output-buffer* "*OutlineTree OUTPUT*")

;; ここらへんの記述は、名称を変更した上で、utils.l に移動予定
(defvar *outline-tree-output-string-encode-alist*
  '(("&" . "&amp;")
    ("<" . "&lt;")
    (">" . "&gt;")
    ( "\"" . "&quot;")
    (" " . "&nbsp;"))
  "変換する文字参照リスト")

(defvar *outline-tree-output-css-string*
"        body {
          color: black;
          background-color: white;
        }
        a:link {
          color: #0033cc;
        }
        a:visited {
          color: navy;
        }
        a:hover {
          color: #ff6633;
        }
        h1 {
          font-size: 1.5em;
          line-height: 1.7em;
          background-color: #ffcc66;
          margin: 0.2em 0em 0em 0em;
          padding: 4px 4px 2px;
          border-width: 1px 1px 1px 3px;
          border-color: #6666ff;
          border-style: solid;
        }
        h2 {
          font-weight: bold;
          font-size: 1.3em;
          line-height: 1.4em;
          background-color: #ccccff;
          margin: 0.2em 0em 0em 0.5em;
          padding: 5px 8px 5px 1ex;
          border-width: 1px 1px 1px 3px;
          border-color: #8888ff;
          border-style: solid;
        }
        h3 {
          font-size: 1.1em;
          line-height: 1.1em;
          background-color: #FFFFCC;
          margin: 0.2em 0em 0em 1em;
          padding: 5px 8px 5px 2ex;
          border-width: 1px 1px 1px 3px;
          border-color: #ffccff;
          border-style: solid;
        }
        h4, h5, h6 {
          line-height: 1.2em;
          font-size: 1.5em;
          margin: 0.2em 0em 0em 1.5em;
          padding: 5px 8px 5px 2ex;
        }
        pre {
          margin: 0.3em 0em 0.6em 2em;
          border-width: 2px;
          border-color: #000000;
          border-style: solid;
          padding: 3px 3px 3px 3px;
        }
        p {
          margin-top: 0.3em;
          margin-right: 1em;
          margin-bottom: 1em;
          margin-left: 2em;
        }
        ul {
          list-style: circle;
          margin-left: 1em;
        }
        ul ul {
          list-style: disc;
        }
        ul ul ul {
          list-style: square;
        }
        ul ul ul ul {
          list-style: none;
        }
        ol {
          margin-left: 1em;
        }
        #toc {
          margin: 1em 1em 1em 1em;
          padding: 0px 1em 0px 1em;
          border: 1px solid #339966;
          border-width: 1px 1px 1px 5px;
          background-color: #eeeeee;
          color: #993366;
        }
")

(defun outline-tree-set-output-buffer ()
  (save-excursion
    (let (output-buffer)
      (setq output-buffer (get-buffer-create *outline-tree-output-buffer*))
      (set-buffer output-buffer)
      (erase-buffer (selected-buffer))
      (make-local-variable 'ed::need-not-save)
      (setq ed::need-not-save t)
      output-buffer)))

(defun outline-tree-output-get-output-dir ()
  (or *outline-tree-output-directory*
      (and (get-buffer-file-name)
           (directory-namestring (get-buffer-file-name)))
      (default-directory)))

(defun outline-tree-output-confirm-output-files-p (files &optional directory)
  "ファイルを出力してよければ non-nil、そうでなければ nil を返す"
  (let (exist-output-files)
    (dolist (file files)
      (if (file-exist-p (merge-pathnames file directory))
          (push file exist-output-files)))
    (not (and exist-output-files
              (not (no-or-yes-p "~A~{        ~A~%~}ファイルが存在しています。~%上書きしてもよろしいですか？"
                                (if directory (format nil "~A フォルダに~%" directory) "")
                                (nreverse exist-output-files)))))))

;;; output.l ends here
