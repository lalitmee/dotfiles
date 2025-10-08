# Gemini Context File - Dotfiles Repository

## My Core Directives

1.  **NEVER AUTO-COMMIT**: Always ask for permission before committing changes, except for context files.
2.  **BE THOROUGH**: Read multiple files to understand the full context before making changes. **DO NOT** assume.
3.  **TEST CHANGES**: Especially for `tmux`, validate syntax and functionality before considering a task complete.
4.  **USE THE RIGHT TOOLS**: Use the enhanced installation system (`./scripts/install/main-installer.zsh`) for any system setup tasks.
5.  **RESPECT CONVENTIONS**: Adhere strictly to the coding styles, naming conventions, and workflows outlined in `CONTEXT.md`.
6.  **UPDATE DOCUMENTATION**: When changing keybindings, **ALWAYS** update the `tmux` help tables if applicable.
7.  **ASK QUESTIONS**: If unsure about a requirement or preference, ask for clarification before proceeding.
8.  **CONTEXT IS KEY**: Always refer to `CONTEXT.md` for the most accurate and up-to-date information about the user's preferences and system setup. If there is a conflict between your instructions/understanding and the context files, **ALWAYS ASK** for clarification informing the user about the conflict.
9.  **EFFICIENCY**: Use parallel tool calls when gathering information to minimize wait times.
10. **EXPLAIN CHANGES**: Provide clear explanations for any changes made, including the reasoning behind them.
11. **LEARN & ADAPT**: If you discover a new workflow or a better way of doing things, update the context files for future reference.

## My Problem-Solving Workflow

1.  **Confirm My Understanding**: Before implementing a solution, I will first re-state the user's goal in my own words.
2.  **State My Hypothesis**: Before making a change, I will briefly explain what I believe the problem is and why my proposed solution will fix it.
3.  **Analyze Holistically**: If a change I make results in unexpected behavior, I will stop and re-evaluate the entire context.
4.  **Make Precise Changes**: I will strive to make the smallest, most targeted change possible to solve the problem.
5.  **Verify Syntax After Changes**: After modifying any code, I will verify its syntax to ensure correctness and prevent regressions.
6.  **Verify Permissions**: After creating a script that is meant to be executed, I will always verify and set its executable permissions.
7.  **Leverage User Feedback & Direct Simulation**: When debugging complex issues, I will actively solicit user feedback on symptoms and consider their suggestions for debugging.
8.  **Immediate Context Update**: Upon successful resolution of a problem, I will immediately update the relevant context files with the solution and any new insights.

## Tmux Popup Workflow

When creating a new toggleable popup in tmux, the following workflow should be followed:

1.  **Create a Shell Script**: Write a shell script that manages the popup's state.
2.  **Make the Script Executable**: Use `chmod +x` to make the script executable.
3.  **Determine the Keybinding**:
    *   **Analyze Existing Bindings**: Analyze `~/dotfiles/tmux/.tmux.conf.local` and the help tables to avoid conflicts.
    *   **Ask the User**: Always ask the user for their preferred keybinding.
    *   **Suggest and Confirm**: Suggest a keybinding with justification and ask for approval.
4.  **Add the Keybinding**: Once approved, add the keybinding to `~/dotfiles/tmux/.tmux.conf.local`.
5.  **Reload Tmux**: Instruct the user to reload their tmux configuration.

## Gemini CLI Command Prompts

- **Prompt Location:** Command prompts are defined in `.toml` files within the `~/.gemini/commands/` directory.
- **Example Format:** The `OUTPUT FORMAT` section within a prompt should only contain the expected output from the LLM. Do not include `User:` or `AI:` prefixes; the examples should be raw text representing the model's response.

## User Preferences

- **UI/UX**: The user appreciates rich, styled terminal UI using tools like `gum`.
- **Color Palette**: The user's preferred color palette is **cobalt2**.