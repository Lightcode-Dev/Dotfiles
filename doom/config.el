;; This is my custom private config Remember, you do not need to run doom
;; sync' after modifying this file!
;; Full Name and email.
;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Nathan burke"
      user-mail-address "dev@bigland.cc")

(setq doom-theme 'doom-tokyo-night)
(setq display-line-numbers-type t)
(setq doom-font (font-spec :family "Terminess Nerd Font Mono" :size 12 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "Terminess Nerd Font" :size 13))

(after! org
  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)"))))

(after! org
  (require 'org-checklist))

(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subfeatures are done."
  (let ((todo-state (org-get-todo-state)))
    (cond ((= n-not-done 0)
           (unless (string= todo-state "DONE")
             (org-todo "DONE")))
          (t
           (unless (string= todo-state "TODO")
             (org-todo "TODO"))))))

(add-hook 'org-after-todo-statistics-hook #'org-summary-todo)

(after! spellcheck
  (setq ispell-program-name "hunspell")
  ;; Force hunspell to look in the standard Arch Linux directory
  (setenv "DICPATH" "/usr/share/hunspell")
  ;; Configure English (US) as the default dictionary variables
  (setq ispell-local-dictionary "en_US"
        ispell-dictionary "en_US")
  ;; Tell Doom's lookup logic to use en_US specifically
  (setq ispell-hunspell-dict-elements '("en_US")))
