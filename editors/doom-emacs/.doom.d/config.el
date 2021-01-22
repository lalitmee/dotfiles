;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

(after! doom-themes
  (setq
   doom-themes-enable-bold t
   doom-themes-enable-italic t))

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Lalit Kumar"
      user-mail-address "lalitkumar.meena.lk@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; (setq doom-font (font-spec :family "FantasqueSansMono Nerd Font" :size 16))
(setq doom-font (font-spec :family "CaskaydiaCove Nerd Font" :size 13))
;; (setq doom-font (font-spec :family "Mononoki Nerd Font" :size 15))
;; (setq doom-font (font-spec :family "OperatorMono Nerd Font" :size 15 :weight 'light))
;; (setq doom-font (font-spec :family "CodeNewRoman Nerd Font" :size 16))
;; (setq doom-font (font-spec :family "UbuntuMono Nerd Font" :size 17))
;; (setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 14 :weight 'semi-bold))
;; (setq doom-font (font-spec :family "SauceCodePro Nerd Font" :size 15 :weight 'semi-bold))
;; (setq doom-font (font-spec :family "FiraCode Nerd Font" :size 14))
;; (setq doom-font (font-spec :family "Recursive Mono Casual Static" :size 15))
;; (setq doom-font (font-spec :family "OverpassMono Nerd Font" :size 15))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-vibrant)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org")

(setq projectile-project-search-path '("~/Desktop/Github"
                                       "~/Desktop/koinearth"
                                       "~/Desktop/GitLab"))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)
(global-wakatime-mode)
(setq wakatime-cli-path "/home/linuxbrew/.linuxbrew/bin/wakatime")

;; modeline settings
;; The maximum displayed length of the branch name of version control.
(setq doom-modeline-height 30)
(setq doom-modeline-vcs-max-length 20)
(after! doom-modeline
  (display-battery-mode t))

;; open emacs fully maximized
(add-to-list 'initial-frame-alist '(fullscreen . maximized))


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; centered cursor mode
(setq scroll-preserve-screen-position t
      scroll-conservatively 0
      maximum-scroll-margin 0.5
      scroll-margin 99999)


;; tags file too large warning
(setq large-file-warning-threshold nil)

;; lockfile create stop
(setq create-lockfiles nil)

;; tide mode setup
(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

(setq-hook! 'js2-mode-hook flycheck-checker 'javascript-eslint)
(add-hook! 'js2-mode-hook #'setup-tide-mode)

(after! prettier-js
  (setq-hook! 'js2-mode-hook 'prettier-js-mode)
  ;; prettier settings
  (setq prettier-js-args '("--trailing-comma" "all"
                           "--print-width" "80"
                           "--tab-width" "2"
                           "--html-whitespace-sensitivity" "ignore"
                           "--arrow-parens" "avoid"
                           ))
  )


(after! vimrc-mode
  (add-to-list 'auto-mode-alist '("\\.vim\\(rc\\)?\\'" . vimrc-mode)))

;; A simple config:
(after! solaire-mode
  (setq-hook! . 'solaire-global-mode))

;; lsp file watcher
(setq lsp-file-watch-threshold 5000)
(setq lsp-enable-file-watchers nil)
