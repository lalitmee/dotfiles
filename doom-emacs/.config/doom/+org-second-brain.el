;;; +org-second-brain.el -*- lexical-binding: t; -*-
;;; Dual second-brain (Personal + Work): curated agenda, capture, refile, roam.
;;;
;;; Leader: SPC n <`my/org-second-brain-leader-key'> (default \"B\") — change only
;;; `my/org-second-brain-leader-key' to retarget all bindings.
;;;   a merged agenda   w work agenda   p personal agenda
;;;   c capture (brain prompt)   W work capture   P personal capture
;;;   r roam (work)   R roam (personal)   g refresh `org-agenda-files'
;;;
;;; Capture template key: b → Inbox (uses `notes/inbox.org' or fallbacks).

(require 'cl-lib)
(require 'seq)

(defvar my/org-second-brain-personal-root
  (expand-file-name "~/Projects/Personal/Github/second-brain")
  "Absolute path to the personal second-brain repo.")

(defvar my/org-second-brain-work-root
  (expand-file-name "~/Projects/Work/Github/second-brain")
  "Absolute path to the work second-brain repo.")

(defvar my/org-second-brain-leader-key "B"
  "Second key under `SPC n …` for the second-brain map. Change only this string to retarget every binding.")

(defvar my/org-second-brain-curated-subdirs
  '("daily" "brain" "sandbox" "meta" "journal")
  "Subdirectories (under each brain root) scanned for .org agenda/refile files.")

(defvar my/org-capture-active-brain :personal
  "Which brain capture targets use: `:personal' or `:work'.")

(defun my/org-second-brain--root-p (path root)
  (let ((path (file-truename path))
        (root (file-truename (expand-file-name root))))
    (or (string-equal path root)
        (string-prefix-p (file-name-as-directory root) path))))

(defun my/org-second-brain--root-for (brain)
  (pcase brain
    (:personal my/org-second-brain-personal-root)
    (:work my/org-second-brain-work-root)
    (_ (error "Unknown brain: %S" brain))))

(defun my/org-second-brain-for-file (file)
  "Return `:personal', `:work', or nil if FILE is not under either brain."
  (when file
    (let ((file (file-truename file)))
      (cond ((my/org-second-brain--root-p file my/org-second-brain-personal-root) :personal)
            ((my/org-second-brain--root-p file my/org-second-brain-work-root) :work)
            (t nil)))))

(defun my/org-second-brain-context-file ()
  "File that defines refile/capture context (agenda line or current buffer)."
  (if (derived-mode-p 'org-agenda-mode)
      (let ((m (or (get-text-property (point) 'org-marker)
                   (get-text-property (point) 'org-hd-marker))))
        (when (markerp m)
          (with-current-buffer (marker-buffer m)
            (buffer-file-name))))
    (buffer-file-name)))

(defun my/org-second-brain--curated-org-files (root)
  "Collect .org files under curated subdirs of ROOT plus optional root hub files."
  (let ((root (file-truename (expand-file-name root)))
        (files ()))
    (dolist (sub my/org-second-brain-curated-subdirs)
      (let ((dir (expand-file-name sub root)))
        (when (file-directory-p dir)
          (setq files (append files (directory-files-recursively dir "\\.org\\'" nil))))))
    (dolist (leaf '("README.org" "inbox.org"))
      (let ((f (expand-file-name leaf root)))
        (when (file-exists-p f)
          (push f files))))
    (seq-uniq (delq nil (delete-dups files)))))

(defun my/org-second-brain-agenda-files (&optional which)
  "Curated org file list for `:personal', `:work', or `:both' (union)."
  (pcase (or which :both)
    (:personal (my/org-second-brain--curated-org-files my/org-second-brain-personal-root))
    (:work (my/org-second-brain--curated-org-files my/org-second-brain-work-root))
    (:both (seq-uniq (append (my/org-second-brain--curated-org-files my/org-second-brain-personal-root)
                            (my/org-second-brain--curated-org-files my/org-second-brain-work-root))))))

(defun my/org-second-brain-set-global-agenda-files ()
  "Refresh `org-agenda-files' to the merged curated list."
  (interactive)
  (setq org-agenda-files (my/org-second-brain-agenda-files :both)))

(defun my/org-second-brain-agenda-with-scope (which)
  (let ((org-agenda-files (my/org-second-brain-agenda-files which)))
    (org-agenda nil "a")))

(defun my/org-second-brain-agenda-merged ()
  (interactive)
  (my/org-second-brain-agenda-with-scope :both))

(defun my/org-second-brain-agenda-work ()
  (interactive)
  (my/org-second-brain-agenda-with-scope :work))

(defun my/org-second-brain-agenda-personal ()
  (interactive)
  (my/org-second-brain-agenda-with-scope :personal))

(defun my/org-second-brain-inbox-file-for-brain (brain)
  (let ((root (my/org-second-brain--root-for brain)))
    (or (cl-some (lambda (rel)
                   (let ((p (expand-file-name rel root)))
                     (when (file-exists-p p) p)))
                 '("brain/notes/system/inbox.org" "notes/inbox.org" "sandbox/ideas/inbox.org" "ideas/inbox.org" "inbox.org"))
        (expand-file-name "brain/notes/system/inbox.org" root))))

(defun my/org-second-brain-capture-inbox-file ()
  (my/org-second-brain-inbox-file-for-brain my/org-capture-active-brain))

(defun my/org-second-brain-capture-generic ()
  (interactive)
  (setq my/org-capture-active-brain
        (pcase (completing-read "Brain: " '("personal" "work") nil t)
          ("personal" :personal)
          ("work" :work)))
  (org-capture nil "b"))

(defun my/org-second-brain-capture-work ()
  (interactive)
  (let ((my/org-capture-active-brain :work))
    (org-capture nil "b")))

(defun my/org-second-brain-capture-personal ()
  (interactive)
  (let ((my/org-capture-active-brain :personal))
    (org-capture nil "b")))

(defun my/org-second-brain-roam-node-find-work ()
  (interactive)
  (let ((org-roam-directory (expand-file-name "notes" my/org-second-brain-work-root))
        (org-roam-db-location (expand-file-name ".org-roam.db" my/org-second-brain-work-root)))
    (org-roam-node-find)))

(defun my/org-second-brain-roam-node-find-personal ()
  (interactive)
  (let ((org-roam-directory (expand-file-name "brain/notes" my/org-second-brain-personal-root))
        (org-roam-db-location (expand-file-name ".org-roam.db" my/org-second-brain-personal-root)))
    (org-roam-node-find)))

(defun my/org-second-brain-around-org-refile-get-targets (orig-fn &optional default-buffer)
  (let ((targets (funcall orig-fn default-buffer))
        (brain (my/org-second-brain-for-file (my/org-second-brain-context-file))))
    (if (not brain)
        targets
      (let ((root (file-truename (my/org-second-brain--root-for brain))))
        (seq-filter
         (lambda (elt)
           (and (consp elt)
                (stringp (nth 1 elt))
                (let ((f (file-truename (expand-file-name (nth 1 elt)))))
                  (string-prefix-p (file-name-as-directory root) f))))
         targets)))))

(defun my/org-align-tables-on-save ()
  "Align all tables in the buffer if in Org mode."
  (when (and (derived-mode-p 'org-mode)
             (not buffer-read-only))
    (org-table-map-tables #'org-table-align)))

(defun my/org-setup-save-hook ()
  "Set up buffer-local save hooks for Org mode."
  (add-hook 'before-save-hook #'my/org-align-tables-on-save nil t))

(after! org
  (require 'org-table)
  (setq org-modern-star 'replace)
  (setq org-modern-replace-stars '("◉" "○" "✸" "✿" "✤" "✜" "✦" "◈" "◇"))
  (setq org-modern-cycle-stars t)
  (setq org-ellipsis " ")
  (setq org-log-done 'time)
  (setq org-hide-leading-stars t)
  (setq org-startup-with-inline-images t)
  (setq org-image-actual-width 300)

  ;; TODO keywords — streamlined 5-state pipeline
  (setq org-todo-keywords
        '((sequence "BACKLOG(b)" "TODO(t)" "IN-PROGRESS(p)" "|" "DONE(d)" "CANCELLED(c)")))
  (setq org-todo-keyword-faces
        '(("BACKLOG"     . (:foreground "#a8a8a8"))
          ("TODO"        . (:foreground "#0088ff" :weight bold))
          ("IN-PROGRESS" . (:foreground "#ffd700" :weight bold))
          ("DONE"        . (:foreground "#5fff5f" :weight bold))
          ("CANCELLED"   . (:foreground "#585858" :weight bold))))

  ;; Agenda — 14-day span starting Monday
  (setq org-agenda-span 14)
  (setq org-agenda-start-on-weekday 1)

  ;; Custom agenda commands — matching nvim workflow
  (setq org-agenda-custom-commands
        `(("A" "📅 Agenda & All Tasks (Global)"
           ((agenda "")
            (alltodo "")))
          ("w" "💼 Work Focus"
           ((agenda "" ((org-agenda-files ',(my/org-second-brain-agenda-files :work))))
            (alltodo "" ((org-agenda-files ',(my/org-second-brain-agenda-files :work))))))
          ("p" "🏠 Personal Focus"
           ((agenda "" ((org-agenda-files ',(my/org-second-brain-agenda-files :personal))))
            (alltodo "" ((org-agenda-files ',(my/org-second-brain-agenda-files :personal))))))
          ("T" "📋 Triage / Backlog"
           ((todo "BACKLOG")))))

  ;; Tag faces — cobalt2 palette, only auto-applied tags
  (setq org-tag-faces
        '(("IDEA"        . (:foreground "#ffc600" :weight bold))
          ("RAW"         . (:foreground "#af87ff" :slant italic))
          ("PROJECT"     . (:foreground "#ffc600"))
          ("APPLICATION" . (:foreground "#ffc600"))
          ("TASK"        . (:foreground "#0088ff"))
          ("NOTE"        . (:foreground "#9effff" :slant italic))
          ("HABIT"       . (:foreground "#ff9d00"))
          ("WORK"        . (:foreground "#a5ff90"))
          ("NEOVIM"      . (:foreground "#a5ff90" :weight bold))))

  (my/org-second-brain-set-global-agenda-files)
  (setq org-refile-targets '((org-agenda-files . (:maxlevel . 9))))
  (unless (advice-member-p #'my/org-second-brain-around-org-refile-get-targets 'org-refile-get-targets)
    (advice-add 'org-refile-get-targets :around #'my/org-second-brain-around-org-refile-get-targets))
  (setq org-capture-templates
        `(;; Ideas
          ("i" "💡 Idea")
          ("ii" "💡 Raw Idea" entry
           (file ,(expand-file-name "sandbox/ideas/inbox.org" my/org-second-brain-personal-root))
           "* %? :IDEA:RAW:" :empty-lines-before 1)
          ("ip" "🚀 Project" entry
           (file ,(expand-file-name "sandbox/ideas/project.org" my/org-second-brain-personal-root))
           "* %? :IDEA:PROJECT:" :empty-lines-before 1)
          ("ia" "💻 Application" entry
           (file ,(expand-file-name "sandbox/ideas/application.org" my/org-second-brain-personal-root))
           "* %? :IDEA:APPLICATION:" :empty-lines-before 1)
          ("in" "💤 Neovim" entry
           (file ,(expand-file-name "sandbox/ideas/neovim.org" my/org-second-brain-personal-root))
           "* %? :IDEA:NEOVIM:" :empty-lines-before 1)
          ("iw" "💼 Work" entry
           (file ,(expand-file-name "ideas/inbox.org" my/org-second-brain-work-root))
           "* %? :IDEA:WORK:" :empty-lines-before 1)

          ;; Tasks
          ("t" "📋 Task")
          ("tp" "🏠 Personal" entry
           (file ,(expand-file-name "daily/agenda/todos.org" my/org-second-brain-personal-root))
           "* TODO %? :TASK:\n  SCHEDULED: %U DEADLINE: %t" :empty-lines-before 1)
          ("tn" "💤 Neovim" entry
           (file ,(expand-file-name "daily/agenda/todos.org" my/org-second-brain-personal-root))
           "* TODO %? :NEOVIM:TASK:\n  SCHEDULED: %U DEADLINE: %t" :empty-lines-before 1)
          ("tw" "💼 Work" entry
           (file ,(expand-file-name "agenda/todos.org" my/org-second-brain-work-root))
           "* TODO %? :TASK:WORK:\n  SCHEDULED: %U DEADLINE: %t" :empty-lines-before 1)

          ;; Notes
          ("n" "📓 Note")
          ("np" "🏠 Personal" entry
           (file ,(expand-file-name "brain/notes/system/inbox.org" my/org-second-brain-personal-root))
           "* %^{Title} :NOTE:\n  %U\n\n%?" :empty-lines-before 1)
          ("nw" "💼 Work" entry
           (file ,(expand-file-name "notes/inbox.org" my/org-second-brain-work-root))
           "* %^{Title} :NOTE:WORK:\n  %U\n\n%?" :empty-lines-before 1)

          ;; Journal
          ("j" "📝 Journal")
          ("jp" "🏠 Personal" entry
           (file+olp+datetree ,(expand-file-name "daily/journal/inbox.org" my/org-second-brain-personal-root))
           "**** [%<%I:%M %p>] %?" :tree-type day)
          ("jw" "💼 Work" entry
           (file+olp+datetree ,(expand-file-name "journal/inbox.org" my/org-second-brain-work-root))
           "**** [%<%I:%M %p>] %? :WORK:" :tree-type day)

          ;; Habits
          ("h" "⚡ Habit")
          ("hp" "🏠 Personal" entry
           (file ,(expand-file-name "daily/agenda/habits.org" my/org-second-brain-personal-root))
           "* TODO %? :HABIT:\n  SCHEDULED: %t\n  :PROPERTIES:\n  :STYLE: habit\n  :REPEAT_TO_STATE: TODO\n  :END:" :empty-lines-before 1)
          ("hw" "💼 Work" entry
           (file ,(expand-file-name "agenda/habits.org" my/org-second-brain-work-root))
           "* TODO %? :HABIT:WORK:\n  SCHEDULED: %t\n  :PROPERTIES:\n  :STYLE: habit\n  :REPEAT_TO_STATE: TODO\n  :END:" :empty-lines-before 1)

          ;; Quick inbox — used by SPC n B c/W/P shortcuts
          ("b" "📥 Inbox (second-brain)" entry
           (file my/org-second-brain-capture-inbox-file)
           "* %?\n%U\n" :empty-lines-before 1)))
  (setq org-startup-indented t)
  (setq org-src-tab-acts-natively t)
  (setq org-src-preserve-indentation nil)
  (add-hook 'org-mode-hook #'my/org-setup-save-hook))

(after! org-journal
  (setq org-journal-dir (expand-file-name "journal" org-directory))
  (setq org-journal-file-format "%Y/%m/%d.org"))

(after! org-roam
  (setq org-roam-directory (expand-file-name "notes" org-directory))
  (setq org-roam-db-location (expand-file-name ".org-roam.db" org-directory)))

(eval
 `(map! :leader
        :prefix ("n" ,my/org-second-brain-leader-key)
        :desc "Agenda (merged second-brain)" "a" #'my/org-second-brain-agenda-merged
        :desc "Agenda (work second-brain)" "w" #'my/org-second-brain-agenda-work
        :desc "Agenda (personal second-brain)" "p" #'my/org-second-brain-agenda-personal
        :desc "Capture (pick brain)" "c" #'my/org-second-brain-capture-generic
        :desc "Capture (work)" "W" #'my/org-second-brain-capture-work
        :desc "Capture (personal)" "P" #'my/org-second-brain-capture-personal
        :desc "Roam find (work)" "r" #'my/org-second-brain-roam-node-find-work
        :desc "Roam find (personal)" "R" #'my/org-second-brain-roam-node-find-personal
        :desc "Refresh org-agenda-files" "g" #'my/org-second-brain-set-global-agenda-files))
