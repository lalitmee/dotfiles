;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Lalit Kumar"
      user-mail-address "lalitkumar.meena.lk@gmail.com"
      command-line-default-directory "~/"         ; set default directory to home
      +doom-dashboard-pwd-policy "~/"
      default-directory "~/"
      ns-use-proxy-icon nil                       ; empty title
      frame-title-format '"\n"                    ; use a new-line to make sure rezising info is on the next line
      undo-limit 80000000                         ; Raise undo-limit to 80Mb
      evil-want-fine-undo t                       ; By default while in insert all changes are one big blob. Be more granular
      auto-save-default t                         ; Nobody likes to loose work, I certainly don't
      truncate-string-ellipsis "…"                ; Unicode ellispis are nicer than "...", and also save /precious/ space
      which-key-idle-delay 0.3                    ; Show key binding help quicker
      which-key-idle-secondary-delay 0
      shell-file-name "/bin/sh"       ; Use Bash as default shell for running term which is faster
      vterm-always-compile-module t               ; Compile the vterm-module when needed without asking
      vterm-shell "/usr/bin/zsh")


;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "OperatorMono Lig" :size 14)
      doom-variable-pitch-font (font-spec :family "Ubuntu Mono" :size 13)
      doom-big-font (font-spec :family "MonoLisa" :size 24))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox)

(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))

(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
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
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; projectile projects
(setq projectile-project-search-path '(("~/" . 1)
                                       "~/Desktop/Github"
                                       ("~/Desktop/koinearth/marketsn" . 1)
                                       ("~/Desktop/koinearth/ngagen" . 1)))

;; TAGS file large warning
(setq large-file-warning-threshold nil)

;; lua diagnostics global keywords
(after! lsp-mode
  (setq lsp-lua-diagnostics-globals ["vim"]))

;; org bullets mode
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(use-package! wakatime-mode
  :hook (after-init . global-wakatime-mode)
  :config
  (setq wakatime-cli-path "/home/linuxbrew/.linuxbrew/bin/wakatime-cli"
        wakatime-python-bin "/home/lalitmee/.pyenv/shims/python"))
