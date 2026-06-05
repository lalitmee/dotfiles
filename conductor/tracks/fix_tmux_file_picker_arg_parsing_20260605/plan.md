# Implementation Plan: Fix argument parsing issue in tmux-file-picker script

## Phase 1: Setup and Red Phase (Write Failing Tests)

- [ ] Task: Create a test script `scripts/test/test_file_picker.zsh` that runs the file picker script in a controlled environment and checks for the "unexpected argument" error.
    - [ ] Create `scripts/test/test_file_picker.zsh` with test assertions for flag splitting
    - [ ] Ensure the script runs and demonstrates the bug by failing
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Setup and Red Phase' (Protocol in workflow.md)

## Phase 2: Green Phase (Implement Fix & Refactor)

- [ ] Task: Modify `bin/.config/bin/tmux-file-picker` to fix the `fd` option expansion.
    - [ ] Correct `$fd_flags` expansion inside the `selected_files_str` block using arrays or Zsh splitting
    - [ ] Verify the syntax of the modified `tmux-file-picker` script
- [ ] Task: Run the test script to confirm it passes (Green phase).
    - [ ] Execute `scripts/test/test_file_picker.zsh` and verify all tests pass
    - [ ] Verify that other options (e.g., `-g`, `--zoxide`) continue to work properly
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Green Phase' (Protocol in workflow.md)
