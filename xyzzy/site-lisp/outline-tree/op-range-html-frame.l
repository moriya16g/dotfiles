;;; -*- Mode: Lisp; Package: OUTLINE-TREE2 -*-
;;; op-range-html-frame.l --- outline-tree

;; Copyright (C) 2001-2005 OHKUBO Hiroshi <ohkubo@s53.xrea.com>

;; Author: OHKUBO Hiroshi <ohkubo@s53.xrea.com>
;; Time-stamp: <2005/11/12 14:05:32 +0900>

;;; Code:

(provide "outline-tree/op-range-html-frame")

(require "outline-tree/outline-tree")
(require "outline-tree/output")

(in-package "outline-tree2")

;; パス
(defvar *outline-tree-output-range-html-frame-frame-file* "index.html"
  "範囲ノードHTML出力: トップHTMLファイル名")
(defvar *outline-tree-output-range-html-frame-toc-file* "toc.html"
  "範囲ノードHTML出力: メニュー部HTMLファイル名")
(defvar *outline-tree-output-range-html-frame-main-file* "main.html"
  "範囲ノードHTML出力: メイン部HTMLファイル名")

;; HTML 見出し 出力
(defvar *outline-tree-output-range-html-frame-header* 'outline-tree-output-range-html-frame-header
  "範囲ノードHTML出力: 先頭から <body> までの文字列。メニュー部、メイン部共用。
文字列を返す関数、もしくは文字列を指定する。")
(defvar *outline-tree-output-range-html-frame-footer* 'outline-tree-output-range-html-frame-footer
  "範囲ノードHTML出力: </body> から最後までの文字列。メニュー部、メイン部共用。
文字列を返す関数、もしくは文字列を指定する。")

(defun outline-tree-output-range-html-frame-frame ()
  "範囲ノードHTML出力: トップHTMLファイル文字列を返す"
  (concat
"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Frameset//EN\">
<html lang=\"ja\">
  <head>
    <meta http-equiv=\"Content-Type\" content=\"text/html; charset=Shift_JIS\">
    <meta name=\"GENERATOR\" content=\"outline-tree\">
    <title>%nodename%</title>
  </head>
  <frameset cols=\"300,500\" title=\"index\">
    <frame src=\"" *outline-tree-output-range-html-frame-toc-file* "\" name=\"toc\" title=\"toc\">
    <frame src=\"" *outline-tree-output-range-html-frame-main-file* "\" name=\"main\" title=\"main\">
    <noframes>
      <body>
        <a href=\"" *outline-tree-output-range-html-frame-toc-file* "\">"
   *outline-tree-output-range-html-frame-toc-file*
   "</a>
        <a href=\"" *outline-tree-output-range-html-frame-main-file* "\">"
   *outline-tree-output-range-html-frame-main-file*
   "</a>
      </body>
    </noframes>
  </frameset>
</html>
"))

(defun outline-tree-output-range-html-frame-header ()
  "範囲ノードHTML出力: メニュー部、メイン部ファイルの先頭から<body>までの文字列を返す"
  (let ((xyzzy-css-string (buf2html-get-ini2css-string 8)))
    (concat
"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">
<html lang=\"ja\">
  <head>
    <meta http-equiv=\"Content-Type\" content=\"text/html; charset=Shift_JIS\">
    <meta http-equiv=\"Content-Style-Type\" content=\"text/css\">
    <style type=\"text/css\">
      <!--
"
     xyzzy-css-string
     (if (string/= xyzzy-css-string "") "\n" "")
     *outline-tree-output-css-string*
"      //-->
    </style>
    <meta name=\"GENERATOR\" content=\"outline-tree\">
    <title>%nodename%</title>
  </head>
  <body>
")))

(defun outline-tree-output-range-html-frame-footer ()
  "範囲ノードHTML出力: メニュー部、メイン部ファイルの</body>から最後までの文字列を返す"
  "</body>
</html>
")

;; output-depth は現在は :expand のみ
(defun outline-tree-output-range-html-frame (&optional root-node output-depth)
  "範囲ノードHTML出力: トップ、メニュー、メイン部のHTMLファイルを生成する"
  (interactive)
  (treeview::with-app (*outline-tree-app-id*)
    (unless (outline-tree-open-p)
      (return-from outline-tree-output-range-html-frame))
    (unless root-node
      (setq root-node (outline-tree-get-buffer-node-by-window)))
    ;; outline が最新かどうかの判定
    (unless (outline-tree-latest-outline-p-by-node root-node)
      (return-from outline-tree-output-range-html-frame))
    (let ((output-buffer (outline-tree-set-output-buffer))
          header footer frame
          (output-dir (outline-tree-output-get-output-dir))
          (filename (get-buffer-file-name (outline-tree-get-buffer-by-node root-node)))
          replace-string-alist target-node-count)
      ;; 出力ファイルの上書き確認
      (unless (outline-tree-output-confirm-output-files-p
               (list *outline-tree-output-range-html-frame-frame-file*
                     *outline-tree-output-range-html-frame-toc-file*
                     *outline-tree-output-range-html-frame-main-file*)
               output-dir)
        (return-from outline-tree-output-range-html-frame))
      ;; ハイライト削除
      (outline-tree-delete-text-highlight)
      ;; 置換文字列作成
      (unless (stringp filename)
        (setq filename ""))
      (if (string-match "^.+[/\\]\\(.+\\)$" filename)
          (setq filename (match-string 1)))
      (if (string-match "^\\(.+\\)\\(\\.[^\\.]+\\)$" filename)
          (setq filename (match-string 1)))
      (push (cons "%filename%" filename) replace-string-alist)
      (push (cons "%nodename%" (outline-tree-data-get-node-name root-node))
            replace-string-alist)

      ;; 処理対象ノードのカウント
      (setq target-node-count
            (outline-tree-output-range-html-frame-target-node-count root-node output-depth))

      (setq frame (outline-tree-output-range-html-frame-frame))
      (setq header
            (cond
             ((or (fboundp *outline-tree-output-range-html-frame-header*)
                  (functionp *outline-tree-output-range-html-frame-header*))
              (funcall *outline-tree-output-range-html-frame-header*))
             ((stringp *outline-tree-output-range-html-frame-header*)
              *outline-tree-output-range-html-frame-header*)
             (t "")))
      (setq footer
            (cond
             ((or (fboundp *outline-tree-output-range-html-frame-footer*)
                  (functionp *outline-tree-output-range-html-frame-footer*))
              (funcall *outline-tree-output-range-html-frame-footer*))
             ((stringp *outline-tree-output-range-html-frame-footer*)
              *outline-tree-output-range-html-frame-footer*)
             (t "")))
      (dolist (x replace-string-alist)
        (setq frame (substitute-string frame (car x) (cdr x)))
        (setq header (substitute-string header (car x) (cdr x)))
        (setq footer (substitute-string footer (car x) (cdr x))))
      ;; frame file
      (with-output-to-buffer (output-buffer)
        (format t "~A" frame))
      (save-excursion
        (set-buffer output-buffer)
        (write-file (namestring
                     (merge-pathnames *outline-tree-output-range-html-frame-frame-file*
                                      output-dir)))
        (delete-region (point-min) (point-max)))
      ;; toc file
      (with-output-to-buffer (output-buffer)
        (format t "~A" header)
        (outline-tree-output-range-html-frame-toc root-node target-node-count output-depth)
        (format t "~A" footer))
      (save-excursion
        (set-buffer output-buffer)
        (write-file (namestring
                     (merge-pathnames *outline-tree-output-range-html-frame-toc-file*
                                      output-dir)))
        (delete-region (point-min) (point-max)))
      ;; main file
      (with-output-to-buffer (output-buffer)
        (format t "~A" header)
        (outline-tree-output-range-html-frame-main root-node target-node-count output-depth)
        (format t "~A" footer))
      (save-excursion
        (set-buffer output-buffer)
        (write-file (namestring
                     (merge-pathnames *outline-tree-output-range-html-frame-main-file*
                                      output-dir)))
        (delete-region (point-min) (point-max)))

      (delete-buffer output-buffer)
      (find-file (namestring
                  (merge-pathnames *outline-tree-output-range-html-frame-frame-file*
                                   output-dir)))))
  (refresh-screen))

(defun outline-tree-output-range-html-frame-target-node-count (root-node output-depth)
  "範囲ノードHTML出力: 処理対象のノードの数を返す"
  (let ((count 0) node)
    (labels ((outline-tree-output-range-html-frame-target-node-count-1 (node level)
               (when (outline-tree-range-node-p node)
                 (incf count))
               (when (and (outline-tree-node-has-children-p node)
                          (or (not (eq output-depth :expand)) (treeview::treeview-expand-p node)))
                 (setq node (treeview::treeview-get-child-item node))
                 (while (outline-tree-node-valid-p node)
                   (outline-tree-output-range-html-frame-target-node-count-1 node (1+ level))
                   (setq node (treeview::treeview-get-next-sibling-item node))))))
      (when (and (outline-tree-node-has-children-p root-node)
                 (or (not (eq output-depth :expand)) (treeview::treeview-expand-p root-node)))
        (setq node (treeview::treeview-get-child-item root-node))
        (while (outline-tree-node-valid-p node)
          (outline-tree-output-range-html-frame-target-node-count-1 node 1)
          (setq node (treeview::treeview-get-next-sibling-item node))))
      count)))

(defun outline-tree-output-range-html-frame-toc (root-node target-node-count output-depth)
  "範囲ノードHTML出力: メニュー部HTMLの <body></body> 内文字列を返す"
  (let ((sec-num 0) node (node-count 0))
    (labels ((outline-tree-output-range-html-frame-toc-1 (node level)
               (let (str)
                 (format t "~V@{~A~:*~}" (1+ (* 2 (1- level))) "  ")
                 (setq str (outline-tree-data-get-node-name node))
                 (dolist (x *outline-tree-output-string-encode-alist*)
                   (setq str (substitute-string str (car x) (cdr x))))
                 (format t "<li class=\"lv~D\">" level)
                 (cond
                  ((outline-tree-range-node-p node)
                   (incf node-count)
                   (message "toc processing: ~D/~D" node-count target-node-count)
                   (incf sec-num)
                   (format t "<a href=\"~A#SEC~D\" name=\"TOC~D\" target=\"main\">~A</a>"
                           *outline-tree-output-range-html-frame-main-file*
                           sec-num sec-num str))
                  (t
                   (format t "~A" str)))
                 (when (and (outline-tree-node-has-children-p node)
                            (or (not (eq output-depth :expand)) (treeview::treeview-expand-p node)))
                   (format t "~%")
                   (incf level)
                   (format t "~V@{~A~:*~}" (* 2 (1- level)) "  ")
                   (format t "<ul class=\"lv~D\">~%" level)
                   (setq node (treeview::treeview-get-child-item node))
                   (while (outline-tree-node-valid-p node)
                     (outline-tree-output-range-html-frame-toc-1 node level)
                     (setq node (treeview::treeview-get-next-sibling-item node)))
                   (format t "~V@{~A~:*~}" (* 2 (1- level)) "  ")
                   (format t "</ul>~%")
                   (decf level)
                   (format t "~V@{~A~:*~}" (1+ (* 2 (1- level))) "  "))
                 (format t "</li>~%"))))
      (format t "~A~%" "<div id=\"toc\">")
      (when (and (outline-tree-node-has-children-p root-node)
                 (or (not (eq output-depth :expand)) (treeview::treeview-expand-p root-node)))
        (format t "~A~%" "<ul class=\"lv1\">")
        (setq node (treeview::treeview-get-child-item root-node))
        (while (outline-tree-node-valid-p node)
          (outline-tree-output-range-html-frame-toc-1 node 1)
          (setq node (treeview::treeview-get-next-sibling-item node)))
        (format t "~A~%" "</ul>"))
      (format t "~A~%" "</div>"))))

(defun outline-tree-output-range-html-frame-main (root-node target-node-count output-depth)
  "範囲ノードHTML出力: メイン部HTMLの <body></body> 内文字列を返す"
  (let ((sec-num 0) node (node-count 0))
    (labels ((outline-tree-output-range-html-frame-main-1 (node level)
               (let (str range from to)
                 (cond
                  ((outline-tree-range-node-p node)
                   (incf node-count)
                   (message "main processing: ~D/~D" node-count target-node-count)
                   (setq str (outline-tree-data-get-node-name node))
                   (dolist (x *outline-tree-output-string-encode-alist*)
                     (setq str (substitute-string str (car x) (cdr x))))
                   (incf sec-num)
                   (format t "<h~D class=\"lv~D\">" (if (<= level 6) level 6) level)
                   (format t "<a href=\"~A#TOC~D\" name=\"SEC~D\" target=\"toc\">~A</a>"
                           *outline-tree-output-range-html-frame-toc-file*
                           sec-num sec-num str)
                   (format t "</h~D>~%" (if (<= level 6) level 6))
                   (format t "<div class=\"lv~D\">" level)
                   (setq range (outline-tree-data-get-whole-range node))
                   (setq from (outline-tree-get-range-from range)
                         to (outline-tree-get-range-to range))
                   (if (< from to)
                       (setq str (buf2html-get-region-string from to nil t))
                     (setq str ""))
                   (format t "~A" str)
                   (format t "</div>~%")))
                 (when (and (outline-tree-node-has-children-p node)
                            (or (not (eq output-depth :expand)) (treeview::treeview-expand-p node)))
                   (setq node (treeview::treeview-get-child-item node))
                   (while (outline-tree-node-valid-p node)
                     (outline-tree-output-range-html-frame-main-1 node (1+ level))
                     (setq node (treeview::treeview-get-next-sibling-item node)))))))
      (save-excursion
        (save-restriction
          (widen)
          (set-buffer (outline-tree-get-buffer-by-node root-node))
          (format t "~A~%" "<div id=\"main\">")
          (when (and (outline-tree-node-has-children-p root-node)
                     (or (not (eq output-depth :expand)) (treeview::treeview-expand-p root-node)))
            (setq node (treeview::treeview-get-child-item root-node))
            (while (outline-tree-node-valid-p node)
              (outline-tree-output-range-html-frame-main-1 node 1)
              (setq node (treeview::treeview-get-next-sibling-item node))))
          (format t "~A~%" "</div>"))))))

;;; op-range-html-frame.l ends here
