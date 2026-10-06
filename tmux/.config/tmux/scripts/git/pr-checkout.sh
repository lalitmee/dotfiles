#!/usr/bin/env zsh
# Checkout a GitHub/GitLab PR into a new worktree (gum prompt for # or URL).

pr=$(gum input \
    --placeholder '123 or https://github.com/owner/repo/pull/123' \
    --header 'Checkout Pull Request' \
    --header.foreground '#FFC600' \
    --cursor.foreground '#00AAFF')

# Empty input (or Esc) does nothing
[[ -n "$pr" ]] && workmux add --pr "$pr"
