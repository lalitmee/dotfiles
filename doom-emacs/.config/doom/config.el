;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; (setq doom-font (font-spec :family "Operator Mono Lig" :size 14 :weight 'normal)
;;       doom-variable-pitch-font (font-spec :family "Operator Mono Lig" :size 13))

(setq doom-font (font-spec :family "IoskeleyMono Nerd Font" :size 14 :weight 'medium)
      doom-variable-pitch-font (font-spec :family "IoskeleyMono Nerd Font" :size 13))

(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))

(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  ;; '(font-lock-keyword-face :slant italic)
  ;; '(italic :family "Operator Mono Lig" :slant italic))
  '(italic :family "IoskeleyMono Nerd Font" :slant italic))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

(add-hook 'window-setup-hook #'toggle-frame-maximized)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Projects/Personal/Github/second-brain")
(load! "+org-second-brain")

;; React / TypeScript / ESLint (per-repo): prefer yarn --immutable / frozen lockfile.
;;   yarn add -D typescript typescript-language-server prettier eslint
;; ESLint LSP client lives inside lsp-mode (`lsp-eslint`); first run may prompt to
;; install the vscode-eslint server via lsp-mode, or set `lsp-eslint-server-command'.
;;
;; LSP keys (Doom default): global `SPC c` — e.g. `SPC c l` (`lsp-command-map`),
;; `SPC c a` (code action), `SPC c r` (rename), `SPC c j` / `SPC c J` (consult symbols).
;; Verify: `M-x describe-mode` → typescript-ts-mode / tsx-ts-mode; `M-x lsp-describe-session`.
;; Tree-sitter grammars: finish `doom sync` if *.tsx warns about missing libtree-sitter-*.so.

(setq projectile-enable-caching nil
      projectile-project-search-path
      '(("~/Projects/Personal/Github" . 2)
        ("~/Projects/Work/Github" . 2)))

;; Enable orderless-flex by default so `abc' matches flexibly (like `aXbYcZ')
;; instead of requiring the `~' prefix. Keeps vertico/corfu working.
(after! orderless
  (orderless-define-completion-style orderless-flex
    (orderless-matching-styles '(orderless-flex)))
  (setq completion-styles '(orderless-flex basic)
        completion-category-overrides '((file (styles orderless-flex partial-completion)))))

(after! lsp-mode
  (setq lsp-eslint-package-manager "yarn")
  (require 'lsp-eslint)
  ;; Prefer tsgo (go-native typescript LSP) over node ts-ls
  (setq lsp-client-priority '(:tsgo 1 :ts-ls 0)))

(after! lsp-ui
  (setq lsp-ui-sideline-show-hover t
        lsp-ui-sideline-show-code-actions t))

;; Force line numbers via globalized mode (avoids prog-mode-hook ordering issues)
(global-display-line-numbers-mode 1)

;; Prettierd as default formatter for JS/TS
(setq +format-with-lsp nil)
(let ((npm-global (ignore-errors
                    (string-trim (shell-command-to-string "npm root -g")))))
  (when (and npm-global (file-directory-p npm-global))
    (add-to-list 'exec-path (expand-file-name "../bin" npm-global))))
(after! apheleia
  (setf (alist-get 'prettierd apheleia-formatters)
        '("prettierd" "--stdin-filepath" filepath))
  (dolist (mode '(tsx-ts-mode typescript-ts-mode js-ts-mode))
    (push (cons mode 'prettierd) apheleia-mode-alist)))

;; dape — modern DAP client for JS/TS debugging
(use-package! dape
  :commands (dape dape-debug-dap-mode)
  :config
  (setq dape-can-set-options t))

;; gptel — AI chat with multiple providers
(use-package! gptel
  :commands (gptel gptel-send)
  :config
  (setq gptel-default-mode 'org-mode)
  ;; Backends from environment variables
  (gptel-make-openai "OpenAI"
    :key (getenv "OPENAI_API_KEY")
    :stream t)
  (gptel-make-anthropic "Claude"
    :key (getenv "ANTHROPIC_API_KEY")
    :stream t)
  (gptel-make-ollama "Ollama"
    :host "localhost:11434"
    :stream t)
  (gptel-make-gemini "Gemini"
    :key (getenv "GEMINI_API_KEY")
    :stream t))

;; Copilot inline completions
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
         ("<tab>" . 'copilot-accept-completion)
         ("TAB" . 'copilot-accept-completion)
         ("C-<tab>" . 'copilot-accept-completion-by-word)
         ("C-n" . 'copilot-next-completion)
         ("C-p" . 'copilot-previous-completion)))

;; Vertico / Orderless sanity check (after `doom sync` + restart):
;;   M-x describe-variable RET completion-styles RET → expect `orderless'
;;   M-x describe-variable RET vertico-mode RET → should be on

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

;; Disable quit confirmation popup
(setq confirm-kill-emacs nil)

;; ponytail: compat provides extended seconds-to-string but doesn't override
;; built-in. Marginalia calls it with 3 args (Emacs 31+ signature).
(when (and (< emacs-major-version 31)
           (fboundp 'compat--seconds-to-string))
  (fset 'seconds-to-string #'compat--seconds-to-string))

