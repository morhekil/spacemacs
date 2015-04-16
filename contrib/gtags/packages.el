;;; packages.el --- gtags Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2014 Sylvain Benner
;; Copyright (c) 2014-2015 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(setq gtags-packages
  '(
    ;; package gtagss go here
    helm-gtags
    ggtags
    ))

;; For each package, define a function gtags/init-<package-gtags>
;;
(defun gtags/init-ggtags ()
  "Initialize my package"
  (use-package ggtags
    :defer t
    :init
    (progn
      (add-hook 'prog-mode-hook
                (lambda ()
                  ;; these modes have better eldoc integration
                  (unless (derived-mode-p 'c-mode
                                          'c++-mode
                                          'lisp-mode
                                          'emacs-lisp-mode
                                          'python-mode
                                          'ruby-mode)
                    (ggtags-mode 1)
                    (eldoc-mode 1)
                    (setq-local eldoc-documentation-function #'ggtags-eldoc-function)))))))

(defun gtags/init-helm-gtags ()
  (use-package helm-gtags
    :defer t
    :init
    (progn
      (setq helm-gtags-ignore-case t
            helm-gtags-auto-update t
            helm-gtags-use-input-at-cursor t
            helm-gtags-pulse-at-cursor t)

      (defun spacemacs/gtags-define-keys-for-mode (mode)
        "Define key bindings for the specific MODE."
        (when (fboundp mode)
          (add-hook (intern (concat (symbol-name mode) "-hook")) 'helm-gtags-mode)

          (evil-leader/set-key-for-mode mode
            "mgc" 'helm-gtags-create-tags
            "mgd" 'helm-gtags-find-tag
            "mgf" 'helm-gtags-select-path
            "mgg" 'helm-gtags-dwim
            "mgi" 'helm-gtags-tags-in-this-function
            "mgl" 'helm-gtags-parse-file
            "mgn" 'helm-gtags-next-history
            "mgp" 'helm-gtags-previous-history
            "mgr" 'helm-gtags-find-rtag
            "mgR" 'helm-gtags-resume
            "mgs" 'helm-gtags-select
            "mgS" 'helm-gtags-show-stack
            "mgu" 'helm-gtags-update-tags))))
    :config
    (progn
      ;; if anyone uses helm-gtags, they would want to use these key bindings
      (define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
      (define-key helm-gtags-mode-map (kbd "C-x 4 .") 'helm-gtags-find-tag-other-window)
      (define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
      (define-key helm-gtags-mode-map (kbd "M-*") 'pop-tag-mark)

      ;; modes that do not have a layer, define here
      (spacemacs/gtags-define-keys-for-mode 'tcl-mode)
      (spacemacs/gtags-define-keys-for-mode 'java-mode)
      (spacemacs/gtags-define-keys-for-mode 'vhdl-mode)
      (spacemacs/gtags-define-keys-for-mode 'shell-script-mode)
      (spacemacs/gtags-define-keys-for-mode 'awk-mode)
      (spacemacs/gtags-define-keys-for-mode 'asm-mode)
      (spacemacs/gtags-define-keys-for-mode 'dired-mode))))