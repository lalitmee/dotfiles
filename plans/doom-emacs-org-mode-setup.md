# Feature Implementation Plan: doom-emacs-org-mode-setup

## 📋 Todo Checklist
- [x] ✅ Investigate `second-brain` directory structure.
- [x] ✅ Review existing Doom Emacs configuration.
- [x] ✅ Research Doom Emacs Org mode features using context7.
- [x] ✅ Formulate a plan for `init.el` modifications.
- [x] ✅ Formulate a plan for `config.el` modifications.
- [ ] ⏩ Draft the full implementation plan document.
- [ ] ⏳ Final Review and Testing.

## 🔍 Analysis & Investigation

### Codebase Structure
The user's org-related files are located in `~/Projects/Personal/Github/second-brain`. This directory contains several subdirectories for different types of notes, including `agenda`, `ideas`, `journal`, and `notes`. This structure suggests a need for a customized `org-agenda-files` setting to pull tasks and events from the relevant files.

### Current Architecture
The user's Doom Emacs configuration is split into three main files:
- `doom-emacs/.config/doom/init.el`: This file controls which Doom modules are enabled. The `:lang org` module is already enabled, but without any special flags.
- `doom-emacs/.config/doom/config.el`: This file is for user-specific configurations. It currently sets `org-directory` to `~/org/`, which needs to be updated.
- `doom-emacs/.config/doom/packages.el`: This file is for adding extra packages. It is currently empty.

### Dependencies & Integration Points
The plan will primarily involve modifying the Doom Emacs configuration files. The key integration point is the Doom Emacs module system, which is controlled by `init.el`. The `+pretty`, `+journal`, and `+brain` flags for the `org` module will be the main drivers of the new features.

### Considerations & Challenges
The main challenge will be to correctly configure `org-agenda-files` to match the user's `second-brain` directory structure. The user also mentioned "etc" for features, so the plan will include a few common and useful org-mode settings that were not explicitly requested. The `+brain` flag is powerful and might have its own conventions, so the user should be advised to review its documentation after the initial setup.

## 📝 Implementation Plan

### Prerequisites
- A working Doom Emacs installation.
- The `~/Projects/Personal/Github/second-brain` directory should be present.

### Step-by-Step Implementation
1. **Step 1**: **Enable Org Features in `init.el`**
   - **Files to modify**: `doom-emacs/.config/doom/init.el`
   - **Changes needed**: Add the `+pretty`, `+journal`, and `+brain` flags to the `org` module. The `+pretty` flag will enable `org-bullets` and other visual improvements. The `+journal` and `+brain` flags will provide robust note-taking capabilities.

     ```elisp
     ;; In doom-emacs/.config/doom/init.el
     (doom! :input
            ;; ...
            :lang
            ;; ...
            (org +pretty +journal +brain) ;; Add flags here
            ;; ...
            )
     ```

2. **Step 2**: **Run `doom sync`**
   - After modifying `init.el`, run `doom sync` in the terminal to install the new packages and update the configuration.

3. **Step 3**: **Configure Org Directory and Agenda in `config.el`**
   - **Files to modify**: `doom-emacs/.config/doom/config.el`
   - **Changes needed**:
     - Change the value of `org-directory` to point to the `second-brain` directory.
     - Define `org-agenda-files` to include the relevant files from the `second-brain/agenda` directory.
     - Set up `org-journal-dir` to point to the `second-brain/journal` directory.
     - Configure `org-roam-directory` (part of the `+brain` flag) to use the `second-brain/notes` directory.

     ```elisp
     ;; In doom-emacs/.config/doom/config.el

     ;; Set the org directory
     (setq org-directory"~/Projects/Personal/Github/second-brain")

     ;; Configure org-agenda files
     (after! org
       (setq org-agenda-files (directory-files-recursively org-directory "\.org$"))
       ;; Or, for a more targeted approach:
       ;; (setq org-agenda-files (list (concat org-directory "/agenda/todos.org")
       ;;                              (concat org-directory "/agenda/habits.org"))))
       )

     ;; Configure org-journal
     (after! org-journal
       (setq org-journal-dir (concat org-directory "/journal")))

     ;; Configure org-roam (+brain)
     (after! org-roam
       (setq org-roam-directory (concat org-directory "/notes"))
       (setq org-roam-db-location (concat org-directory "/.org-roam.db")))
     ```
4. **Step 4**: **Add custom org-mode settings in `config.el`**
   - **Files to modify**: `doom-emacs/.config/doom/config.el`
   - **Changes needed**: Add some common org-mode settings for a better experience.

     ```elisp
     ;; In doom-emacs/.config/doom/config.el

     (after! org
       ;; Prettier org-bullets
       (setq org-bullets-bullet-list '("◉" "○" "●" "○" "●"))

       ;; Other useful settings
       (setq org-ellipsis " ▼")
       (setq org-log-done 'time)
       (setq org-hide-leading-stars t)
       (setq org-startup-with-inline-images t)
       (setq org-image-actual-width 300))
     ```
5. **Step 5**: **Reload Emacs**
    - Restart Emacs for all changes to take effect.

### Testing Strategy
- **Verify `org-directory`**: Open Emacs and run `M-x org-directory`. It should open `~/Projects/Personal/Github/second-brain`.
- **Check `org-bullets`**: Open any `.org` file and create a list. The bullets should be styled according to the `org-bullets-bullet-list` setting.
- **Test Org Agenda**: Run `M-x org-agenda` and select `a` for the agenda view. It should show tasks from the files specified in `org-agenda-files`.
- **Test Note-taking (`org-roam`)**: Run `M-x org-roam-node-find` to search for notes in your `second-brain/notes` directory.
- **Test Journaling**: Run `M-x org-journal-new-entry` to create a new journal entry. It should be saved in `second-brain/journal`.

## 🎯 Success Criteria
- The Doom Emacs configuration is successfully updated with the new org-mode settings.
- `org-bullets` are working and styled correctly.
- Org agenda is populated with tasks from the `second-brain` directory.
- Note-taking with `org-roam` is functional and points to the correct directory.
- Journaling with `org-journal` is functional and saves to the correct directory.
- The user is able to use the new org-mode features without errors.