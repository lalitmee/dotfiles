# Feature Implementation Plan: Documentation Cleanup

## 📋 Todo Checklist
- [x] ✅ Update `CONTEXT.md` with a more explicit note about the help table directory.
- [x] ✅ Final Review.

## 🔍 Analysis & Investigation

### Root Cause of the Issue
- The previous implementation created the help table in the wrong directory (`.../help/table/` instead of `.../help/tables/`).
- The existing documentation in `CONTEXT.md` was correct, but not explicit enough to prevent the error.

### Proposed Change
- Add a note to the "Maintenance Guidelines" section of the "Tmux Help System Implementation" in `CONTEXT.md` to emphasize the correct directory name (`tables`).

## 📝 Implementation Plan

### Step-by-Step Implementation

1.  **Update `CONTEXT.md`**
    - Files to modify: `CONTEXT.md`
    - Changes needed: Add a note to the maintenance guidelines.

    **Current Maintenance Guidelines:**
    ```
    ### Maintenance Guidelines

    **When making keybinding changes:**

    1. Update the corresponding `.txt` file in `tables/` directory
    2. Test the help display: `~/.config/tmux/scripts/popup/help/help.sh <table-name>`
    3. Ensure table formatting is correct (tab-separated values)
    4. Update AGENTS.md documentation if adding new tables or changing structure
    ```

    **Proposed new Maintenance Guidelines:**
    ```
    ### Maintenance Guidelines

    **When making keybinding changes:**

    1. Update the corresponding `.txt` file in the `~/.config/tmux/scripts/help/tables/` directory. **Note the plural 'tables'**.
    2. Test the help display: `~/.config/tmux/scripts/popup/help/help.sh <table-name>`
    3. Ensure table formatting is correct (tab-separated values)
    4. Update AGENTS.md documentation if adding new tables or changing structure
    ```

### Testing Strategy
- No testing is required for this documentation change.

## 🎯 Success Criteria
- The `CONTEXT.md` file is updated with the more explicit note.
