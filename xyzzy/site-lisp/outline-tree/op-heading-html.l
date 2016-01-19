;;; -*- Mode: Lisp; Package: OUTLINE-TREE2 -*-
;;; op-heading-html.l --- outline-tree

;; Copyright (C) 2001-2005 OHKUBO Hiroshi <ohkubo@s53.xrea.com>

;; Author: OHKUBO Hiroshi <ohkubo@s53.xrea.com>
;; Time-stamp: <2005/11/12 14:05:37 +0900>

;;; Code:

(provide "outline-tree/op-heading-html")

(require "outline-tree/outline-tree")
(require "outline-tree/output")

(in-package "outline-tree2")

;; HTML 見出し 出力
(defvar *outline-tree-output-heading-html-header* 'outline-tree-output-heading-html-header
  "見出しノードHTML出力: 先頭から <body> までの文字列を返す関数、もしくは文字列を指定する")
(defvar *outline-tree-output-heading-html-footer* 'outline-tree-output-heading-html-footer
  "見出しノードHTML出力: </body> から最後までの文字列を返す関数、もしくは文字列を指定する")

(defun outline-tree-output-heading-html-header ()
  "見出しノードHTML出力: 先頭から<body>までの文字列を返す"
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

(defun outline-tree-output-heading-html-footer ()
  "見出しノードHTML出力: </body>から最後までの文字列を返す"
  "</body>
</html>
")

;; output-depth は現在は :expand のみ
(defun outline-tree-output-heading-html (&optional root-node output-depth)
  "見出しノードHTML出力: HTMLをバッファに出力する"
  (interactive)
  (treeview::with-app (*outline-tree-app-id*)
    (unless (outline-tree-open-p)
      (return-from outline-tree-output-heading-html))
    (unless root-node
      (setq root-node (outline-tree-get-buffer-node-by-window)))
    ;; outline が最新かどうかの判定
    (unless (outline-tree-latest-outline-p-by-node root-node)
      (return-from outline-tree-output-heading-html))
    (let ((output-buffer (outline-tree-set-output-buffer))
          header footer
          (filename (get-buffer-file-name (outline-tree-get-buffer-by-node root-node)))
          replace-string-alist target-node-count)
      ;; 出力 range の設定
      (cond
       ((eq output-depth :expand)
        (outline-tree-set-data-output-range-tree-by-node root-node))
       (t
        (outline-tree-set-data-contents-range-tree-by-node root-node)))
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
            (outline-tree-output-heading-html-target-node-count root-node output-depth))

      ;;
      (setq header
            (cond
             ((or (fboundp *outline-tree-output-heading-html-header*)
                  (functionp *outline-tree-output-heading-html-header*))
              (funcall *outline-tree-output-heading-html-header*))
             ((stringp *outline-tree-output-heading-html-header*)
              *outline-tree-output-heading-html-header*)
             (t "")))
      (setq footer
            (cond
             ((or (fboundp *outline-tree-output-heading-html-footer*)
                  (functionp *outline-tree-output-heading-html-footer*))
              (funcall *outline-tree-output-heading-html-footer*))
             ((stringp *outline-tree-output-heading-html-footer*)
              *outline-tree-output-heading-html-footer*)
             (t "")))
      (dolist (x replace-string-alist)
        (setq header (substitute-string header (car x) (cdr x)))
        (setq footer (substitute-string footer (car x) (cdr x))))

      (with-output-to-buffer (output-buffer)
        (format t "~A" header)
        (outline-tree-output-heading-html-toc root-node target-node-count output-depth)
        (outline-tree-output-heading-html-main root-node target-node-count output-depth)
        (format t "~A" footer))
      (pop-to-buffer output-buffer t)
      (refresh-screen))))

(defun outline-tree-output-heading-html-target-node-count (root-node output-depth)
  "見出しノードHTML出力: 処理対象のノードの数を返す"
  (let ((count 0) node)
    (labels ((outline-tree-output-heading-html-target-node-count-1 (node level)
               (when (or (outline-tree-heading-node-p node)
                         (and (= level 1) (outline-tree-header-node-p node)))
                 (incf count)
                 (when (and (outline-tree-node-has-children-p node)
                            (or (not (eq output-depth :expand)) (treeview::treeview-expand-p node)))
                   (setq node (treeview::treeview-get-child-item node))
                   (while (outline-tree-node-valid-p node)
                     (outline-tree-output-heading-html-target-node-count-1 node (1+ level))
                     (setq node (treeview::treeview-get-next-sibling-item node)))))))
      (when (and (outline-tree-node-has-children-p root-node)
                 (or (not (eq output-depth :expand)) (treeview::treeview-expand-p root-node)))
        (setq node (treeview::treeview-get-child-item root-node))
        (while (outline-tree-node-valid-p node)
          (outline-tree-output-heading-html-target-node-count-1 node 1)
          (setq node (treeview::treeview-get-next-sibling-item node))))
      count)))

(defun outline-tree-output-heading-html-toc (root-node target-node-count output-depth)
  "見出しノードHTML出力: メニュー部HTMLを返す"
  (let ((sec-num 0) node (node-count 0))
    (labels ((outline-tree-output-heading-html-toc-1 (node level)
               (let (str)
                 (format t "~V@{~A~:*~}" (1+ (* 2 (1- level))) "  ")
                 (setq str (outline-tree-data-get-node-name node))
                 (dolist (x *outline-tree-output-string-encode-alist*)
                   (setq str (substitute-string str (car x) (cdr x))))
                 (format t "<li class=\"lv~D\">" level)
                 (cond
                  ((or (outline-tree-heading-node-p node)
                       (and (= level 1) (outline-tree-header-node-p node)))
                   (incf node-count)
                   (message "toc processing: ~D/~D" node-count target-node-count)
                   (incf sec-num)
                   (format t "<a href=\"#SEC~D\" name=\"TOC~D\" title=\"main\">~A</a>"
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
                     (outline-tree-output-heading-html-toc-1 node level)
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
          (outline-tree-output-heading-html-toc-1 node 1)
          (setq node (treeview::treeview-get-next-sibling-item node)))
        (format t "~A~%" "</ul>"))
      (format t "~A~%" "</div>"))))

(defun outline-tree-output-heading-html-main (root-node target-node-count output-depth)
  "見出しノードHTML出力: メイン部HTMLを返す"
  (let ((sec-num 0) node (node-count 0))
    (labels ((outline-tree-output-heading-html-main-1 (node level)
               (let (str range from to)
                 (cond
                  ((or (outline-tree-heading-node-p node)
                       (and (= level 1) (outline-tree-header-node-p node)))
                   (incf node-count)
                   (message "main processing: ~D/~D" node-count target-node-count)
                   (setq str (outline-tree-data-get-node-name node))
                   (dolist (x *outline-tree-output-string-encode-alist*)
                     (setq str (substitute-string str (car x) (cdr x))))
                   (incf sec-num)
                   (format t "<h~D class=\"lv~D\">" (if (<= level 6) level 6) level)
                   (format t "<a href=\"#TOC~D\" name=\"SEC~D\" title=\"toc\">~A</a>"
                           sec-num sec-num str)
                   (format t "</h~D>~%" (if (<= level 6) level 6))
                   (format t "<div class=\"lv~D\">" level)
                   (cond
                    ((outline-tree-header-node-p node)
                     (setq range (outline-tree-data-get-whole-range node)))
                    ((eq output-depth :expand)
                     (setq range (outline-tree-data-get-output-range node)))
                    (t
                     (setq range (outline-tree-data-get-contents-range node))))
                   (setq from (outline-tree-get-range-from range)
                         to (outline-tree-get-range-to range))
                   (if (and (< from to)
                            (save-excursion (goto-char from) (skip-chars-forward " \t\n") (< (point) to)))
                       (setq str (buf2html-get-region-string from to nil t))
                     (setq str ""))
                   (format t "~A" str)
                   (format t "</div>~%")))
                 (when (and (outline-tree-node-has-children-p node)
                            (or (not (eq output-depth :expand)) (treeview::treeview-expand-p node)))
                   (setq node (treeview::treeview-get-child-item node))
                   (while (outline-tree-node-valid-p node)
                     (outline-tree-output-heading-html-main-1 node (1+ level))
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
              (outline-tree-output-heading-html-main-1 node 1)
              (setq node (treeview::treeview-get-next-sibling-item node))))
          (format t "~A~%" "</div>"))))))

;;; op-heading-html.l ends here
