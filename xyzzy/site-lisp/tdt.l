; �t�b�N
(defvar *tdt-mode-hook* nil)

; �L�[�}�b�v
(defvar *tdt-mode-map* nil)
(unless *tdt-mode-map*
  (setq *tdt-mode-map* (make-sparse-keymap)))

; �L�[���[�h
(defvar *tdt-keyword-hash-table* nil)
(defvar *tdt-keyword-file* "TDT")

; �V���^�b�N�X�e�[�u��
; �R�����g�\������
(defvar *tdt-mode-syntax-table* nil)
(unless *tdt-mode-syntax-table*
  (setq *tdt-mode-syntax-table* (make-syntax-table))
  (set-syntax-symbol *tdt-mode-syntax-table* #\$)
  (set-syntax-start-comment *tdt-mode-syntax-table* #\# t)
  (set-syntax-end-comment *tdt-mode-syntax-table* #\LFD t t))

 



(defun tdt-mode ()
  (interactive)
  (kill-all-local-variables)
  (setq buffer-mode 'tdt-mode)
  (setq mode-name "TDT")
  (use-keymap *tdt-mode-map*)
  (use-syntax-table *tdt-mode-syntax-table*)
  ; �L�[���[�h�̃��[�h
  (and *tdt-keyword-file*
       (null *tdt-keyword-hash-table*)
       (setq *tdt-keyword-hash-table*
	     (load-keyword-file *tdt-keyword-file* t)))
  (when *tdt-keyword-hash-table*
    (make-local-variable 'keyword-hash-table)
    (setq keyword-hash-table *tdt-keyword-hash-table*))
  ; �t�b�N�̎��s
  (run-hooks '*tdt-mode-hook*))
