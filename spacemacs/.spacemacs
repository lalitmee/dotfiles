;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Configuration Layers declaration.
You should not put any user code in this function besides modifying the variable
values."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   dotspacemacs-distribution 'spacemacs
   ;; Lazy installation of layers (i.e. layers are installed only when a file
   ;; with a supported type is opened). Possible values are `all', `unused'
   ;; and `nil'. `unused' will lazy install only unused layers (i.e. layers
   ;; not listed in variable `dotspacemacs-configuration-layers'), `all' will
   ;; lazy install any layer that support lazy installation even the layers
   ;; listed in `dotspacemacs-configuration-layers'. `nil' disable the lazy
   ;; installation feature and you have to explicitly list a layer in the
   ;; variable `dotspacemacs-configuration-layers' to install it.
   ;; (default 'unused)
   dotspacemacs-enable-lazy-installation 'unused
   ;; If non-nil then Spacemacs will ask for confirmation before installing
   ;; a layer lazily. (default t)
   dotspacemacs-ask-for-lazy-installation t
   ;; If non-nil layers with lazy install support are lazy installed.
   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '()
   ;; List of configuration layers to load.
   dotspacemacs-configuration-layers
   '(
     ;; ----------------------------------------------------------------
     ;; Example of useful layers you may want to use right away.
     ;; Uncomment some layer names and press <SPC f e R> (Vim style) or
     ;; <M-m f e R> (Emacs style) to install them.
     ;; ----------------------------------------------------------------

     ;; languages layers
     better-defaults
     chrome
     colors
     dash
     deft
     docker
     emacs-lisp
     emoji
     evil-snipe
     fasd
     helm
     html
     ibuffer
     imenu-list
     lua
     markdown
     pandoc
     python
     search-engine
     semantic
     shell
     spacemacs-navigation
     spotify
     syntax-checking
     version-control
     vimscript
     yaml
     ;; layers with custom variables
     ;; (rebox :variables rebox-enable-in-text-mode t)
     (go :variables go-use-gometalinter t)
     (auto-completion :variables
                      auto-completion-return-key-behavior 'complete
                      auto-completion-tab-key-behavior 'cycle
                      auto-completion-complete-with-key-sequence nil
                      auto-completion-complete-with-key-sequence-delay 0.1
                      auto-completion-minimum-prefix-length 2
                      auto-completion-idle-delay 0.2
                      auto-completion-private-snippets-directory nil
                      auto-completion-enable-snippets-in-popup nil
                      auto-completion-use-company-box nil
                      auto-completion-enable-help-tooltip t
                      auto-completion-enable-help-tooltip 'manual
                      auto-completion-enable-sort-by-usage t)
     (helm :variables
           helm-enable-auto-resize t
           spacemacs-helm-rg-max-column-number 1024
           helm-use-fuzzy 'source)
     (git :variables
          git-enable-magit-delta-plugin t
          git-enable-magit-gitflow-plugin t
          git-enable-magit-svn-plugin t
          git-enable-magit-todos-plugin t)
     (javascript :variables
                 javascript-backend 'tide
                 javascript-linter 'eslint
                 javascript-fmt-tool 'prettier
                 javascript-fmt-on-save t)
     (typescript :variables
                 typescript-backend 'tide
                 typescript-linter 'eslint
                 typescript-fmt-tool 'prettier
                 typescript-fmt-on-save t)
     (org :variables
          org-enable-sticky-header t
          org-enable-epub-support t
          org-enable-github-support t
          org-enable-bootstrap-support t
          org-enable-reveal-js-support t)
     ;; functionalities layers
     (shell :variables
            shell-default-height 50
            shell-default-position 'bottom
            shell-default-term-shell "/bin/zsh"
            shell-default-full-span nil
            shell-default-shell 'eshell)
     (colors :variables
             colors-colorize-identifiers 'variables)
     (ranger :variables
             ranger-show-preview t
             ranger-cleanup-eagerly t
             ranger-cleanup-on-disable t
             ranger-ignored-extensions '("mkv" "flv" "iso" "mp4"))
     (wakatime :variables
               ;; use the actual wakatime path
               wakatime-cli-path "/home/lalitmee/.pyenv/shims/wakatime")

     )
   ;; List of additional packages that will be installed without being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages, then consider creating a layer. You can also put the
   ;; configuration in `dotspacemacs/user-config'.
   dotspacemacs-additional-packages '(forge
                                      all-the-icons
                                      all-the-icons-dired
                                      all-the-icons-ivy
                                      auto-package-update
                                      auto-rename-tag
                                      auto-yasnippet
                                      beacon
                                      company-tabnine
                                      doom-modeline
                                      doom-themes
                                      emojify
                                      format-all
                                      multiple-cursors
                                      ox-reveal
                                      try
                                      yasnippet-snippets)

   ;; A list of packages that cannot be updated.
   dotspacemacs-frozen-packages '()
   ;; A list of packages that will not be installed and loaded.
   dotspacemacs-excluded-packages '(scss-mode)
   ;; Defines the behaviour of Spacemacs when installing packages.
   ;; Possible values are `used-only', `used-but-keep-unused' and `all'.
   ;; `used-only' installs only explicitly used packages and uninstall any
   ;; unused packages as well as their unused dependencies.
   ;; `used-but-keep-unused' installs only the used packages but won't uninstall
   ;; them if they become unused. `all' installs *all* packages supported by
   ;; Spacemacs and never uninstall them. (default is `used-only')
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/init ()
  "Initialization function.
This function is called at the very startup of Spacemacs initialization
before layers configuration.
You should not put any user code in there besides modifying the variable
values."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; If non nil ELPA repositories are contacted via HTTPS whenever it's
   ;; possible. Set it to nil if you have no way to use HTTPS in your
   ;; environment, otherwise it is strongly recommended to let it set to t.
   ;; This variable has no effect if Emacs is launched with the parameter
   ;; `--insecure' which forces the value of this variable to nil.
   ;; (default t)
   dotspacemacs-elpa-https t
   ;; Maximum allowed time in seconds to contact an ELPA repository.
   dotspacemacs-elpa-timeout 5
   ;; If non nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. Note that checking for
   ;; new versions works via git commands, thus it calls GitHub services
   ;; whenever you start Emacs. (default nil)
   dotspacemacs-check-for-update nil
   ;; If non-nil, a form that evaluates to a package directory. For example, to
   ;; use different package directories for different Emacs versions, set this
   ;; to `emacs-version'.
   dotspacemacs-elpa-subdirectory nil
   ;; One of `vim', `emacs' or `hybrid'.
   ;; `hybrid' is like `vim' except that `insert state' is replaced by the
   ;; `hybrid state' with `emacs' key bindings. The value can also be a list
   ;; with `:variables' keyword (similar to layers). Check the editing styles
   ;; section of the documentation for details on available variables.
   ;; (default 'vim)
   dotspacemacs-editing-style 'vim
   ;; If non nil output loading progress in `*Messages*' buffer. (default nil)
   dotspacemacs-verbose-loading nil
   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed. (default 'official)
   dotspacemacs-startup-banner 'official
   ;; List of items to show in startup buffer or an association list of
   ;; the form `(list-type . list-size)`. If nil then it is disabled.
   ;; Possible values for list-type are:
   ;; `recents' `bookmarks' `projects' `agenda' `todos'."
   ;; List sizes may be nil, in which case
   ;; `spacemacs-buffer-startup-lists-length' takes effect.
   dotspacemacs-startup-lists '((recents . 5)
                                (projects . 7))
   ;; True if the home buffer should respond to resize events.
   dotspacemacs-startup-buffer-responsive t
   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'text-mode
   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press <SPC> T n to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes '(
                         doom-gruvbox
                         doom-nord
                         doom-dark+
                         doom-molokai
                         doom-oceanic-next
                         doom-one
                         doom-palenight
                         spacemacs-dark)
   ;; If non nil the cursor color matches the state color in GUI Emacs.
   dotspacemacs-colorize-cursor-according-to-state t
   ;; Default font, or prioritized list of fonts. `powerline-scale' allows to
   ;; quickly tweak the mode-line size to make separators look not too crappy.
   dotspacemacs-default-font '(
                               ;; "CaskaydiaCove Nerd Font"
                               ;; "Ubuntu Mono Nerd Font"
                               ;; "OperatorMono Nerd Font"
                               "JetBrainsMono Nerd Font"
                               ;; "SauceCodePro Nerd Font"
                               :size 14
                               :weight normal
                               :powerline-scale 1.3)
   ;; The leader key
   dotspacemacs-leader-key "SPC"
   ;; The key used for Emacs commands (M-x) (after pressing on the leader key).
   ;; (default "SPC")
   dotspacemacs-emacs-command-key "SPC"
   ;; The key used for Vim Ex commands (default ":")
   dotspacemacs-ex-command-key ":"
   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"
   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","
   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m")
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"
   ;; These variables control whether separate commands are bound in the GUI to
   ;; the key pairs C-i, TAB and C-m, RET.
   ;; Setting it to a non-nil value, allows for separate commands under <C-i>
   ;; and TAB or <C-m> and RET.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab nil
   ;; If non nil `Y' is remapped to `y$' in Evil states. (default nil)
   dotspacemacs-remap-Y-to-y$ nil
   ;; If non-nil, the shift mappings `<' and `>' retain visual state if used
   ;; there. (default t)
   dotspacemacs-retain-visual-state-on-shift t
   ;; If non-nil, J and K move lines up and down when in visual mode.
   ;; (default nil)
   dotspacemacs-visual-line-move-text nil
   ;; If non nil, inverse the meaning of `g' in `:substitute' Evil ex-command.
   ;; (default nil)
   dotspacemacs-ex-substitute-global nil
   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"
   ;; If non nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil
   ;; If non nil then the last auto saved layouts are resume automatically upon
   ;; start. (default nil)
   dotspacemacs-auto-resume-layouts nil
   ;; Size (in MB) above which spacemacs will prompt to open the large file
   ;; literally to avoid performance issues. Opening a file literally means that
   ;; no major mode or minor modes are active. (default is 1)
   dotspacemacs-large-file-size 1
   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; (default 'cache)
   dotspacemacs-auto-save-file-location 'cache
   ;; Maximum number of rollback slots to keep in the cache. (default 5)
   dotspacemacs-max-rollback-slots 5
   ;; If non nil, `helm' will try to minimize the space it uses. (default nil)
   dotspacemacs-helm-resize 1
   ;; if non nil, the helm header is hidden when there is only one source.
   ;; (default nil)
   dotspacemacs-helm-no-header nil
   ;; define the position to display `helm', options are `bottom', `top',
   ;; `left', or `right'. (default 'bottom)
   dotspacemacs-helm-position 'bottom
   ;; Controls fuzzy matching in helm. If set to `always', force fuzzy matching
   ;; in all non-asynchronous sources. If set to `source', preserve individual
   ;; source settings. Else, disable fuzzy matching in all sources.
   ;; (default 'always)
   dotspacemacs-helm-use-fuzzy 'source
   ;; If non nil the paste micro-state is enabled. When enabled pressing `p`
   ;; several times cycle between the kill ring content. (default nil)
   dotspacemacs-enable-paste-transient-state nil
   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4
   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom
   ;; If non nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t
   ;; If non nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil
   ;; If non nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil
   ;; If non nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default nil) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup t
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90
   ;; If non nil show the titles of transient states. (default t)
   dotspacemacs-show-transient-state-title t
   ;; If non nil show the color guide hint for transient state keys. (default t)
   dotspacemacs-show-transient-state-color-guide t
   ;; If non nil unicode symbols are displayed in the mode line. (default t)
   dotspacemacs-mode-line-unicode-symbols t

   ;; If non nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters point
   ;; when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling t
   ;; Control line numbers activation.
   ;; If set to `t' or `relative' line numbers are turned on in all `prog-mode' and
   ;; `text-mode' derivatives. If set to `relative', line numbers are relative.
   ;; This variable can also be set to a property list for finer control:
   ;; '(:relative nil
   ;;   :disabled-for-modes dired-mode
   ;;                       doc-view-mode
   ;;                       markdown-mode
   ;;                       org-mode
   ;;                       pdf-view-mode
   ;;                       text-mode
   ;;   :size-limit-kb 1000)
   ;; (default nil)
   dotspacemacs-line-numbers 'relative
   ;; Code folding method. Possible values are `evil' and `origami'.
   ;; (default 'evil)
   dotspacemacs-folding-method 'evil
   ;; If non-nil smartparens-strict-mode will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil
   ;; If non-nil pressing the closing parenthesis `)' key in insert mode passes
   ;; over any automatically added closing parenthesis, bracket, quote, etc…
   ;; This can be temporary disabled by pressing `C-q' before `)'. (default nil)
   dotspacemacs-smart-closing-parenthesis t
   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'all
   ;; If non nil, advise quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server nil
   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `ag', `pt', `ack' and `grep'.
   ;; (default '("ag" "pt" "ack" "grep"))
   dotspacemacs-search-tools '("ag" "pt" "ack" "grep")
   ;; The default package repository used if no explicit repository has been
   ;; specified with an installed package.
   ;; Not used for now. (default nil)
   dotspacemacs-default-package-repository nil
   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed'to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup nil

   dotspacemacs-mode-line-theme 'doom
   ))

(defun dotspacemacs/user-init ()
  "Initialization function for user code.
It is called immediately after `dotspacemacs/init', before layer configuration
executes.
 This function is mostly useful for variables that need to be set
before packages are loaded. If you are unsure, you should try in setting them in
`dotspacemacs/user-config' first."
  (setq-default
   linum-format "%4d \u2502"
   linum-relative-format "%4s \u2502")
  (set-face-italic-p 'italic t)
  (setq exec-path-from-shell-arguments '("-l"))

  (setq helm-dash-docsets-path "~/.docsets")
  (setq helm-dash-min-length '3))

(defun dotspacemacs/user-config ()
  "Configuration function for user code.
This function is called at the very end of Spacemacs initialization after
layers configuration.
This is the place where most of your configurations should be done. Unless it is
explicitly specified that a variable should be set before a package is loaded,
you should place your code here."

  (beacon-mode 1)


  ;; all the icons settings from mike zamansky
  (use-package all-the-icons
    :ensure t
    :defer 0.5)
  (use-package all-the-icons-ivy
    :ensure t
    :after (all-the-icons ivy)
    :custom (all-the-icons-ivy-buffer-commands '(ivy-switch-buffer-other-window ivy-switch-buffer))
    :config
    (add-to-list 'all-the-icons-ivy-file-commands 'counsel-dired-jump)
    (add-to-list 'all-the-icons-ivy-file-commands 'counsel-find-library)
    (all-the-icons-ivy-setup))
  (use-package all-the-icons-dired
    :ensure t)
  (add-hook 'dired-mode-hook 'all-the-icons-dired-mode)

  ;; company-tabnine settings
  ;; (add-to-list 'company-backends #'company-tabnine)

  ;; project project search path
  (setq projectile-project-search-path
        '("~/Desktop/Github/"
          "~/Desktop/koinearth/"))

  ;; ranger
  (setq ranger-show-dotfiles t)
  (setq ranger-show-literal nil)

  ;; Org Mode Settings
  (require 'org-tempo)
  ;; org-templates expansion
  (setq org-reveal-note-key-char nil)
  ;; changing the org-mode bullets
  (setq org-bullets-bullet-list '("◉" "◎" "⚫" "○" "►" "◇"))
  ;; for having a list of options on pressing `t` in org mode
  (setq org-todo-keywords
        '((sequence
           "TODO(t!)"
           "NEXT(n!)"
           "DOINGNOW(d!)"
           "BLOCKED(b!)"
           "TODELEGATE(g!)"
           "DELEGATED(D!)"
           "FOLLOWUP(f!)"
           "TICKLE(T!)"
           "|"
           "CANCELLED(c!)"
           "DONE(F!)")))
  ;; pdf.js and reveal.js settings
  (require 'ox-reveal)
  (require 'ox-latex)
  (use-package ox-reveal
    :ensure ox-reveal)
  (setq org-reveal-root "https://cdn.jsdelivr.net/npm/reveal.js")
  (setq org-reveal-mathjax t)
  (unless (boundp 'org-latex-classes)
    (setq org-latex-classes nil))
  (add-to-list 'org-latex-classes
               '("article"
                 "\\documentclass{article}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

  ;; autocomplete mode is enabled globally
  (global-company-mode)
  (setq ac-ignore-case nil)

  ;; evil search module
  (setq evil-search-module 'isearch)

  ;; centered cursor mode
  (global-centered-cursor-mode +1)

  ;; smart parens mode in programming modes
  (use-package smartparens-config
    :ensure smartparens
    :config (progn (show-smartparens-global-mode t)))
  ;; (add-hook 'prog-mode-hook #'turn-on-smartparens-strict-mode t)
  (add-hook 'markdown-mode-hook #'turn-on-smartparens-strict-mode t)
  (add-hook 'web-mode-hook #'turn-on-smartparens-mode t)

  (add-hook 'prog-mode-hook 'rainbow-mode)
  ;; (add-hook 'prog-mode-hook 'rainbow-identifiers-mode)
  (add-hook 'after-init-hook 'global-color-identifiers-mode)

  ;; Font Settings
  (add-hook 'after-init-hook #'global-emojify-mode)
  (add-hook 'prog-mode-hook 'company-emoji-init)
  (with-eval-after-load 'emoji-cheat-sheet-plus
    (diminish 'emoji-cheat-sheet-plus-display-mode))
  ;; italic comments
  (set-face-italic 'font-lock-comment-face t)

  ;; Color theme for spacemacs
  (use-package doom-themes
    :config
    ;; Global settings (defaults)
    (setq doom-themes-enable-bold t
          doom-themes-enable-italic t))

  (spacemacs/load-theme 'doom-gruvbox)

  ;; doom-modeline configurations
  (setq doom-modeline-vcs-max-length 40)
  (setq doom-modeline-enable-word-count nil)
  (setq doom-modeline-major-mode-color-icon t)
  (setq doom-modeline-modal-icon nil)

  ;; fancy-battery-mode
  (fancy-battery-mode 1)

  ;; for yasnippet
  (yas-global-mode 1)

  ;; total number of lines in a buffer
  ;; page brake lines in prog-mode
  (add-hook 'prog-mode-hook 'page-break-lines-mode)
  (add-hook 'prog-mode-hook 'column-enforce-mode)

  (setq avy-all-windows 'all-frames)

  ;; Wraps long lines in text mode
  (add-hook 'text-mode-hook 'auto-fill-mode)
  (add-hook 'org-mode-hook 'auto-fill-mode)
  (add-hook 'org-mode-hook 'org-indent-mode)

  (setq magit-repository-directories '("~/Desktop/"))
  (setq magit-commit-show-diff nil
        magit-revert-buffers 1)
  (with-eval-after-load 'magit
    (require 'forge))
  (global-git-commit-mode t)

  ;; ace-window configurations : for moving or swapping windows
  (use-package ace-window
    :init
    (progn
      (global-set-key [remap other-window] 'ace-window)
      (custom-set-variables
       '(aw-leading-char-face
         ((t (:inherit ace-jump-face-foreground :height 3.0)))))))

  (add-hook 'web-mode-hook 'auto-rename-tag-mode)

  ;; format all mode settings
  (use-package format-all
    :diminish format-all-mode
    :commands (format-all-buffer format-all-mode)
    :hook (prog-mode . format-all-mode)
    :config
    (setq-default format-all-formatters
                  '(("Nix" nixfmt)
                    ("JavaScript" prettier)
                    ("Lua" (lua-fmt prettier))
                    ("TypeScript" prettier)
                    ("SQL" (pgformatter "-s2"))
                    ("Rust" rustfmt))))

  ;; python mode settings
  ;; python indent offset
  (setq-default python-indent-offset 4)
  ;; formatter hook for python formatter is Black
  (add-hook 'python-mode-hook 'blacken-mode)

  ;; indent and delete modes
  (setq-default agressive-indent-mode t)
  (global-hungry-delete-mode)

  (defun enable-minor-mode (my-pair)
                                        ;Enable minor mode if filename match the regexp.
                                        ;MY-PAIR is a cons cell (regexp . minor-mode).
    (if (buffer-file-name)
        (if (string-match (car my-pair) buffer-file-name)
            (funcall (cdr my-pair)))))

  ;; tags file too large warning
  (setq large-file-warning-threshold nil)

  ;; lockfile create stop
  (setq create-lockfiles nil)
  )

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(all-the-icons-ivy-buffer-commands (quote (ivy-switch-buffer-other-window ivy-switch-buffer)))
 '(ansi-color-names-vector
   ["#1c1e1f" "#e74c3c" "#b6e63e" "#e2c770" "#268bd2" "#fb2874" "#66d9ef" "#d6d6d4"])
 '(aw-leading-char-face ((t (:inherit ace-jump-face-foreground :height 3.0))))
 '(company-quickhelp-color-background "#4F4F4F")
 '(company-quickhelp-color-foreground "#DCDCCC")
 '(custom-safe-themes
   (quote
    ("dc677c8ebead5c0d6a7ac8a5b109ad57f42e0fe406e4626510e638d36bcc42df" "841b0cf4568ead763f166191e6573645011febc638bb32842f9a626cd8cd446a" "6ebdb33507c7db94b28d7787f802f38ac8d2b8cd08506797b3af6cdfd80632e0" "5a7830712d709a4fc128a7998b7fa963f37e960fd2e8aa75c76f692b36e6cf3c" "1263771faf6967879c3ab8b577c6c31020222ac6d3bac31f331a74275385a452" "65f35d1e0d0858947f854dc898bfd830e832189d5555e875705a939836b53054" "6c092c3dbc29ddb59bce4c485df552bdcc5f729404c1c31e22874145733f2501" "5eb4b22e97ddb2db9ecce7d983fa45eb8367447f151c7e1b033af27820f43760" "a455366c5cdacebd8adaa99d50e37430b0170326e7640a688e9d9ad406e2edfd" "04232a0bfc50eac64c12471607090ecac9d7fd2d79e388f8543d1c5439ed81f5" "1367672034423b1be7c81aa63575f822032185c62b27c13f621813c8d53f495c" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default)))
 '(evil-want-Y-yank-to-eol nil)
 '(fci-rule-color "#555556" t)
 '(jdee-db-active-breakpoint-face-colors (cons "#1B2229" "#fd971f"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#1B2229" "#b6e63e"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#1B2229" "#525254"))
 '(nrepl-message-colors
   (quote
    ("#CC9393" "#DFAF8F" "#F0DFAF" "#7F9F7F" "#BFEBBF" "#93E0E3" "#94BFF3" "#DC8CC3")))
 '(objed-cursor-color "#e74c3c")
 '(package-selected-packages
   (quote
    (base16-theme doom-modeline shrink-path mode-icons rjsx-mode emojify forge ghub closql emacsql-sqlite emacsql treepy nord-theme all-the-icons-ivy all-the-icons-dired beacon company-tabnine unicode-escape names polymode json-process-client add-node-modules-path stickyfunc-enhance srefactor emms elisp-format blacken ox-twbs chocolate-theme cobalt helm-dictionary ibuffer-projectile alert log4e spinner ht org-category-capture gntp multiple-cursors hydra parent-mode multi request dash-docs haml-mode gitignore-mode fringe-helper git-gutter+ git-gutter pkg-info epl flx highlight transient with-editor anzu undo-tree all-the-icons memoize magit-popup json-snatcher json-reformat web-completion-data dash-functional tern pos-tip bind-map bind-key autothemer packed pythonic s skewer-mode js2-mode auto-complete popup iedit yasnippet tramp-theme color-theme-modern faff-theme dired-narrow go-guru go-eldoc flycheck-gometalinter company-go go-mode lv auto-package-update pfuture swiper anaconda-mode avy simple-httpd f dash company-quickhelp smooth-scroll xkcd selectric-mode zeal-at-point rebox2 pandoc-mode ox-pandoc helm-dash gmail-message-mode ham-mode html-to-markdown flymd edit-server dockerfile-mode docker tablist docker-tramp deft wakatime-mode zoom sublimity evil-snipe twittering-mode engine-mode rainbow-mode rainbow-identifiers color-identifiers-mode helm-gtags ggtags ng2-mode lsp-mode indium seq treemacs typescript-mode powerline ace-window smartparens evil goto-chg flycheck company helm helm-core markdown-mode projectile magit git-commit async org-plus-contrib ivy babel pretty-symbols pretty-mode typit mmt sudoku pacmacs 2048-game spacemacs-theme zenburn-theme zen-and-art-theme yasnippet-snippets yapfify yaml-mode xterm-color xref-js2 ws-butler winum white-sand-theme which-key web-mode web-beautify volatile-highlights vimrc-mode vi-tilde-fringe uuidgen use-package unfill underwater-theme ujelly-theme twilight-theme twilight-bright-theme twilight-anti-bright-theme try treemacs-projectile treemacs-evil toxi-theme toc-org tide tao-theme tangotango-theme tango-plus-theme tango-2-theme tagedit sunny-day-theme sublime-themes subatomic256-theme subatomic-theme spotify spaceline spacegray-theme soothe-theme solarized-theme soft-stone-theme soft-morning-theme soft-charcoal-theme smyx-theme smeargle slim-mode shell-pop seti-theme scss-mode sass-mode reverse-theme restart-emacs rebecca-theme ranger rainbow-delimiters railscasts-theme pyvenv pytest pyenv-mode py-isort purple-haze-theme pug-mode professional-theme prettier-js popwin planet-theme pip-requirements phoenix-dark-pink-theme phoenix-dark-mono-theme persp-mode pcre2el paradox ox-reveal ox-gfm orgit organic-green-theme org-projectile org-present org-pomodoro org-mime org-download org-bullets open-junk-file omtose-phellack-theme oldlace-theme occidental-theme obsidian-theme noctilux-theme neotree naquadah-theme mwim mustang-theme multi-term move-text monokai-theme monochrome-theme molokai-theme moe-theme mmm-mode minimal-theme material-theme markdown-toc majapahit-theme magit-gitflow madhat2r-theme macrostep lush-theme lorem-ipsum livid-mode live-py-mode linum-relative link-hint light-soap-theme less-css-mode json-mode js2-refactor js-doc jinja2-mode jbeans-theme jazz-theme iy-go-to-char ir-black-theme inkpot-theme indent-guide hy-mode hungry-delete htmlize hl-todo highlight-parentheses highlight-numbers highlight-indentation heroku-theme hemisu-theme helm-themes helm-swoop helm-spotify-plus helm-pydoc helm-projectile helm-mode-manager helm-make helm-gitignore helm-fuzzy-find helm-flx helm-descbinds helm-css-scss helm-company helm-c-yasnippet helm-ag hc-zenburn-theme gruvbox-theme gruber-darker-theme grandshell-theme gotham-theme google-translate golden-ratio gnuplot gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link git-gutter-fringe git-gutter-fringe+ gh-md gandalf-theme fzf fuzzy flycheck-pos-tip flx-ido flatui-theme flatland-theme fill-column-indicator fasd farmhouse-theme fancy-battery eyebrowse expand-region exotica-theme exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-magit evil-lisp-state evil-indent-plus evil-iedit-state evil-exchange evil-escape evil-ediff evil-args evil-anzu eval-sexp-fu espresso-theme eshell-z eshell-prompt-extras esh-help erc-yt erc-view-log erc-social-graph erc-image erc-hl-nicks emoji-cheat-sheet-plus emmet-mode elisp-slime-nav dumb-jump dracula-theme doom-themes django-theme diminish diff-hl define-word darktooth-theme darkokai-theme darkmine-theme darkburn-theme dakrone-theme dactyl-mode cython-mode cyberpunk-theme counsel company-web company-tern company-statistics company-emoji company-ansible company-anaconda column-enforce-mode color-theme-sanityinc-tomorrow color-theme-sanityinc-solarized color-theme coffee-mode clues-theme clean-aindent-mode cherry-blossom-theme busybee-theme bubbleberry-theme blackboard-theme birds-of-paradise-plus-theme badwolf-theme auto-yasnippet auto-rename-tag auto-highlight-symbol auto-compile atom-one-dark-theme apropospriate-theme anti-zenburn-theme ansible-doc ansible ample-zen-theme ample-theme alect-themes aggressive-indent afternoon-theme adaptive-wrap ace-link ace-jump-helm-line ac-js2 ac-ispell)))
 '(pdf-view-midnight-colors (quote ("#DCDCCC" . "#383838")))
 '(vc-annotate-background "#1c1e1f")
 '(vc-annotate-color-map
   (list
    (cons 20 "#b6e63e")
    (cons 40 "#c4db4e")
    (cons 60 "#d3d15f")
    (cons 80 "#e2c770")
    (cons 100 "#ebb755")
    (cons 120 "#f3a73a")
    (cons 140 "#fd971f")
    (cons 160 "#fc723b")
    (cons 180 "#fb4d57")
    (cons 200 "#fb2874")
    (cons 220 "#f43461")
    (cons 240 "#ed404e")
    (cons 260 "#e74c3c")
    (cons 280 "#c14d41")
    (cons 300 "#9c4f48")
    (cons 320 "#77504e")
    (cons 340 "#555556")
    (cons 360 "#555556")))
 '(vc-annotate-very-old-color nil)
 '(wakatime-python-bin nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(defun dotspacemacs/emacs-custom-settings ()
  "Emacs custom settings.
This is an auto-generated function, do not modify its content directly, use
Emacs customize menu instead.
This function is called at the very end of Spacemacs initialization."
  (custom-set-variables
   ;; custom-set-variables was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   '(all-the-icons-ivy-buffer-commands '(ivy-switch-buffer-other-window ivy-switch-buffer))
   '(ansi-color-names-vector
     ["#1c1e1f" "#e74c3c" "#b6e63e" "#e2c770" "#268bd2" "#fb2874" "#66d9ef" "#d6d6d4"])
   '(aw-leading-char-face ((t (:inherit ace-jump-face-foreground :height 3.0))))
   '(company-quickhelp-color-background "#4F4F4F")
   '(company-quickhelp-color-foreground "#DCDCCC")
   '(custom-safe-themes
     '("dc677c8ebead5c0d6a7ac8a5b109ad57f42e0fe406e4626510e638d36bcc42df" "841b0cf4568ead763f166191e6573645011febc638bb32842f9a626cd8cd446a" "6ebdb33507c7db94b28d7787f802f38ac8d2b8cd08506797b3af6cdfd80632e0" "5a7830712d709a4fc128a7998b7fa963f37e960fd2e8aa75c76f692b36e6cf3c" "1263771faf6967879c3ab8b577c6c31020222ac6d3bac31f331a74275385a452" "65f35d1e0d0858947f854dc898bfd830e832189d5555e875705a939836b53054" "6c092c3dbc29ddb59bce4c485df552bdcc5f729404c1c31e22874145733f2501" "5eb4b22e97ddb2db9ecce7d983fa45eb8367447f151c7e1b033af27820f43760" "a455366c5cdacebd8adaa99d50e37430b0170326e7640a688e9d9ad406e2edfd" "04232a0bfc50eac64c12471607090ecac9d7fd2d79e388f8543d1c5439ed81f5" "1367672034423b1be7c81aa63575f822032185c62b27c13f621813c8d53f495c" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default))
   '(evil-want-Y-yank-to-eol nil)
   '(fci-rule-color "#555556" t)
   '(helm-gtags-auto-update nil)
   '(helm-gtags-direct-helm-completing t)
   '(helm-gtags-display-style 'detail)
   '(helm-gtags-ignore-case t)
   '(helm-gtags-path-style 'root)
   '(helm-gtags-pulse-at-cursor t)
   '(jdee-db-active-breakpoint-face-colors (cons "#1B2229" "#fd971f"))
   '(jdee-db-requested-breakpoint-face-colors (cons "#1B2229" "#b6e63e"))
   '(jdee-db-spec-breakpoint-face-colors (cons "#1B2229" "#525254"))
   '(nrepl-message-colors
     '("#CC9393" "#DFAF8F" "#F0DFAF" "#7F9F7F" "#BFEBBF" "#93E0E3" "#94BFF3" "#DC8CC3"))
   '(objed-cursor-color "#e74c3c")
   '(package-selected-packages
     '(format-all counsel-gtags company-lua lua-mode base16-theme doom-modeline shrink-path mode-icons rjsx-mode emojify forge ghub closql emacsql-sqlite emacsql treepy nord-theme all-the-icons-ivy all-the-icons-dired beacon company-tabnine unicode-escape names polymode json-process-client add-node-modules-path stickyfunc-enhance srefactor emms elisp-format blacken ox-twbs chocolate-theme cobalt helm-dictionary ibuffer-projectile alert log4e spinner ht org-category-capture gntp multiple-cursors hydra parent-mode multi request dash-docs haml-mode gitignore-mode fringe-helper git-gutter+ git-gutter pkg-info epl flx highlight transient with-editor anzu undo-tree all-the-icons memoize magit-popup json-snatcher json-reformat web-completion-data dash-functional tern pos-tip bind-map bind-key autothemer packed pythonic s skewer-mode js2-mode auto-complete popup iedit yasnippet tramp-theme color-theme-modern faff-theme dired-narrow go-guru go-eldoc flycheck-gometalinter company-go go-mode lv auto-package-update pfuture swiper anaconda-mode avy simple-httpd f dash company-quickhelp smooth-scroll xkcd selectric-mode zeal-at-point rebox2 pandoc-mode ox-pandoc helm-dash gmail-message-mode ham-mode html-to-markdown flymd edit-server dockerfile-mode docker tablist docker-tramp deft wakatime-mode zoom sublimity evil-snipe twittering-mode engine-mode rainbow-mode rainbow-identifiers color-identifiers-mode helm-gtags ggtags ng2-mode lsp-mode indium seq treemacs typescript-mode powerline ace-window smartparens evil goto-chg flycheck company helm helm-core markdown-mode projectile magit git-commit async org-plus-contrib ivy babel pretty-symbols pretty-mode typit mmt sudoku pacmacs 2048-game spacemacs-theme zenburn-theme zen-and-art-theme yasnippet-snippets yapfify yaml-mode xterm-color xref-js2 ws-butler winum white-sand-theme which-key web-mode web-beautify volatile-highlights vimrc-mode vi-tilde-fringe uuidgen use-package unfill underwater-theme ujelly-theme twilight-theme twilight-bright-theme twilight-anti-bright-theme try treemacs-projectile treemacs-evil toxi-theme toc-org tide tao-theme tangotango-theme tango-plus-theme tango-2-theme tagedit sunny-day-theme sublime-themes subatomic256-theme subatomic-theme spotify spaceline spacegray-theme soothe-theme solarized-theme soft-stone-theme soft-morning-theme soft-charcoal-theme smyx-theme smeargle slim-mode shell-pop seti-theme scss-mode sass-mode reverse-theme restart-emacs rebecca-theme ranger rainbow-delimiters railscasts-theme pyvenv pytest pyenv-mode py-isort purple-haze-theme pug-mode professional-theme prettier-js popwin planet-theme pip-requirements phoenix-dark-pink-theme phoenix-dark-mono-theme persp-mode pcre2el paradox ox-reveal ox-gfm orgit organic-green-theme org-projectile org-present org-pomodoro org-mime org-download org-bullets open-junk-file omtose-phellack-theme oldlace-theme occidental-theme obsidian-theme noctilux-theme neotree naquadah-theme mwim mustang-theme multi-term move-text monokai-theme monochrome-theme molokai-theme moe-theme mmm-mode minimal-theme material-theme markdown-toc majapahit-theme magit-gitflow madhat2r-theme macrostep lush-theme lorem-ipsum livid-mode live-py-mode linum-relative link-hint light-soap-theme less-css-mode json-mode js2-refactor js-doc jinja2-mode jbeans-theme jazz-theme iy-go-to-char ir-black-theme inkpot-theme indent-guide hy-mode hungry-delete htmlize hl-todo highlight-parentheses highlight-numbers highlight-indentation heroku-theme hemisu-theme helm-themes helm-swoop helm-spotify-plus helm-pydoc helm-projectile helm-mode-manager helm-make helm-gitignore helm-fuzzy-find helm-flx helm-descbinds helm-css-scss helm-company helm-c-yasnippet helm-ag hc-zenburn-theme gruvbox-theme gruber-darker-theme grandshell-theme gotham-theme google-translate golden-ratio gnuplot gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link git-gutter-fringe git-gutter-fringe+ gh-md gandalf-theme fzf fuzzy flycheck-pos-tip flx-ido flatui-theme flatland-theme fill-column-indicator fasd farmhouse-theme fancy-battery eyebrowse expand-region exotica-theme exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-magit evil-lisp-state evil-indent-plus evil-iedit-state evil-exchange evil-escape evil-ediff evil-args evil-anzu eval-sexp-fu espresso-theme eshell-z eshell-prompt-extras esh-help erc-yt erc-view-log erc-social-graph erc-image erc-hl-nicks emoji-cheat-sheet-plus emmet-mode elisp-slime-nav dumb-jump dracula-theme doom-themes django-theme diminish diff-hl define-word darktooth-theme darkokai-theme darkmine-theme darkburn-theme dakrone-theme dactyl-mode cython-mode cyberpunk-theme counsel company-web company-tern company-statistics company-emoji company-ansible company-anaconda column-enforce-mode color-theme-sanityinc-tomorrow color-theme-sanityinc-solarized color-theme coffee-mode clues-theme clean-aindent-mode cherry-blossom-theme busybee-theme bubbleberry-theme blackboard-theme birds-of-paradise-plus-theme badwolf-theme auto-yasnippet auto-rename-tag auto-highlight-symbol auto-compile atom-one-dark-theme apropospriate-theme anti-zenburn-theme ansible-doc ansible ample-zen-theme ample-theme alect-themes aggressive-indent afternoon-theme adaptive-wrap ace-link ace-jump-helm-line ac-js2 ac-ispell))
   '(pdf-view-midnight-colors '("#DCDCCC" . "#383838"))
   '(vc-annotate-background "#1c1e1f")
   '(vc-annotate-color-map
     (list
      (cons 20 "#b6e63e")
      (cons 40 "#c4db4e")
      (cons 60 "#d3d15f")
      (cons 80 "#e2c770")
      (cons 100 "#ebb755")
      (cons 120 "#f3a73a")
      (cons 140 "#fd971f")
      (cons 160 "#fc723b")
      (cons 180 "#fb4d57")
      (cons 200 "#fb2874")
      (cons 220 "#f43461")
      (cons 240 "#ed404e")
      (cons 260 "#e74c3c")
      (cons 280 "#c14d41")
      (cons 300 "#9c4f48")
      (cons 320 "#77504e")
      (cons 340 "#555556")
      (cons 360 "#555556")))
   '(vc-annotate-very-old-color nil)
   '(wakatime-python-bin nil))
  (custom-set-faces
   ;; custom-set-faces was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   )
  )
