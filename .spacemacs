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
     typescript
     javascript
     react
     python
     vimscript
     markdown
     html
     ansible
     yaml
     emacs-lisp
     (org :variables
          org-enable-github-support t
          org-enable-reveal-js-support t)


     ;; functionalities layers
     (auto-completion :variables
                      auto-completion-return-key-behavior 'complete
                      auto-completion-tab-key-behavior 'cycle
                      auto-completion-complete-with-key-sequence nil
                      auto-completion-complete-with-key-sequence-delay 0.1
                      auto-completion-enable-snippets-in-popup t
                      auto-completion-enable-sort-by-usage t)
     (shell :variables
            shell-default-height 30
            shell-default-position 'bottom
            shell-default-shell 'eshell)
     helm
     gtags
     colors
     search-engine
     evil-snipe
     twitter
     auto-completion
     better-defaults
     git
     zsh
     shell
     fasd
     ranger
     emoji
     erc
     spotify
     tmux
     games
     syntax-checking
     version-control
     (wakatime :variables
               wakatime-api-key  "24ffed3b-d336-43be-80ff-2292eaefa867"
               ;; use the actual wakatime path
               wakatime-cli-path "/usr/local/bin/wakatime")

     ;; appearence
     themes-megapack
     )
   ;; List of additional packages that will be installed without being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages, then consider creating a layer. You can also put the
   ;; configuration in `dotspacemacs/user-config'.
   dotspacemacs-additional-packages '(
                                      prettier-js
                                      treemacs
                                      treemacs-evil
                                      treemacs-projectile
                                      multiple-cursors
                                      iy-go-to-char
                                      yasnippet-snippets
                                      swiper
                                      counsel
                                      color-theme
                                      ox-reveal
                                      htmlize
                                      auto-yasnippet
                                      try
                                      magit
                                      gruvbox-theme
                                      blackboard-theme
                                      atom-one-dark-theme
                                      autothemer
                                      fzf
                                      helm-fuzzy-find
                                      xref-js2
                                      ac-js2
                                      auto-rename-tag
                                      babel
                                      indium
                                      doom-themes
                                      sublimity
                                      )
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
                         ;; monokai
                         ;; solarized-dark
                         ;; material
                         ;; leuven
                         ;; zenburn
                         )
   ;; If non nil the cursor color matches the state color in GUI Emacs.
   dotspacemacs-colorize-cursor-according-to-state t
   ;; Default font, or prioritized list of fonts. `powerline-scale' allows to
   ;; quickly tweak the mode-line size to make separators look not too crappy.
   dotspacemacs-default-font '(
                               "OperatorMono Nerd Font"
                               ;; "Iosevka Type Slab Medium"
                               ;; "Fira Code"
                               ;; "Monaco"
                               ;; "Source Code Pro for Powerline"
                               ;; "Fira Mono for Powerline"
                               ;; "Monofur for Powerline"
                               :size 20
                               :weight bold
                               :width normal
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
   dotspacemacs-helm-resize nil
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
   dotspacemacs-helm-use-fuzzy 'always
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
   dotspacemacs-smart-closing-parenthesis nil
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
   linum-relative-format "%4s \u2502"
   )
  ;; magit fullscreen commit status
  ;;(setq-default git-magit-status-fullscreen t)
  (set-face-italic-p 'italic t)


  )

(defun dotspacemacs/user-config ()
  "Configuration function for user code.
This function is called at the very end of Spacemacs initialization after
layers configuration.
This is the place where most of your configurations should be done. Unless it is
explicitly specified that a variable should be set before a package is loaded,
you should place your code here."

  ;; comment box
  (defun jcs-comment-box (b e)
    "Draw a box comment around the region but arrange for the region
to extend to at least the fill column. Place the point after the
comment box."
    (interactive "r")
    (let ((e (copy-marker e t)))
      (goto-char b)
      (end-of-line)
      (insert-char ?  (- fill-column (current-column)))
      (comment-box b e 1)
      (goto-char e)
      (set-marker e nil)))

  ;; sublimity settings
  (sublimity-mode 1)

  ;; //////////////////////
  ;; colors layer settings
  ;; //////////////////////
  (setq-default dotspacemacs-configuration-layers '(
                                                    (colors :variables colors-colorize-identifiers 'variables)))
  (add-hook 'prog-mode-hook 'rainbow-mode)
  ;; (add-hook 'prog-mode-hook 'rainbow-identifiers-mode)
  (add-hook 'after-init-hook 'global-color-identifiers-mode)

  ;; To make the variables stand out, you can turn off highlighting for all other keywords in supported modes
  (defun myfunc-color-identifiers-mode-hook ()
    (let ((faces '(font-lock-comment-face font-lock-comment-delimiter-face font-lock-constant-face font-lock-type-face font-lock-function-name-face font-lock-variable-name-face font-lock-keyword-face font-lock-string-face font-lock-builtin-face font-lock-preprocessor-face font-lock-warning-face font-lock-doc-face font-lock-negation-char-face font-lock-regexp-grouping-construct font-lock-regexp-grouping-backslash)))
      (dolist (face faces)
        (face-remap-add-relative face '((:foreground "" :weight normal :slant normal)))))
    (face-remap-add-relative 'font-lock-keyword-face '((:weight bold)))
    (face-remap-add-relative 'font-lock-comment-face '((:slant italic)))
    (face-remap-add-relative 'font-lock-builtin-face '((:weight bold)))
    (face-remap-add-relative 'font-lock-preprocessor-face '((:weight bold)))
    (face-remap-add-relative 'font-lock-function-name-face '((:slant italic)))
    (face-remap-add-relative 'font-lock-string-face '((:slant italic)))
    (face-remap-add-relative 'font-lock-constant-face '((:weight bold))))
  ;; (add-hook 'color-identifiers-mode-hook 'myfunc-color-identifiers-mode-hook)
  ;; /////////////////////////////
  ;; colors layer settings end
  ;; /////////////////////////////

  ;; gruvbox theme at the startup
  ;; (load-theme 'gruvbox t)
  ;; (spacemacs/load-theme 'gruvbox)
  (spacemacs/load-theme 'doom-molokai)
  (add-hook 'prog-mode-hook 'company-emoji-init)
  (with-eval-after-load 'emoji-cheat-sheet-plus
    (diminish 'emoji-cheat-sheet-plus-display-mode))
  (defun --set-emoji-font (frame)
    "Adjust the font settings of FRAME so Emacs can display emoji properly."
    (if (eq system-type 'darwin)
        ;; For NS/Cocoa
        (set-fontset-font t 'symbol (font-spec :family "Apple Color Emoji") frame 'prepend)
      ;; For Linux
      (set-fontset-font t 'symbol (font-spec :family "Symbola") frame 'prepend)))

  ;; For when Emacs is started in GUI mode:
  (--set-emoji-font nil)
  ;; Hook for when a frame is created with emacsclient
  ;; see https://www.gnu.org/software/emacs/manual/html_node/elisp/Creating-Frames.html
  (add-hook 'after-make-frame-functions '--set-emoji-font)
  ;; modeline configurations
  ;; display battery in modeline
  ;; display time in modeline
  (spaceline-define-segment datetime
    (shell-command-to-string "echo -n $(date '+%a %d %b %I:%M%p')"))
  (spaceline-spacemacs-theme 'datetime)
  (spaceline-toggle-buffer-size-off)
  ;; total number of lines in a buffer

  ;; page brake lines in prog-mode
  (add-hook 'prog-mode-hook 'page-break-lines-mode)
  (add-hook 'prog-mode-hook 'column-enforce-mode)

  (setq paradox-github-token "522a037a14fea9c1ec1f2c00f40c087d7ed79c9d")

  avy-all-windows 'all-frames

  ;; Wraps long lines in text mode
  (add-hook 'text-mode-hook 'auto-fill-mode)
  (add-hook 'org-mode-hook 'auto-fill-mode)
  (add-hook 'org-mode-hook 'org-indent-mode)

  ;; default powerline separator
  (setq powerline-default-separator 'arrow)
  ;; mappings of leader keys
  (spacemacs/set-leader-keys "," 'save-buffer)
  (spacemacs/set-leader-keys "j" 'spacemacs/indent-region-or-buffer)

  ;; mappings of evil-go-to-char
  (spacemacs/set-leader-keys "C-c" 'evil-avy-goto-char)
  (spacemacs/set-leader-keys "C-'" 'evil-avy-goto-char-2)
  (spacemacs/set-leader-keys "C-w" 'evil-avy-goto-word-1)
  (spacemacs/set-leader-keys "C-l" 'evil-avy-goto-line)

  ;; multiple cursor modes
  (spacemacs/set-leader-keys "E" 'mc/edit-lines)
  (spacemacs/set-leader-keys "N L" 'mc/mark-next-like-this)
  (spacemacs/set-leader-keys "P L" 'mc/mark-previous-like-this)
  (spacemacs/set-leader-keys "A L" 'mc/mark-all-like-this)

  ;; Tide mappings for Typescript
  (spacemacs/set-leader-keys "g d" 'tide-jump-to-definition)
  (spacemacs/set-leader-keys "o i" 'tide-organize-imports)


  ;; /////////////////////////////////
  ;; React configurations
  ;; to have a consistent 2 spaces indenting both on js and jsx
  ;; /////////////////////////////////

  ;; from this link: https://gist.github.com/asummers/b8304b8ea78fc331b8177ff35d002046
  (use-package web-mode
    :ensure t
    :defer t
    :mode (("\\.ios\\.js$" . react-mode)
           ("\\.android\\.js$" . react-mode)
           ("\\.react\\.js$" . react-mode)
           ("\\.js$" . react-mode))
    :config
    (add-to-list 'magic-mode-alist '("^import React" . react-mode))
    (add-to-list 'magic-mode-alist '("React.Component" . react-mode))
    (add-to-list 'magic-mode-alist '("from 'react';$" . react-mode))
    (add-to-list 'web-mode-indentation-params '("lineup-calls" . nil))

    (with-eval-after-load 'flycheck
      (flycheck-add-mode 'javascript-eslint 'react-mode))

    (add-hook 'web-mode-hook
              (lambda ()
                (if (equal web-mode-content-type "javascript")
                    (web-mode-set-content-type "jsx"))))
    (setq-local web-mode-enable-auto-quoting nil)

    (setq-default js-indent-level 2)

    (add-hook 'web-mode-hook
              (lambda ()
                (setq web-mode-markup-indent-offset (symbol-value 'js-indent-level))
                (setq web-mode-attr-indent-offset (symbol-value 'js-indent-level))
                (setq web-mode-css-indent-offset (symbol-value 'js-indent-level))
                (setq web-mode-code-indent-offset (symbol-value 'js-indent-level)))))


  (add-to-list 'auto-mode-alist '("\\.js\\'" . react-mode))
  (add-to-list 'auto-mode-alist '("\\.jsx\\'" . react-mode))
  (setq js2-basic-offset 2)
  (setq js-indent-level 2)

  (use-package web-mode
    :config
    (defun my-web-mode-hook ()
      "Hooks for Web mode. Adjust indents"
      (setq web-mode-markup-indent-offset 2)
      (setq web-mode-attr-indent-offset 2)
      (setq web-mode-css-indent-offset 2)
      (setq web-mode-code-indent-offset 2)
      (setq-default css-indent-offset 2))
    (add-to-list 'auto-mode-alist '("\\.cshtml\\'" . web-mode))
    (add-hook 'web-mode-hook  'my-web-mode-hook))

  (defun my/use-eslint-from-node-modules ()
    "Gets eslint exe from local path."
    (let (eslint)
      (setq eslint (projectile-expand-root "node_modules/eslint/bin/eslint.js"))
      (setq-default flycheck-javascript-eslint-executable eslint)))

  ;; disabling jshint for javascript files
  (setq-default flycheck-disabled-checker 'javascript-jshint)
  (setq-default flycheck-disabled-checker 'json-jsonlist)
  (add-hook 'js2-mode-hook #'my/use-eslint-from-node-modules)
  (flycheck-add-mode 'javascript-eslint 'web-mode)

  ;; iy-go-to-char
  (require 'iy-go-to-char)
  (global-set-key (kbd "C-c f") 'iy-go-to-char)
  (global-set-key (kbd "C-c F") 'iy-go-to-char-backward)
  (global-set-key (kbd "C-c ;") 'iy-go-to-or-up-to-continue)
  (global-set-key (kbd "C-c ,") 'iy-go-to-or-up-to-continue-backward)

  ;; keybinding for fuzzy finding files by fzf
  (spacemacs/set-leader-keys "ff" 'fzf)

  ;; magit autocomplete
  (setq magit-repository-directories '("~/repos/"))
  (global-git-commit-mode t)

  ;; ace-window configurations
  (use-package ace-window
    :init
    (progn
      (global-set-key [remap other-window] 'ace-window)
      (custom-set-variables
       '(aw-leading-char-face
         ((t (:inherit ace-jump-face-foreground :height 3.0)))))
      ))


  ;; pdf.js and reveal.js settings
  (require 'ox-reveal)
  (use-package ox-reveal
    :ensure ox-reveal)
  (setq org-reveal-root "http://cdn.jsdelivr.net/reveal.js/3.0.0/")
  (setq org-reveal-mathjax t)

  ;; counsel for swiper file search
  (use-package counsel
    :defer t)

  ;; swiper for word search : its awesome
  (use-package swiper
    :config
    (progn
      (ivy-mode 1)
      (setq ivy-use-virtual-buffers t)
      (setq enable-recursive-minibuffers t)
      (global-set-key "\C-s" 'swiper)
      (global-set-key (kbd "C-c C-r") 'ivy-resume)
      (global-set-key (kbd "<f6>") 'ivy-resume)
      (global-set-key (kbd "M-x") 'counsel-M-x)
      (global-set-key (kbd "C-x C-f") 'counsel-find-file)
      (global-set-key (kbd "<f1> f") 'counsel-describe-function)
      (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
      (global-set-key (kbd "<f1> l") 'counsel-find-library)
      (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
      (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
      (global-set-key (kbd "C-c g") 'counsel-git)
      (global-set-key (kbd "C-c j") 'counsel-git-grep)
      (global-set-key (kbd "C-c k") 'counsel-ag)
      (global-set-key (kbd "C-x l") 'counsel-locate)
      (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
      (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)
      ))

  (require 'ox-latex)
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

  (use-package treemacs
    :defer t)

  (use-package treemacs-evil
    :defer t)

  (use-package treemacs-projectile
    :defer t)

  ;; Emacs as JavaScript IDE
  (require 'js2-mode)
  (add-hook 'js-mode-hook 'js2-minor-mode)
  ;; (add-hook 'js2-mode-hook 'ac-js2-mode)

  ;; hook for yaml files
  (add-hook 'yaml-mode-hook 'prettier-js-mode)

  (require 'js2-refactor)
  (require 'xref-js2)

  (add-hook 'js2-mode-hook #'js2-refactor-mode)
  (js2r-add-keybindings-with-prefix "C-c C-r")
  (define-key js2-mode-map (kbd "C-k") #'js2r-kill)

  ;; js-mode (which js2 is based on) binds "M-." which conflicts with xref, so
  ;; unbind it.
  (define-key js-mode-map (kbd "M-.") nil)

  (add-hook 'js2-mode-hook (lambda ()
                             (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t)))

  (require 'company)
  (require 'company-tern)

  (add-to-list 'company-backends 'company-tern)
  (add-hook 'js2-mode-hook (lambda ()
                             (tern-mode)
                             (company-mode)))

  ;; Disable completion keybindings, as we use xref-js2 instead
  (define-key tern-mode-keymap (kbd "M-.") nil)
  (define-key tern-mode-keymap (kbd "M-,") nil)

  ;; Emacs as Typescript IDE
  (defun setup-tide-mode ()
    (interactive)
    (tide-setup)
    (flycheck-mode +1)
    (setq flycheck-check-syntax-automatically '(save mode-enabled))
    (eldoc-mode +1)
    (tide-hl-identifier-mode +1)
    ;; company is an optional dependency. You have to
    ;; install it separately via package-install
    ;; `M-x package-install [ret] company`
    (company-mode +1))

  ;; aligns annotation to the right hand side
  (setq company-tooltip-align-annotations t)

  ;; (setq tide-tsserver-executable "/usr/local/lib/node_modules/typescript/bin/tsserver")
  ;; formats the buffer before saving
  (add-hook 'before-save-hook 'tide-organize-imports)
  ;; (add-hook 'before-save-hook 'tide-format-before-save)
  (setq tide-format-options '(:placeOpenBraceOnNewLineForFunctions nil
                                                                   :indentSize 2
                                                                   :tabSize 2
                                                                   :insertSpaceBeforeAndAfterBinaryOperators t
                                                                   :insertSpaceAfterKeywordsInControlFlowStatements t))

  (add-hook 'typescript-mode-hook #'setup-tide-mode)
  (add-hook 'html-mode-hook #'setup-tide-mode)

  ;; web mode settings
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (add-hook 'js2-mode-hook 'prettier-js-mode)
  (add-hook 'web-mode-hook 'prettier-js-mode)
  (add-hook 'js-mode-hook 'prettier-js-mode)
  (add-hook 'typescript-mode-hook 'prettier-js-mode)
  (add-hook 'css-mode-hook 'prettier-js-mode)
  (add-hook 'scss-mode-hook 'prettier-js-mode)
  (add-hook 'html-mode-hook 'prettier-js-mode)
  (add-hook 'web-mode-hook 'auto-rename-tag-mode)
  (flycheck-add-mode 'javascript-eslint 'web-mode)
  (add-hook 'markdown-mode-hook 'prettier-js-mode)

  ;; yasnippet mode for files
  (add-hook 'web-mode-hook 'prettier-js-mode)

  (setq-default agressive-indent-mode t)

  (global-hungry-delete-mode)

  ;; Prettier installation
  (setq prettier-js-args '(
                           "--trailing-comma" "none"
                           "--print-width 80"
                           "--tab-width 2"
                           "--single-quote" "true"
                           "--html-whitespace-sensitivity" "ignore"
                           ))

  (defun enable-minor-mode (my-pair)
    "Enable minor mode if filename match the regexp.  MY-PAIR is a cons cell (regexp . minor-mode)."
    (if (buffer-file-name)
        (if (string-match (car my-pair) buffer-file-name)
            (funcall (cdr my-pair)))))

  (add-hook 'web-mode-hook #'(lambda ()
                               (enable-minor-mode
                                '("\\.jsx?\\'" . prettier-js-mode))))

  ;; (add-hook 'web-mode-hook #'(lambda ()
  ;;                              (enable-minor-mode
  ;;                               '("\\.jsx?\\'", "\\.ts?\\'" . prettier-js-mode))))

  (add-hook 'web-mode-hook
            (lambda ()
              (if (equal web-mode-content-type "javascript")
                  (web-mode-set-content-type "jsx")
                (message "now set to: %s" web-mode-content-type))))
  ;; from this post => https://www.cha1tanya.com/2015/06/20/configuring-web-mode-with-jsx.html
  (setq web-mode-content-types-alist
        '(("jsx" . "\\.js[x]?\\'")))
  (add-hook 'react-mode-hook 'prettier-js-mode)
  (use-package treemacs
    :defer t
    :init
    (with-eval-after-load 'winum
      (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
    :config
    (progn
      (use-package treemacs-evil
        :ensure t
        :demand t)
      (setq treemacs-change-root-without-asking nil
            treemacs-collapse-dirs              (if (executable-find "python") 3 0)
            treemacs-file-event-delay           5000
            treemacs-follow-after-init          t
            treemacs-follow-recenter-distance   0.1
            treemacs-goto-tag-strategy          'refetch-index
            treemacs-indentation                2
            treemacs-indentation-string         " "
            treemacs-is-never-other-window      nil
            treemacs-never-persist              nil
            treemacs-no-png-images              nil
            treemacs-recenter-after-file-follow nil
            treemacs-recenter-after-tag-follow  nil
            treemacs-show-hidden-files          t
            treemacs-silent-filewatch           nil
            treemacs-silent-refresh             nil
            treemacs-sorting                    'alphabetic-desc
            treemacs-tag-follow-cleanup         t
            treemacs-tag-follow-delay           1.5
            treemacs-width                      35)

      (treemacs-follow-mode t)
      (treemacs-filewatch-mode t)
      (pcase (cons (not (null (executable-find "git")))
                   (not (null (executable-find "python3"))))
        (`(t . t)
         (treemacs-git-mode 'extended))
        (`(t . _)
         (treemacs-git-mode 'simple))))
    :bind
    (:map global-map
          ("C-i"         . treemacs-toggle)
          ("M-0"        . treemacs-select-window)
          ("C-c 1"      . treemacs-delete-other-windows)
          ("M-m ft"     . treemacs-toggle)
          ("M-m fT"     . treemacs)
          ("M-m fB"     . treemacs-bookmark)
          ("M-m f C-t"  . treemacs-find-file)
          ("M-m f M-t"  . treemacs-find-tag)))

  ;; mapping the evil command in proced buffer
  ;; (with-eval-after-load 'proced
  ;;   (spacemacs/evilify-map proced-mode-map
  ;;                          :mode proced-mode))

  (use-package treemacs-projectile
    :defer t
    :ensure t
    :config
    (setq treemacs-header-function #'treemacs-projectile-create-header)
    :bind (:map global-map
                ("M-m fP" . treemacs-projectile)
                ("M-m fp" . treemacs-projectile-toggle)))
  )

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(aw-leading-char-face ((t (:inherit ace-jump-face-foreground :height 3.0))))
 '(custom-safe-themes
   (quote
    ("bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default)))
 '(evil-want-Y-yank-to-eol nil)
 '(package-selected-packages
   (quote
    (zoom sublimity evil-snipe twittering-mode engine-mode rainbow-mode rainbow-identifiers color-identifiers-mode helm-gtags ggtags ng2-mode lsp-mode indium seq treemacs typescript-mode powerline ace-window smartparens evil goto-chg flycheck company helm helm-core markdown-mode projectile magit git-commit async org-plus-contrib ivy babel pretty-symbols pretty-mode typit mmt sudoku pacmacs 2048-game spacemacs-theme zenburn-theme zen-and-art-theme yasnippet-snippets yapfify yaml-mode xterm-color xref-js2 ws-butler winum white-sand-theme which-key web-mode web-beautify volatile-highlights vimrc-mode vi-tilde-fringe uuidgen use-package unfill underwater-theme ujelly-theme twilight-theme twilight-bright-theme twilight-anti-bright-theme try treemacs-projectile treemacs-evil toxi-theme toc-org tide tao-theme tangotango-theme tango-plus-theme tango-2-theme tagedit sunny-day-theme sublime-themes subatomic256-theme subatomic-theme spotify spaceline spacegray-theme soothe-theme solarized-theme soft-stone-theme soft-morning-theme soft-charcoal-theme smyx-theme smeargle slim-mode shell-pop seti-theme scss-mode sass-mode reverse-theme restart-emacs rebecca-theme ranger rainbow-delimiters railscasts-theme pyvenv pytest pyenv-mode py-isort purple-haze-theme pug-mode professional-theme prettier-js popwin planet-theme pip-requirements phoenix-dark-pink-theme phoenix-dark-mono-theme persp-mode pcre2el paradox ox-reveal ox-gfm orgit organic-green-theme org-projectile org-present org-pomodoro org-mime org-download org-bullets open-junk-file omtose-phellack-theme oldlace-theme occidental-theme obsidian-theme noctilux-theme neotree naquadah-theme mwim mustang-theme multi-term move-text monokai-theme monochrome-theme molokai-theme moe-theme mmm-mode minimal-theme material-theme markdown-toc majapahit-theme magit-gitflow madhat2r-theme macrostep lush-theme lorem-ipsum livid-mode live-py-mode linum-relative link-hint light-soap-theme less-css-mode json-mode js2-refactor js-doc jinja2-mode jbeans-theme jazz-theme iy-go-to-char ir-black-theme inkpot-theme indent-guide hy-mode hungry-delete htmlize hl-todo highlight-parentheses highlight-numbers highlight-indentation heroku-theme hemisu-theme helm-themes helm-swoop helm-spotify-plus helm-pydoc helm-projectile helm-mode-manager helm-make helm-gitignore helm-fuzzy-find helm-flx helm-descbinds helm-css-scss helm-company helm-c-yasnippet helm-ag hc-zenburn-theme gruvbox-theme gruber-darker-theme grandshell-theme gotham-theme google-translate golden-ratio gnuplot gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link git-gutter-fringe git-gutter-fringe+ gh-md gandalf-theme fzf fuzzy flycheck-pos-tip flx-ido flatui-theme flatland-theme fill-column-indicator fasd farmhouse-theme fancy-battery eyebrowse expand-region exotica-theme exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-magit evil-lisp-state evil-indent-plus evil-iedit-state evil-exchange evil-escape evil-ediff evil-args evil-anzu eval-sexp-fu espresso-theme eshell-z eshell-prompt-extras esh-help erc-yt erc-view-log erc-social-graph erc-image erc-hl-nicks emoji-cheat-sheet-plus emmet-mode elisp-slime-nav dumb-jump dracula-theme doom-themes django-theme diminish diff-hl define-word darktooth-theme darkokai-theme darkmine-theme darkburn-theme dakrone-theme dactyl-mode cython-mode cyberpunk-theme counsel company-web company-tern company-statistics company-emoji company-ansible company-anaconda column-enforce-mode color-theme-sanityinc-tomorrow color-theme-sanityinc-solarized color-theme coffee-mode clues-theme clean-aindent-mode cherry-blossom-theme busybee-theme bubbleberry-theme blackboard-theme birds-of-paradise-plus-theme badwolf-theme auto-yasnippet auto-rename-tag auto-highlight-symbol auto-compile atom-one-dark-theme apropospriate-theme anti-zenburn-theme ansible-doc ansible ample-zen-theme ample-theme alect-themes aggressive-indent afternoon-theme adaptive-wrap ace-link ace-jump-helm-line ac-js2 ac-ispell))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-comment-face ((t (:foreground "#555556" :slant normal)))))
