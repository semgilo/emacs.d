;;; init-python.el --- Python editing -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:


;; See the following note about how I set up python + virtualenv to
;; work seamlessly with Emacs:
;; https://gist.github.com/purcell/81f76c50a42eee710dcfc9a14bfc7240


;; (setq auto-mode-alist
;;       (append '(("SConstruct\\'" . python-mode)
;;                 ("SConscript\\'" . python-mode))
;;               auto-mode-alist))

;; (require-package 'pip-requirements)
(require-package 'elpy)
(require-package 'ein)
(elpy-enable)

(defun setup-my-python-env ()
  (setq indent-tabs-mode nil)
  (setq tab-always-indent nil)
  (setq python-indent-offset 4)
  (setq python-indent 4)
  (setq python-indent-guess-indent-offset-verbose nil)
  (setq-default indent-tabs-mode nil)
  (setq tab-width 4)
  )

(after-load 'python
  (add-hook 'python-mode-hook 'setup-my-python-env)
  (setq python-shell-interpreter "jupyter"
        python-shell-interpreter-args "console --simple-prompt"
        python-shell-prompt-detect-failure-warning nil)
  (add-to-list 'python-shell-completion-native-disabled-interpreters
               "jupyter")
  (when (maybe-require-package 'flycheck)
    (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
    (add-hook 'elpy-mode-hook 'flycheck-mode))
  )

(defun python-send-buffer-with-my-args (args)
  (interactive "sPython arguments: ")
  (let ((source-buffer (current-buffer)))
    (with-temp-buffer
      (insert "import sys; sys.argv'''" args "'''.split()\n")
      (insert-buffer-substring source-buffer)
      (elpy-shell-send-region-or-buffer))))

(require-package 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

;; (when (maybe-require-package 'anaconda-mode)
;;   (after-load 'python
;;     ;; Anaconda doesn't work on remote servers without some work, so
;;     ;; by default we enable it only when working locally.
;;     (add-hook 'python-mode-hook
;;               (lambda () (unless (file-remote-p default-directory)
;;                       (anaconda-mode 1))))
;;     (add-hook 'anaconda-mode-hook 'anaconda-eldoc-mode))
;;   (after-load 'anaconda-mode
;;     (define-key anaconda-mode-map (kbd "M-?") nil))
;;   (when (maybe-require-package 'company-anaconda)
;;     (after-load 'company
;;       (after-load 'python
;;         (push 'company-anaconda company-backends)))))




(provide 'init-python)
;;; init-python.el ends here
