# Specification: Fix argument parsing issue in tmux-file-picker script

## Overview

The script `tmux-file-picker` in `bin/.config/bin/tmux-file-picker` fails when checking options because of how variables are expanded in Zsh. Zsh does not perform word splitting by default when expanding variables like `$fd_flags`. As a result, `$fd_flags` (which defaults to `-H --type f --exclude .git`) is passed to the `fd` command as a single argument, leading to the error `unexpected argument '- ' found`.

## Goals

- Fix the variable expansion for `$fd_flags` inside `bin/.config/bin/tmux-file-picker` so that options are correctly split and passed as separate arguments to the `fd`/`fdfind` utility.
- Ensure the script runs successfully without any option parsing errors when invoked through Tmux keybindings.

## Requirements

- Correct the option expansion inside the script.
- Ensure Zsh arrays or native splitting (`$=var` syntax) are used correctly.
- Test that options containing spaces (e.g. `--exclude .git`) are handled correctly.
- Verify that standard invocation and all tmux bindings for `tmux-file-picker` function as expected.
