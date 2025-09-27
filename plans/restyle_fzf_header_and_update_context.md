# Feature Implementation Plan: Restyle FZF Header and Update Context

## 📋 Todo Checklist
- [ ] Analyze codebase for color definitions and script modification points.
- [ ] Add ANSI color variables to `tool.sh`.
- [ ] Modify the `FZF_HEADER` in `tool.sh` to use the new colors.
- [ ] Update the `GEMINI.md` context file with the cobalt2 color preference.
- [ ] Save the color preference to long-term memory.
- [ ] Final Review and Testing.

## 🔍 Analysis & Investigation

### User Request Analysis

1.  **Primary Goal**: The user wants to re-add color to the tool name displayed in the `fzf` layout selection menu inside `tool.sh`. The color was present in an older version of the script but was removed during the last major refactor.
2.  **Color Specification**: The desired color is yellow, specifically from the user's `cobalt2` theme.
3.  **Context Update**: A meta-request was included to make the `cobalt2` theme the default color palette for any future UI work. This preference should be stored in my context file (`GEMINI.md`) and my long-term memory.

### Codebase Investigation

-   **Files Inspected**:
    -   `/home/lalitmee/dotfiles/tmux/.config/tmux/scripts/ai/tool.sh`
    -   `/home/lalitmee/dotfiles/tmux/.tmux.conf.local`
    -   `/home/lalitmee/dotfiles/GEMINI.md`

-   **Findings**:
    1.  The `tool.sh` script currently defines `FZF_HEADER="Choose layout for $PANE_TITLE:"`. This uses the full pane title (e.g., "🤖 Gemini") and has no color formatting.
    2.  The `tmux.conf.local` file contains the `cobalt2` theme definition, where the yellow color is specified with the hex code `#ffc600`. For use in a standard shell script with `fzf`, it's more reliable to use an ANSI 8-bit color code. The equivalent is `227`.
    3.  The script currently has no ANSI color variables defined, as they were removed in the last refactor. They need to be re-introduced.

### Proposed Approach

The plan is to modify `tool.sh` to re-introduce color variables and use them to style the `$TOOL` name in the `fzf` header. Subsequently, the `GEMINI.md` context file and the agent's long-term memory will be updated to reflect this preference for future work.

## 📝 Implementation Plan

### Prerequisites
- The `tool.sh` script from the previous `optimize_and_fix_launcher` plan is the baseline.

### Step-by-Step Implementation

1.  **Step 1**: Add ANSI Color Definitions to `tool.sh`
    -   **Files to modify**: `/home/lalitmee/dotfiles/tmux/.config/tmux/scripts/ai/tool.sh`
    -   **Changes needed**: At the top of the script, before the dependency check, add a section for ANSI color variables. This makes the script more readable and makes colors easier to change in the future.

    ```bash
    # Add this block after set -e
    # --- ANSI Color Definitions ---
    COLOR_YELLOW=$'\033[38;5;227m'  # Cobalt2 Yellow
    RESET_COLOR=$'\033[0m'
    ```

2.  **Step 2**: Modify FZF Header to Use New Colors
    -   **Files to modify**: `/home/lalitmee/dotfiles/tmux/.config/tmux/scripts/ai/tool.sh`
    -   **Changes needed**: In the "Layout Selection" section, modify the definition of the `FZF_HEADER` variable to apply the yellow color to the `$TOOL` variable.

    ```bash
    # Find this line:
    FZF_HEADER="Choose layout for $PANE_TITLE:"

    # And replace it with this:
    FZF_HEADER="Choose layout for ${COLOR_YELLOW}${TOOL}${RESET_COLOR}:"
    ```

3.  **Step 3**: Update `GEMINI.md` Context File
    -   **Files to modify**: `/home/lalitmee/dotfiles/GEMINI.md`
    -   **Changes needed**: Append a new section to the end of the file to document the color preference.

    ```markdown
    ## User Preferences

    - **Color Palette**: The user's preferred color palette is **cobalt2**. When implementing or modifying UI components, this theme should be used as the default. The primary yellow from this theme is `#ffc600` (ANSI 8-bit: `227`).
    ```

4.  **Step 4**: Update Long-Term Memory
    -   **Files to modify**: None.
    -   **Changes needed**: The implementing agent will execute the `save_memory` tool with the following fact:

    ```python
    default_api.save_memory(fact="My preferred color palette is cobalt2. When adding colors to UI elements, please use this theme's palette by default and mention it in the plan.")
    ```

### Testing Strategy

1.  Press any of the AI tool keybindings (e.g., for `gemini`).
2.  **Verification**: Observe the `fzf` menu that appears. The header should now display the tool's name in a bright yellow color.
3.  **Regression Test**: Select any layout option (`popup`, `split`, `window`) and confirm that the tool still launches correctly.
4.  **Context Test**: After the session, inspect the `GEMINI.md` file to confirm the new "User Preferences" section has been added.

## 🎯 Success Criteria

-   The `fzf` header in the `tool.sh` script correctly displays the current AI tool's name in yellow.
-   The core functionality of the launcher (selecting a layout and opening the tool) remains unaffected.
-   The `GEMINI.md` file is successfully updated with the user's color preferences.
-   The agent's long-term memory is updated.
