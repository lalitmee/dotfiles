# Effective tmux baseline (read-only capture)

- Captured from the existing active tmux server; no config was sourced or reloaded.
- Sanitization: `/home/lalitmee` replaced with `$HOME`; session names and private option values are omitted.

- tmux version: `tmux 3.8`

## Effective key tables

| Table | Binding count |
|---|---:|
| `ai-tools` | 15 |
| `ask-tools` | 8 |
| `copy-mode` | 82 |
| `copy-mode-vi` | 95 |
| `dev-mode` | 7 |
| `file-picker-mode` | 8 |
| `fingers` | 92 |
| `git-mode` | 20 |
| `layout-mode` | 16 |
| `monitor-mode` | 3 |
| `move` | 19 |
| `prefix` | 142 |
| `quick-ref` | 6 |
| `root` | 41 |
| `second-brain` | 24 |
| `spotify-mode` | 7 |
| `work-sessions` | 11 |

Binding count: 596

Distinct reported table count: 17. The previously expected count of 18 does not match this live server; `copy-mode-emacs` is absent (`mode-keys=vi`). See reconciliation below.

## Effective bindings

```text
bind-key    -T ai-tools         ?                         run-shell "${HOME}/.config/tmux/scripts/popup/help/help.sh ai-tools"
bind-key    -T ai-tools         U                         run-shell -b "UPDATE_MODE=--interactive ~/.config/tmux/scripts/popup/ai/update.sh"
bind-key    -T ai-tools         a                         display-popup -E -h "85%" -w "85%" "${HOME}/.config/tmux/scripts/popup/ai/tool.sh agy"
bind-key    -T ai-tools         c                         display-popup -E -h "85%" -w "85%" "${HOME}/.config/tmux/scripts/popup/ai/tool.sh claude"
bind-key    -T ai-tools         g                         display-popup -E -h "85%" -w "85%" "${HOME}/.config/tmux/scripts/popup/ai/tool.sh cursor-agent"
bind-key    -T ai-tools         h                         display-popup -E -h "85%" -w "85%" "${HOME}/.config/tmux/scripts/popup/ai/tool.sh copilot"
bind-key    -T ai-tools         i                         new-window -c "#{pane_current_path}" -n ai-manage "zsh -lic '~/.config/tmux/scripts/popup/ai/manage.sh'"
bind-key    -T ai-tools         k                         display-popup -E -h "85%" -w "85%" "${HOME}/.config/tmux/scripts/popup/ai/tool.sh kiro"
bind-key    -T ai-tools         o                         display-popup -E -h "85%" -w "85%" "${HOME}/.config/tmux/scripts/popup/ai/tool.sh opencode"
bind-key    -T ai-tools         p                         display-popup -E -h "85%" -w "85%" "${HOME}/.config/tmux/scripts/popup/ai/tool.sh pi"
bind-key    -T ai-tools         q                         switch-client -T root
bind-key    -T ai-tools         r                         display-popup -E -h "85%" -w "85%" "${HOME}/.config/tmux/scripts/popup/ai/tool.sh grok"
bind-key    -T ai-tools         s                         display-popup -E -h "85%" -w "85%" "${HOME}/.config/tmux/scripts/popup/ai/tool.sh crush"
bind-key    -T ai-tools         u                         run-shell -b "UPDATE_MODE=--non-interactive ~/.config/tmux/scripts/popup/ai/update.sh"
bind-key    -T ai-tools         x                         display-popup -E -h "85%" -w "85%" "${HOME}/.config/tmux/scripts/popup/ai/tool.sh codex"
bind-key    -T ask-tools        /                         display-popup -E -h "85%" -w "85%" "zsh -lc '~/.config/tmux/scripts/ask-sh/ask.sh search'"
bind-key    -T ask-tools        ?                         run-shell "${HOME}/.config/tmux/scripts/popup/help/help.sh ask-tools"
bind-key    -T ask-tools        a                         display-popup -E -h "85%" -w "85%" "zsh -lc '~/.config/tmux/scripts/ask-sh/ask.sh ai'"
bind-key    -T ask-tools        b                         display-popup -E -h "85%" -w "85%" "zsh -lc '~/.config/tmux/scripts/ask-sh/ask.sh bang'"
bind-key    -T ask-tools        c                         display-popup -E -h "70%" -w "80%" "zsh -lc '~/.config/tmux/scripts/ask-sh/ask.sh ai-chat'"
bind-key    -T ask-tools        d                         display-popup -E -h "85%" -w "85%" "zsh -lc '~/.config/tmux/scripts/ask-sh/ask.sh ducky'"
bind-key    -T ask-tools        q                         switch-client -T root
bind-key    -T ask-tools        s                         display-popup -E -h "85%" -w "85%" "zsh -lc '~/.config/tmux/scripts/ask-sh/ask.sh site'"
bind-key    -T copy-mode        Escape                    send-keys -X cancel
bind-key    -T copy-mode        Space                     send-keys -X page-down
bind-key    -T copy-mode        !                         send-keys -X copy-pipe-and-cancel "tr -d '\n' | xsel -i --clipboard"
bind-key    -T copy-mode        ,                         send-keys -X jump-reverse
bind-key    -T copy-mode        \;                        send-keys -X jump-again
bind-key    -T copy-mode        F                         command-prompt -1P -p "(jump backward)" { send-keys -X jump-backward -- "%%" }
bind-key    -T copy-mode        L                         send-keys -X line-numbers-toggle
bind-key    -T copy-mode        N                         send-keys -X search-reverse
bind-key    -T copy-mode        P                         send-keys -X toggle-position
bind-key    -T copy-mode        R                         send-keys -X rectangle-toggle
bind-key    -T copy-mode        T                         command-prompt -1P -p "(jump to backward)" { send-keys -X jump-to-backward -- "%%" }
bind-key    -T copy-mode        X                         send-keys -X set-mark
bind-key    -T copy-mode        Y                         send-keys -X copy-pipe-and-cancel "tmux paste-buffer -p"
bind-key    -T copy-mode        f                         command-prompt -1P -p "(jump forward)" { send-keys -X jump-forward -- "%%" }
bind-key    -T copy-mode        g                         command-prompt -P -p "(goto line)" { send-keys -X goto-line -- "%%" }
bind-key    -T copy-mode        n                         send-keys -X search-again
bind-key    -T copy-mode        q                         send-keys -X cancel
bind-key    -T copy-mode        r                         send-keys -X refresh-now
bind-key    -T copy-mode        t                         command-prompt -1P -p "(jump to forward)" { send-keys -X jump-to-forward -- "%%" }
bind-key    -T copy-mode        y                         send-keys -X copy-pipe-and-cancel "xsel -i --clipboard"
bind-key    -T copy-mode        Home                      send-keys -X start-of-line
bind-key    -T copy-mode        End                       send-keys -X end-of-line
bind-key    -T copy-mode        NPage                     send-keys -X page-down
bind-key    -T copy-mode        PPage                     send-keys -X page-up
bind-key    -T copy-mode        Up                        send-keys -X cursor-up
bind-key    -T copy-mode        Down                      send-keys -X cursor-down
bind-key    -T copy-mode        Left                      send-keys -X cursor-left
bind-key    -T copy-mode        Right                     send-keys -X cursor-right
bind-key    -T copy-mode        MouseDown1Pane            select-pane
bind-key    -T copy-mode        MouseDrag1Pane            select-pane \; send-keys -X begin-selection
bind-key    -T copy-mode        MouseDragEnd1Pane         send-keys -X copy-pipe-and-cancel "xsel -i --primary"
bind-key    -T copy-mode        WheelDownPane             send-keys -X -N 3 scroll-down
bind-key    -T copy-mode        WheelUpPane               send-keys -X -N 3 scroll-up
bind-key    -T copy-mode        DoubleClick1Pane          select-pane \; send-keys -X select-word \; run-shell -d 0.3 \; send-keys -X copy-pipe-and-cancel "xsel -i -b"
bind-key    -T copy-mode        TripleClick1Pane          select-pane \; send-keys -X select-line \; run-shell -d 0.3 \; send-keys -X copy-pipe-and-cancel "xsel -i -b"
bind-key    -T copy-mode        M-1                       command-prompt -NP -I 1 -p (repeat) { send-keys -N "%%" }
bind-key    -T copy-mode        M-2                       command-prompt -NP -I 2 -p (repeat) { send-keys -N "%%" }
bind-key    -T copy-mode        M-3                       command-prompt -NP -I 3 -p (repeat) { send-keys -N "%%" }
bind-key    -T copy-mode        M-4                       command-prompt -NP -I 4 -p (repeat) { send-keys -N "%%" }
bind-key    -T copy-mode        M-5                       command-prompt -NP -I 5 -p (repeat) { send-keys -N "%%" }
bind-key    -T copy-mode        M-6                       command-prompt -NP -I 6 -p (repeat) { send-keys -N "%%" }
bind-key    -T copy-mode        M-7                       command-prompt -NP -I 7 -p (repeat) { send-keys -N "%%" }
bind-key    -T copy-mode        M-8                       command-prompt -NP -I 8 -p (repeat) { send-keys -N "%%" }
bind-key    -T copy-mode        M-9                       command-prompt -NP -I 9 -p (repeat) { send-keys -N "%%" }
bind-key    -T copy-mode        M-<                       send-keys -X history-top
bind-key    -T copy-mode        M->                       send-keys -X history-bottom
bind-key    -T copy-mode        M-R                       send-keys -X top-line
bind-key    -T copy-mode        M-b                       send-keys -X previous-word
bind-key    -T copy-mode        M-f                       send-keys -X next-word-end
bind-key    -T copy-mode        M-l                       send-keys -X cursor-centre-horizontal
bind-key    -T copy-mode        M-m                       send-keys -X back-to-indentation
bind-key    -T copy-mode        M-r                       send-keys -X middle-line
bind-key    -T copy-mode        M-v                       send-keys -X page-up
bind-key    -T copy-mode        M-w                       send-keys -X copy-pipe-and-cancel "xsel -i -b"
bind-key    -T copy-mode        M-x                       send-keys -X jump-to-mark
bind-key    -T copy-mode        M-y                       send-keys -X copy-pipe-and-cancel "xsel -i --clipboard; tmux paste-buffer -p"
bind-key    -T copy-mode        "M-{"                     send-keys -X previous-paragraph
bind-key    -T copy-mode        "M-}"                     send-keys -X next-paragraph
bind-key    -T copy-mode        M-Up                      send-keys -X halfpage-up
bind-key    -T copy-mode        M-Down                    send-keys -X halfpage-down
bind-key    -T copy-mode        C-Space                   send-keys -X begin-selection
bind-key    -T copy-mode        C-[                       send-keys -X cancel
bind-key    -T copy-mode        C-a                       send-keys -X start-of-line
bind-key    -T copy-mode        C-b                       send-keys -X cursor-left
bind-key    -T copy-mode        C-c                       send-keys -X cancel
bind-key    -T copy-mode        C-e                       send-keys -X end-of-line
bind-key    -T copy-mode        C-f                       send-keys -X cursor-right
bind-key    -T copy-mode        C-g                       send-keys -X clear-selection
bind-key    -T copy-mode        C-k                       send-keys -X copy-pipe-end-of-line "xsel -i -b-and-cancel"
bind-key    -T copy-mode        C-l                       send-keys -X recentre-top-bottom
bind-key    -T copy-mode        C-n                       send-keys -X cursor-down
bind-key    -T copy-mode        C-p                       send-keys -X cursor-up
bind-key    -T copy-mode        C-r                       command-prompt -Pi -I "#{pane_search_string}" -T search -p "(search up)" { send-keys -X search-backward-incremental -- "%%" }
bind-key    -T copy-mode        C-s                       command-prompt -Pi -I "#{pane_search_string}" -T search -p "(search down)" { send-keys -X search-forward-incremental -- "%%" }
bind-key    -T copy-mode        C-v                       send-keys -X page-down
bind-key    -T copy-mode        C-w                       send-keys -X copy-pipe-and-cancel "xsel -i -b"
bind-key    -T copy-mode        C-Up                      send-keys -X scroll-up
bind-key    -T copy-mode        C-Down                    send-keys -X scroll-down
bind-key    -T copy-mode        C-M-b                     send-keys -X previous-matching-bracket
bind-key    -T copy-mode        C-M-f                     send-keys -X next-matching-bracket
bind-key    -T copy-mode        C-M-Up                    send-keys -X previous-prompt
bind-key    -T copy-mode        C-M-Down                  send-keys -X next-prompt
bind-key    -T copy-mode-vi     Enter                     send-keys -X copy-pipe-and-cancel "xsel -i -b"
bind-key    -T copy-mode-vi     Escape                    send-keys -X cancel
bind-key    -T copy-mode-vi     Space                     send-keys -X begin-selection
bind-key    -T copy-mode-vi     !                         send-keys -X copy-pipe-and-cancel "tr -d '\n' | xsel -i --clipboard"
bind-key    -T copy-mode-vi     \#                        send-keys -FX search-backward -- "#{copy_cursor_word}"
bind-key    -T copy-mode-vi     \$                        send-keys -X end-of-line
bind-key    -T copy-mode-vi     \%                        send-keys -X next-matching-bracket
bind-key    -T copy-mode-vi     *                         send-keys -FX search-forward -- "#{copy_cursor_word}"
bind-key    -T copy-mode-vi     ,                         send-keys -X jump-reverse
bind-key    -T copy-mode-vi     /                         command-prompt -P -T search -p "(search down)" { send-keys -X search-forward -- "%%" }
bind-key    -T copy-mode-vi     0                         send-keys -X start-of-line
bind-key    -T copy-mode-vi     1                         command-prompt -NP -I 1 -p (repeat) { send-keys -N "%%" }
bind-key    -T copy-mode-vi     2                         command-prompt -NP -I 2 -p (repeat) { send-keys -N "%%" }
bind-key    -T copy-mode-vi     3                         command-prompt -NP -I 3 -p (repeat) { send-keys -N "%%" }
bind-key    -T copy-mode-vi     4                         command-prompt -NP -I 4 -p (repeat) { send-keys -N "%%" }
bind-key    -T copy-mode-vi     5                         command-prompt -NP -I 5 -p (repeat) { send-keys -N "%%" }
bind-key    -T copy-mode-vi     6                         command-prompt -NP -I 6 -p (repeat) { send-keys -N "%%" }
bind-key    -T copy-mode-vi     7                         command-prompt -NP -I 7 -p (repeat) { send-keys -N "%%" }
bind-key    -T copy-mode-vi     8                         command-prompt -NP -I 8 -p (repeat) { send-keys -N "%%" }
bind-key    -T copy-mode-vi     9                         command-prompt -NP -I 9 -p (repeat) { send-keys -N "%%" }
bind-key    -T copy-mode-vi     :                         command-prompt -P -p "(goto line)" { send-keys -X goto-line -- "%%" }
bind-key    -T copy-mode-vi     \;                        send-keys -X jump-again
bind-key    -T copy-mode-vi     ?                         command-prompt -P -T search -p "(search up)" { send-keys -X search-backward -- "%%" }
bind-key    -T copy-mode-vi     A                         send-keys -X append-selection-and-cancel
bind-key    -T copy-mode-vi     B                         send-keys -X previous-space
bind-key    -T copy-mode-vi     D                         send-keys -X copy-pipe-end-of-line "xsel -i -b-and-cancel"
bind-key    -T copy-mode-vi     E                         send-keys -X next-space-end
bind-key    -T copy-mode-vi     F                         command-prompt -1P -p "(jump backward)" { send-keys -X jump-backward -- "%%" }
bind-key    -T copy-mode-vi     G                         send-keys -X history-bottom
bind-key    -T copy-mode-vi     H                         send-keys -X start-of-line
bind-key    -T copy-mode-vi     J                         send-keys -X scroll-down
bind-key    -T copy-mode-vi     K                         send-keys -X scroll-up
bind-key    -T copy-mode-vi     L                         send-keys -X end-of-line
bind-key    -T copy-mode-vi     M                         send-keys -X middle-line
bind-key    -T copy-mode-vi     N                         send-keys -X search-reverse
bind-key    -T copy-mode-vi     P                         send-keys -X toggle-position
bind-key    -T copy-mode-vi     T                         command-prompt -1P -p "(jump to backward)" { send-keys -X jump-to-backward -- "%%" }
bind-key    -T copy-mode-vi     V                         send-keys -X select-line
bind-key    -T copy-mode-vi     W                         send-keys -X next-space
bind-key    -T copy-mode-vi     X                         send-keys -X set-mark
bind-key    -T copy-mode-vi     Y                         send-keys -X copy-pipe-and-cancel "tmux paste-buffer -p"
bind-key    -T copy-mode-vi     ^                         send-keys -X back-to-indentation
bind-key    -T copy-mode-vi     b                         send-keys -X previous-word
bind-key    -T copy-mode-vi     e                         send-keys -X next-word-end
bind-key    -T copy-mode-vi     f                         command-prompt -1P -p "(jump forward)" { send-keys -X jump-forward -- "%%" }
bind-key    -T copy-mode-vi     g                         send-keys -X history-top
bind-key    -T copy-mode-vi     h                         send-keys -X cursor-left
bind-key    -T copy-mode-vi     i                         send-keys -X cancel
bind-key    -T copy-mode-vi     j                         send-keys -X cursor-down
bind-key    -T copy-mode-vi     k                         send-keys -X cursor-up
bind-key    -T copy-mode-vi     l                         send-keys -X cursor-right
bind-key    -T copy-mode-vi     n                         send-keys -X search-again
bind-key    -T copy-mode-vi     o                         send-keys -X other-end
bind-key    -T copy-mode-vi     q                         send-keys -X cancel
bind-key    -T copy-mode-vi     r                         send-keys -X refresh-now
bind-key    -T copy-mode-vi     t                         command-prompt -1P -p "(jump to forward)" { send-keys -X jump-to-forward -- "%%" }
bind-key    -T copy-mode-vi     v                         send-keys -X begin-selection
bind-key    -T copy-mode-vi     w                         send-keys -X next-word
bind-key    -T copy-mode-vi     y                         send-keys -X copy-pipe-and-cancel "xsel -i --clipboard"
bind-key    -T copy-mode-vi     z                         send-keys -X scroll-middle
bind-key    -T copy-mode-vi     \{                        send-keys -X previous-paragraph
bind-key    -T copy-mode-vi     \}                        send-keys -X next-paragraph
bind-key    -T copy-mode-vi     BSpace                    send-keys -X cursor-left
bind-key    -T copy-mode-vi     Home                      send-keys -X start-of-line
bind-key    -T copy-mode-vi     End                       send-keys -X end-of-line
bind-key    -T copy-mode-vi     NPage                     send-keys -X page-down
bind-key    -T copy-mode-vi     PPage                     send-keys -X page-up
bind-key    -T copy-mode-vi     Up                        send-keys -X cursor-up
bind-key    -T copy-mode-vi     Down                      send-keys -X cursor-down
bind-key    -T copy-mode-vi     Left                      send-keys -X cursor-left
bind-key    -T copy-mode-vi     Right                     send-keys -X cursor-right
bind-key    -T copy-mode-vi     MouseDown1Pane            select-pane
bind-key    -T copy-mode-vi     MouseDrag1Pane            select-pane \; send-keys -X begin-selection
bind-key    -T copy-mode-vi     MouseDragEnd1Pane         send-keys -X copy-pipe-and-cancel "xsel -i --primary"
bind-key    -T copy-mode-vi     WheelDownPane             send-keys -X -N 3 scroll-down
bind-key    -T copy-mode-vi     WheelUpPane               send-keys -X -N 3 scroll-up
bind-key    -T copy-mode-vi     DoubleClick1Pane          select-pane \; send-keys -X select-word \; run-shell -d 0.3 \; send-keys -X copy-pipe-and-cancel "xsel -i -b"
bind-key    -T copy-mode-vi     TripleClick1Pane          select-pane \; send-keys -X select-line \; run-shell -d 0.3 \; send-keys -X copy-pipe-and-cancel "xsel -i -b"
bind-key    -T copy-mode-vi     M-x                       send-keys -X jump-to-mark
bind-key    -T copy-mode-vi     M-y                       send-keys -X copy-pipe-and-cancel "xsel -i --clipboard; tmux paste-buffer -p"
bind-key    -T copy-mode-vi     C-[                       send-keys -X clear-selection
bind-key    -T copy-mode-vi     C-b                       send-keys -X page-up
bind-key    -T copy-mode-vi     C-c                       send-keys -X cancel
bind-key    -T copy-mode-vi     C-d                       send-keys -X halfpage-down
bind-key    -T copy-mode-vi     C-e                       send-keys -X scroll-down
bind-key    -T copy-mode-vi     C-f                       send-keys -X page-down
bind-key    -T copy-mode-vi     C-h                       select-pane -L
bind-key    -T copy-mode-vi     C-j                       select-pane -D
bind-key    -T copy-mode-vi     C-k                       select-pane -U
bind-key    -T copy-mode-vi     C-l                       select-pane -R
bind-key    -T copy-mode-vi     C-u                       send-keys -X halfpage-up
bind-key    -T copy-mode-vi     C-v                       send-keys -X rectangle-toggle
bind-key    -T copy-mode-vi     C-y                       send-keys -X scroll-up
bind-key    -T copy-mode-vi     C-Up                      send-keys -X scroll-up
bind-key    -T copy-mode-vi     C-Down                    send-keys -X scroll-down
bind-key    -T dev-mode         ?                         run-shell "${HOME}/.config/tmux/scripts/popup/help/help.sh dev-mode"
bind-key    -T dev-mode         a                         display-popup -E -h "90%" -w "90%" ${HOME}/.config/tmux/scripts/apt-repo-manager.sh
bind-key    -T dev-mode         b                         display-popup -BE -h "100%" -w "100%" -x "0%" -y "0%" ${HOME}/.tmux/plugins/back-in-5/scripts/main.sh
bind-key    -T dev-mode         e                         run-shell "#{@tpad-path} toggle espanso-edit"
bind-key    -T dev-mode         q                         switch-client -T root
bind-key    -T dev-mode         r                         run-shell "zsh ${HOME}/.config/tmux/scripts/popup/runner/runner.sh '#{pane_id}' '#{pane_current_path}'"
bind-key    -T dev-mode         s                         run-shell "#{@tpad-path} toggle scratchpad"
bind-key    -T file-picker-mode ?                         run-shell "${HOME}/.config/tmux/scripts/popup/help/help.sh file-picker-mode"
bind-key    -T file-picker-mode d                         display-popup -E -h "90%" -w "90%" ${HOME}/.config/tmux/scripts/ai-docs-picker.sh
bind-key    -T file-picker-mode f                         display-popup -E -h "80%" -w "80%" tmux-file-picker
bind-key    -T file-picker-mode g                         display-popup -E -h "80%" -w "80%" "tmux-file-picker -g"
bind-key    -T file-picker-mode q                         switch-client -T root
bind-key    -T file-picker-mode v                         display-popup -E -h "80%" -w "80%" "tmux-file-picker --zoxide --dir-only"
bind-key    -T file-picker-mode x                         display-popup -E -h "80%" -w "80%" "tmux-file-picker --zoxide --git-root"
bind-key    -T file-picker-mode z                         display-popup -E -h "80%" -w "80%" "tmux-file-picker --zoxide"
bind-key    -T fingers          Tab                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input toggle-multi-mode"
bind-key    -T fingers          Enter                     run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input noop"
bind-key    -T fingers          Escape                    run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input exit"
bind-key    -T fingers          Space                     run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input fzf"
bind-key    -T fingers          ?                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input toggle-help"
bind-key    -T fingers          A                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:a:shift"
bind-key    -T fingers          B                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:b:shift"
bind-key    -T fingers          D                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:d:shift"
bind-key    -T fingers          E                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:e:shift"
bind-key    -T fingers          F                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:f:shift"
bind-key    -T fingers          G                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:g:shift"
bind-key    -T fingers          H                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:h:shift"
bind-key    -T fingers          J                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:j:shift"
bind-key    -T fingers          K                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:k:shift"
bind-key    -T fingers          L                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:l:shift"
bind-key    -T fingers          O                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:o:shift"
bind-key    -T fingers          P                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:p:shift"
bind-key    -T fingers          R                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:r:shift"
bind-key    -T fingers          S                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:s:shift"
bind-key    -T fingers          T                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:t:shift"
bind-key    -T fingers          U                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:u:shift"
bind-key    -T fingers          V                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:v:shift"
bind-key    -T fingers          W                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:w:shift"
bind-key    -T fingers          X                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:x:shift"
bind-key    -T fingers          Y                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:y:shift"
bind-key    -T fingers          Z                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:z:shift"
bind-key    -T fingers          a                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:a:main"
bind-key    -T fingers          b                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:b:main"
bind-key    -T fingers          d                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:d:main"
bind-key    -T fingers          e                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:e:main"
bind-key    -T fingers          f                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:f:main"
bind-key    -T fingers          g                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:g:main"
bind-key    -T fingers          h                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:h:main"
bind-key    -T fingers          j                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:j:main"
bind-key    -T fingers          k                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:k:main"
bind-key    -T fingers          l                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:l:main"
bind-key    -T fingers          o                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:o:main"
bind-key    -T fingers          p                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:p:main"
bind-key    -T fingers          q                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input exit"
bind-key    -T fingers          r                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:r:main"
bind-key    -T fingers          s                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:s:main"
bind-key    -T fingers          t                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:t:main"
bind-key    -T fingers          u                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:u:main"
bind-key    -T fingers          v                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:v:main"
bind-key    -T fingers          w                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:w:main"
bind-key    -T fingers          x                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:x:main"
bind-key    -T fingers          y                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:y:main"
bind-key    -T fingers          z                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:z:main"
bind-key    -T fingers          Any                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input noop"
bind-key    -T fingers          M-a                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:a:alt"
bind-key    -T fingers          M-b                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:b:alt"
bind-key    -T fingers          M-d                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:d:alt"
bind-key    -T fingers          M-e                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:e:alt"
bind-key    -T fingers          M-f                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:f:alt"
bind-key    -T fingers          M-g                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:g:alt"
bind-key    -T fingers          M-h                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:h:alt"
bind-key    -T fingers          M-j                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:j:alt"
bind-key    -T fingers          M-k                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:k:alt"
bind-key    -T fingers          M-l                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:l:alt"
bind-key    -T fingers          M-o                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:o:alt"
bind-key    -T fingers          M-p                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:p:alt"
bind-key    -T fingers          M-r                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:r:alt"
bind-key    -T fingers          M-s                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:s:alt"
bind-key    -T fingers          M-t                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:t:alt"
bind-key    -T fingers          M-u                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:u:alt"
bind-key    -T fingers          M-v                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:v:alt"
bind-key    -T fingers          M-w                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:w:alt"
bind-key    -T fingers          M-x                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:x:alt"
bind-key    -T fingers          M-y                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:y:alt"
bind-key    -T fingers          M-z                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:z:alt"
bind-key    -T fingers          C-a                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:a:ctrl"
bind-key    -T fingers          C-b                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:b:ctrl"
bind-key    -T fingers          C-c                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input exit"
bind-key    -T fingers          C-d                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:d:ctrl"
bind-key    -T fingers          C-e                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:e:ctrl"
bind-key    -T fingers          C-f                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:f:ctrl"
bind-key    -T fingers          C-g                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:g:ctrl"
bind-key    -T fingers          C-h                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:h:ctrl"
bind-key    -T fingers          C-j                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:j:ctrl"
bind-key    -T fingers          C-k                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:k:ctrl"
bind-key    -T fingers          C-l                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:l:ctrl"
bind-key    -T fingers          C-o                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:o:ctrl"
bind-key    -T fingers          C-p                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:p:ctrl"
bind-key    -T fingers          C-r                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:r:ctrl"
bind-key    -T fingers          C-s                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:s:ctrl"
bind-key    -T fingers          C-t                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:t:ctrl"
bind-key    -T fingers          C-u                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:u:ctrl"
bind-key    -T fingers          C-v                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:v:ctrl"
bind-key    -T fingers          C-w                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:w:ctrl"
bind-key    -T fingers          C-x                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:x:ctrl"
bind-key    -T fingers          C-y                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:y:ctrl"
bind-key    -T fingers          C-z                       run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers send-input hint:z:ctrl"
bind-key    -T git-mode         .                         run-shell "workmux last-done"
bind-key    -T git-mode         ?                         run-shell "${HOME}/.config/tmux/scripts/popup/help/help.sh git-mode"
bind-key    -T git-mode         P                         display-popup -E -h "80%" -w "80%" ${HOME}/.config/tmux/scripts/git/pr-checkout.sh
bind-key    -T git-mode         R                         run-shell "workmux resurrect"
bind-key    -T git-mode         a                         display-popup -E -h "90%" -w "95%" "workmux dashboard"
bind-key    -T git-mode         b                         run-shell "workmux sidebar"
bind-key    -T git-mode         c                         display-popup -E -h "80%" -w "80%" "${HOME}/.config/tmux/scripts/git/git-worktree.sh create"
bind-key    -T git-mode         d                         display-popup -E -h "80%" -w "80%" "${HOME}/.config/tmux/scripts/git/git-worktree.sh delete"
bind-key    -T git-mode         i                         display-popup -E -h "80%" -w "90%" "workmux status --git | less -RX"
bind-key    -T git-mode         l                         run-shell "#{@tpad-path} toggle worktree-logs"
bind-key    -T git-mode         m                         run-shell "zsh ~/.config/tmux/scripts/worktree-manager.sh --launch"
bind-key    -T git-mode         o                         display-popup -E -h "90%" -w "95%" "workmux dashboard --tab worktrees"
bind-key    -T git-mode         p                         display-popup -E -h "80%" -w "90%" "workmux list --pr | less -RX"
bind-key    -T git-mode         q                         switch-client -T root
bind-key    -T git-mode         r                         display-popup -E -h "90%" -w "95%" "workmux dashboard --diff"
bind-key    -T git-mode         s                         display-popup -E -h "80%" -w "80%" "${HOME}/.config/tmux/scripts/git/git-worktree.sh switch"
bind-key    -T git-mode         t                         run-shell "workmux last-agent"
bind-key    -T git-mode         v                         display-popup -E -h "80%" -w "90%" "workmux list | less -RX"
bind-key    -T git-mode         w                         display-popup -E -h "80%" -w "80%" ${HOME}/.config/tmux/scripts/git/git-worktree.sh
bind-key    -T git-mode         x                         new-window -c "#{pane_current_path}" -n wm-palette ${HOME}/.config/tmux/scripts/popup/workmux-palette.sh
bind-key    -T layout-mode      ?                         run-shell "${HOME}/.config/tmux/scripts/popup/help/help.sh layout-mode"
bind-key    -T layout-mode      E                         run-shell "\nf=$(mktemp /tmp/tmux-edit.XXXXXX) &&   tmux capture-pane -S - -p -J > \$f &&   tmux new-window -c '#{pane_current_path}'     -n 'hist-#{session_name}:#{window_index}.#{pane_index}'     \"sh -c 'trap \\\"rm -f \$f\\\" EXIT; nvim \$f'\"\n"
bind-key    -T layout-mode      H                         split-window -dh -c "#{pane_current_path}"
bind-key    -T layout-mode      e                         run-shell "\nf=$(mktemp /tmp/tmux-edit.XXXXXX) &&   tmux capture-pane -S 0 -p -J > \$f &&   tmux new-window -c '#{pane_current_path}'     -n 'hist-#{session_name}:#{window_index}.#{pane_index}'     \"sh -c 'trap \\\"rm -f \$f\\\" EXIT; nvim \$f'\"\n"
bind-key    -T layout-mode      g                         display-popup -E -h "70%" -w "60%" ${HOME}/.config/tmux/scripts/git-pull-merge.sh
bind-key    -T layout-mode      h                         split-window -bh -c "#{pane_current_path}" -p 40
bind-key    -T layout-mode      j                         split-window -c "#{pane_current_path}" -p 30
bind-key    -T layout-mode      k                         split-window -b -c "#{pane_current_path}" -p 30
bind-key    -T layout-mode      l                         split-window -h -c "#{pane_current_path}" -p 40
bind-key    -T layout-mode      m                         display-popup -E -h "90%" -w "90%" ${HOME}/.config/tmux/scripts/doc-finder.sh
bind-key    -T layout-mode      n                         command-prompt -I '' -p "window name:" "new-window -c '#{pane_current_path}' -n '%1'"
bind-key    -T layout-mode      q                         kill-pane -t "#{bottom}"
bind-key    -T layout-mode      v                         split-window -d -c "#{pane_current_path}"
bind-key    -T layout-mode      x                         display-popup -E -h "80%" -w "80%" ${HOME}/.config/tmux/scripts/kill-process.sh
bind-key    -T layout-mode      C-b                       set-option status
bind-key    -T layout-mode      C-o                       run-shell "tmux neww tsnv"
bind-key    -T monitor-mode     ?                         run-shell "${HOME}/.config/tmux/scripts/popup/help/help.sh monitor-mode"
bind-key    -T monitor-mode     b                         run-shell "#{@tpad-path} toggle process-viewer"
bind-key    -T monitor-mode     q                         switch-client -T root
bind-key    -T move             ,                         if-shell -F "#{pane_floating_flag}" { display-menu -T "#[align=centre]Move" -x P -y P Centre c { move-pane -P centre } '' "Top Left" 1 { move-pane -P top-left } "Top Right" 2 { move-pane -P top-right } "Bottom Left" 3 { move-pane -P bottom-left } "Bottom Right" 4 { move-pane -P bottom-right } '' Top t { move-pane -P top-centre } Bottom b { move-pane -P bottom-centre } Left l { move-pane -P centre-left } Right r { move-pane -P centre-right } }
bind-key    -T move             .                         if-shell -F "#{pane_floating_flag}" { display-menu -T "#[align=centre]Move & Resize" -x P -y P Fill 0 { resize-pane -x "100%" -y "100%" ; move-pane -P top-left } '' "Top Left" 1 { resize-pane -x "50%" -y "50%" ; move-pane -P top-left } "Top Right" 2 { resize-pane -x "50%" -y "50%" ; move-pane -P top-right } "Bottom Left" 3 { resize-pane -x "50%" -y "50%" ; move-pane -P bottom-left } "Bottom Right" 4 { resize-pane -x "50%" -y "50%" ; move-pane -P bottom-right } '' Top t { resize-pane -x "100%" -y "50%" ; move-pane -P top-centre } Bottom b { resize-pane -x "100%" -y "50%" ; move-pane -P bottom-centre } Left l { resize-pane -x "50%" -y "100%" ; move-pane -P centre-left } Right r { resize-pane -x "50%" -y "100%" ; move-pane -P centre-right } }
bind-key    -T move             0                         resize-pane -x "100%" -y "100%" \; move-pane -P top-left
bind-key    -T move             1                         move-pane -P top-left
bind-key    -T move             2                         move-pane -P top-right
bind-key    -T move             3                         move-pane -P bottom-left
bind-key    -T move             4                         move-pane -P bottom-right
bind-key    -T move             Up                        move-pane -P top-centre
bind-key    -T move             Down                      move-pane -P bottom-centre
bind-key    -T move             Left                      move-pane -P centre-left
bind-key    -T move             Right                     move-pane -P centre-right
bind-key    -T move             M-1                       resize-pane -x "50%" -y "50%" \; move-pane -P top-left
bind-key    -T move             M-2                       resize-pane -x "50%" -y "50%" \; move-pane -P top-right
bind-key    -T move             M-3                       resize-pane -x "50%" -y "50%" \; move-pane -P bottom-left
bind-key    -T move             M-4                       resize-pane -x "50%" -y "50%" \; move-pane -P bottom-right
bind-key    -T move             M-Up                      resize-pane -x "100%" -y "50%" \; move-pane -P top-centre
bind-key    -T move             M-Down                    resize-pane -x "100%" -y "50%" \; move-pane -P bottom-centre
bind-key    -T move             M-Left                    resize-pane -x "50%" -y "100%" \; move-pane -P centre-left
bind-key    -T move             M-Right                   resize-pane -x "50%" -y "100%" \; move-pane -P centre-right
bind-key    -T prefix           Tab                       last-window
bind-key    -T prefix           Enter                     copy-mode
bind-key    -T prefix           Space                     next-layout
bind-key    -T prefix           !                         break-pane
bind-key    -T prefix           \"                        split-window -c "#{pane_current_path}"
bind-key    -T prefix           \#                        list-buffers
bind-key    -T prefix           \$                        command-prompt -I "#S" { rename-session "%%" }
bind-key    -T prefix           \%                        split-window -h -c "#{pane_current_path}"
bind-key    -T prefix           &                         confirm-before -p "kill-window #W? (y/n)" kill-window
bind-key    -T prefix           \'                        command-prompt -p index { select-window -t ":%%" }
bind-key    -T prefix           (                         switch-client -p
bind-key    -T prefix           )                         switch-client -n
bind-key    -T prefix           *                         new-pane
bind-key    -T prefix           +                         run-shell "cut -c3- '#{TMUX_CONF}' | sh -s _maximize_pane '#{session_name}' '#D'"
bind-key    -T prefix           ,                         command-prompt -I "#W" { rename-window "%%" }
bind-key    -T prefix           -                         split-window -v -c "#{pane_current_path}"
bind-key    -T prefix           .                         command-prompt { move-window -t "%%" }
bind-key    -T prefix           /                         run-shell "${HOME}/.config/tmux/scripts/popup/help/help.sh global"
bind-key    -T prefix           0                         select-window -t :=0
bind-key    -T prefix           1                         select-window -t :=1
bind-key    -T prefix           2                         select-window -t :=2
bind-key    -T prefix           3                         select-window -t :=3
bind-key    -T prefix           4                         select-window -t :=4
bind-key    -T prefix           5                         select-window -t :=5
bind-key    -T prefix           6                         select-window -t :=6
bind-key    -T prefix           7                         select-window -t :=7
bind-key    -T prefix           8                         select-window -t :=8
bind-key    -T prefix           9                         select-window -t :=9
bind-key    -T prefix           :                         command-prompt
bind-key    -T prefix           \;                        last-pane
bind-key    -T prefix           <                         swap-pane -U
bind-key    -T prefix           =                         choose-buffer -Z
bind-key    -T prefix           >                         swap-pane -D
bind-key -r -T prefix           ?                         run-shell ${HOME}/.config/tmux/scripts/popup/search-keybindings.sh
bind-key    -T prefix           @                         if-shell -F "#{pane_floating_flag}" { join-pane } { break-pane -W }
bind-key    -T prefix           A                         switch-client -T ask-tools
bind-key    -T prefix           B                         display-popup -BE -h "100%" -w "100%" -x "0%" -y "0%" ${HOME}/.tmux/plugins/back-in-5/scripts/main.sh
bind-key    -T prefix           C                         customize-mode -Z
bind-key    -T prefix           D                         run-shell "#{@tpad-path} toggle lazydocker"
bind-key    -T prefix           E                         select-layout -E
bind-key    -T prefix           F                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers start #{pane_id} >>${HOME}/.local/share/tmux-fingers/fingers.log 2>&1"
bind-key    -T prefix           G                         run-shell "#{@tpad-path} toggle gh-dash"
bind-key -r -T prefix           H                         resize-pane -L 2
bind-key    -T prefix           I                         run-shell ${HOME}/.tmux/plugins/tpm/bindings/install_plugins
bind-key    -T prefix           J                         run-shell -b "${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers start --mode jump #{pane_id} >>${HOME}/.local/share/tmux-fingers/fingers.log 2>&1"
bind-key -r -T prefix           K                         resize-pane -U 2
bind-key -r -T prefix           L                         resize-pane -R 2
bind-key    -T prefix           M                         select-pane -M
bind-key    -T prefix           N                         run-shell "tmux neww ~/.config/tmux/scripts/tmux-sessionizer.sh"
bind-key    -T prefix           P                         choose-buffer
bind-key    -T prefix           R                         run-shell " \t\t\ttmux source-file ${HOME}/.tmux.conf > /dev/null; \t\t\ttmux display-message 'Sourced ${HOME}/.tmux.conf!'"
bind-key    -T prefix           S                         run-shell "sesh last"
bind-key    -T prefix           T                         command-prompt -I "#T" { select-pane -T "%%" }
bind-key    -T prefix           U                         run-shell "tmux neww ~/.config/tmux/scripts/tmuxinator-sessionizer.sh"
bind-key    -T prefix           X                         run-shell "tmux switch-client -n \\; kill-session -t \"$(tmux display-message -p \"#S\")\" || tmux kill-session"
bind-key    -T prefix           Y                         run-shell -b ${HOME}/.tmux/plugins/tmux-yank/scripts/copy_pane_pwd.sh
bind-key    -T prefix           [                         copy-mode
bind-key    -T prefix           \\                        split-window -h -c "#{pane_current_path}"
bind-key    -T prefix           ]                         paste-buffer -p
bind-key    -T prefix           _                         split-window -h -c "#{pane_current_path}"
bind-key    -T prefix           a                         last-window
bind-key    -T prefix           b                         list-buffers
bind-key    -T prefix           c                         new-window -c "#{pane_current_path}"
bind-key    -T prefix           d                         detach-client
bind-key    -T prefix           e                         display-popup -E -S "fg=#0050a4,border-lines=rounded" -e TMUX_EXPOSE_TOGGLE_KEY=e -h "100%" -s "bg=#0d3a58" -w "100%" "tmux-expose --selected-color \\#ffc600 --attached-color \\#5fff00 --inactive-color \\#8a8a8a"
bind-key    -T prefix           f                         command-prompt { find-window -Z "%%" }
bind-key    -T prefix           g                         run-shell "#{@tpad-path} toggle lazygit"
bind-key -r -T prefix           h                         select-pane -L
bind-key    -T prefix           i                         display-message
bind-key    -T prefix           j                         command-prompt -p "join pane from: " "join-pane -h -s '%%'"
bind-key -r -T prefix           k                         select-pane -U
bind-key -r -T prefix           l                         select-pane -R
bind-key    -T prefix           m                         run-shell "cut -c3- '#{TMUX_CONF}' | sh -s _toggle_mouse"
bind-key    -T prefix           n                         break-pane -d
bind-key    -T prefix           o                         if-shell "[ \"#{@sesh-wide}\" = \"on\" ] || [ \"#{pane_width}\" -lt \"#{pane_height}\" ]" "display-popup -E -w 90% -h 70% \"~/.config/tmux/scripts/sesh/fzf.sh\"" "display-popup -E -w 50% -h 70% \"~/.config/tmux/scripts/sesh/fzf.sh\""
bind-key    -T prefix           p                         run-shell "#{@tpad-path} toggle process-viewer"
bind-key    -T prefix           q                         display-panes \; command-prompt -p "pane #: " "swap-pane -t '%%'"
bind-key    -T prefix           r                         run-shell "sh -c '\"\$TMUX_PROGRAM\" \${TMUX_SOCKET:+-S \"\$TMUX_SOCKET\"} source \"\$TMUX_CONF\"'" \; display-message "#{TMUX_CONF} sourced"
bind-key    -T prefix           s                         choose-tree -Zs
bind-key    -T prefix           t                         run-shell "#{@tpad-path} toggle grimoire"
bind-key    -T prefix           u                         run-shell ${HOME}/.tmux/plugins/tpm/bindings/update_plugins
bind-key    -T prefix           w                         choose-tree -Zw
bind-key    -T prefix           x                         kill-pane
bind-key    -T prefix           y                         run-shell -b ${HOME}/.tmux/plugins/tmux-yank/scripts/copy_line.sh
bind-key    -T prefix           z                         resize-pane -Z
bind-key    -T prefix           \{                        swap-pane -U
bind-key    -T prefix           \}                        swap-pane -D
bind-key    -T prefix           \~                        show-messages
bind-key -r -T prefix           DC                        refresh-client -c
bind-key    -T prefix           PPage                     copy-mode -u
bind-key    -T prefix           BTab                      switch-client -l
bind-key -r -T prefix           Up                        select-pane -U
bind-key -r -T prefix           Down                      select-pane -D
bind-key -r -T prefix           Left                      select-pane -L
bind-key -r -T prefix           Right                     select-pane -R
bind-key    -T prefix           M-1                       select-layout even-horizontal
bind-key    -T prefix           M-2                       select-layout even-vertical
bind-key    -T prefix           M-3                       select-layout main-horizontal
bind-key    -T prefix           M-4                       select-layout main-vertical
bind-key    -T prefix           M-5                       select-layout tiled
bind-key    -T prefix           M-6                       select-layout main-horizontal-mirrored
bind-key    -T prefix           M-7                       select-layout main-vertical-mirrored
bind-key    -T prefix           M-n                       next-window -a
bind-key    -T prefix           M-o                       rotate-window -D
bind-key    -T prefix           M-p                       previous-window -a
bind-key    -T prefix           M-u                       run-shell ${HOME}/.tmux/plugins/tpm/bindings/clean_plugins
bind-key -r -T prefix           M-Up                      if-shell -F "#{?floating_pane_flag}" { resize-pane -D -5 } { resize-pane -U 5 }
bind-key -r -T prefix           M-Down                    resize-pane -D 5
bind-key -r -T prefix           M-Left                    if-shell -F "#{?floating_pane_flag}" { resize-pane -R -5 } { resize-pane -L 5 }
bind-key -r -T prefix           M-Right                   resize-pane -R 5
bind-key    -T prefix           C-a                       send-prefix
bind-key    -T prefix           C-b                       switch-client -T second-brain
bind-key    -T prefix           C-c                       new-session
bind-key    -T prefix           C-d                       switch-client -T dev-mode
bind-key    -T prefix           C-e                       run-shell "${HOME}/.tmux/plugins/tmux-tpad/tpad.tmux eject"
bind-key    -T prefix           C-f                       switch-client -T file-picker-mode
bind-key    -T prefix           C-g                       switch-client -T git-mode
bind-key    -T prefix           C-h                       send-keys C-h
bind-key    -T prefix           C-i                       switch-client -T ai-tools
bind-key    -T prefix           C-j                       send-keys C-j
bind-key    -T prefix           C-k                       send-keys C-k
bind-key    -T prefix           C-l                       send-keys C-l
bind-key    -T prefix           C-m                       switch-client -T monitor-mode
bind-key    -T prefix           C-n                       next-window
bind-key    -T prefix           C-o                       if-shell "[ \"#{@sesh-wide}\" = \"on\" ] || [ \"#{pane_width}\" -lt \"#{pane_height}\" ]" "display-popup -E -w 90% -h 70% \"~/.config/tmux/scripts/sesh/gum.sh\"" "display-popup -E -w 50% -h 70% \"~/.config/tmux/scripts/sesh/gum.sh\""
bind-key    -T prefix           C-p                       previous-window
bind-key    -T prefix           C-q                       switch-client -T quick-ref
bind-key    -T prefix           C-s                       run-shell "${HOME}/.tmux/plugins/tome/tome-open-playbook -s"
bind-key    -T prefix           C-t                       run-shell ${HOME}/.tmux/plugins/tome/tome-open-playbook
bind-key    -T prefix           C-u                       run-shell "${HOME}/.tmux/plugins/tmux-tpad/tpad.tmux fullscreen"
bind-key    -T prefix           C-w                       switch-client -T work-sessions
bind-key    -T prefix           C-z                       suspend-client
bind-key -r -T prefix           C-Up                      if-shell -F "#{?floating_pane_flag}" { resize-pane -D -1 } { resize-pane -U -- }
bind-key -r -T prefix           C-Down                    resize-pane -D --
bind-key -r -T prefix           C-Left                    if-shell -F "#{?floating_pane_flag}" { resize-pane -R -1 } { resize-pane -L -- }
bind-key -r -T prefix           C-Right                   resize-pane -R --
bind-key -r -T prefix           S-Up                      refresh-client -U 10
bind-key -r -T prefix           S-Down                    refresh-client -D 10
bind-key -r -T prefix           S-Left                    refresh-client -L 10
bind-key -r -T prefix           S-Right                   refresh-client -R 10
bind-key -r -T prefix           C-S-H                     swap-window -t -1 \; select-window -t -1
bind-key -r -T prefix           C-S-L                     swap-window -t +1 \; select-window -t +1
bind-key    -T quick-ref        ?                         run-shell "${HOME}/.config/tmux/scripts/popup/help/help.sh quick-ref"
bind-key    -T quick-ref        c                         run-shell "#{@tpad-path} toggle cht-sh"
bind-key    -T quick-ref        g                         run-shell "#{@tpad-path} toggle git-help"
bind-key    -T quick-ref        m                         run-shell "#{@tpad-path} toggle manpage"
bind-key    -T quick-ref        q                         switch-client -T root
bind-key    -T quick-ref        r                         run-shell "#{@tpad-path} toggle regex-test"
bind-key    -T root             MouseDown1Pane            select-pane -t = \; send-keys -M
bind-key    -T root             MouseDown1Status          switch-client -t =
bind-key    -T root             MouseDown1Border          select-pane -t =
bind-key    -T root             MouseDown1ScrollbarUp     if-shell -F -t = "#{pane_in_mode}" { send-keys -X page-up } { copy-mode -u }
bind-key    -T root             MouseDown1ScrollbarDown   if-shell -F -t = "#{pane_in_mode}" { send-keys -X page-down } { copy-mode -d }
bind-key    -T root             MouseDown1Control7        if-shell -F -t = "#{pane_floating_flag}" { join-pane } { break-pane -W }
bind-key    -T root             MouseDown1Control8        resize-pane -Z
bind-key    -T root             MouseDown1Control9        display-menu -O -T "Kill pane #{pane_index}?" -t = -x M -y M Yes y { kill-pane -t = } No n {  }
bind-key    -T root             MouseDown2Pane            select-pane -t = \; if-shell -F "#{||:#{pane_in_mode},#{mouse_any_flag}}" { send-keys -M } { paste-buffer -p }
bind-key    -T root             MouseDown3Pane            if-shell -F -t = "#{||:#{mouse_any_flag},#{&&:#{pane_in_mode},#{?#{m/r:(copy|view)-mode,#{pane_mode}},0,1}}}" { select-pane -t = ; send-keys -M } { display-menu -T "#[align=centre]#{pane_index} (#{pane_id})" -t = -x M -y M "#{?#{m/r:(copy|view)-mode,#{pane_mode}},Go To Top,}" < { send-keys -X history-top } "#{?#{m/r:(copy|view)-mode,#{pane_mode}},Go To Bottom,}" > { send-keys -X history-bottom } '' "#{?#{==:#{pane_mode},copy-mode},#{?copy_line_numbers,Hide Line Numbers,Show Line Numbers},}" L { send-keys -X line-numbers-toggle } "#{?#{==:#{pane_mode},copy-mode},#{?refresh_active,Refresh Off,Refresh On},}" r { send-keys -X refresh-toggle } '' "#{?#{&&:#{buffer_size},#{!:#{pane_in_mode}}},Paste #[underscore]#{=/9/...:buffer_sample},}" p { paste-buffer } '' "#{?mouse_word,Search For #[underscore]#{=/9/...:mouse_word},}" C-r { if-shell -F "#{?#{m/r:(copy|view)-mode,#{pane_mode}},0,1}" "copy-mode -t=" ; send-keys -X -t = search-backward -- "#{q:mouse_word}" } "#{?mouse_word,Type #[underscore]#{=/9/...:mouse_word},}" C-y { copy-mode -q ; send-keys -l "#{q:mouse_word}" } "#{?mouse_word,Copy #[underscore]#{=/9/...:mouse_word},}" c { copy-mode -q ; set-buffer "#{q:mouse_word}" } "#{?mouse_line,Copy Line,}" l { copy-mode -q ; set-buffer "#{q:mouse_line}" } '' "#{?mouse_hyperlink,Type #[underscore]#{=/9/...:mouse_hyperlink},}" C-h { copy-mode -q ; send-keys -l "#{q:mouse_hyperlink}" } "#{?mouse_hyperlink,Copy #[underscore]#{=/9/...:mouse_hyperlink},}" h { copy-mode -q ; set-buffer "#{q:mouse_hyperlink}" } '' "#{?#{#{pane_floating_flag}},Move,}" '' { display-menu -T "#[align=centre]Move" -x L -y L Centre c { move-pane -P centre } '' "Top Left" 1 { move-pane -P top-left } "Top Right" 2 { move-pane -P top-right } "Bottom Left" 3 { move-pane -P bottom-left } "Bottom Right" 4 { move-pane -P bottom-right } '' Top t { move-pane -P top-centre } Bottom b { move-pane -P bottom-centre } Left l { move-pane -P centre-left } Right r { move-pane -P centre-right } } "#{?#{#{pane_floating_flag}},Move & Resize,}" '' { display-menu -T "#[align=centre]Move & Resize" -x L -y L Fill 0 { resize-pane -x "100%" -y "100%" ; move-pane -P top-left } '' "Top Left" 1 { resize-pane -x "50%" -y "50%" ; move-pane -P top-left } "Top Right" 2 { resize-pane -x "50%" -y "50%" ; move-pane -P top-right } "Bottom Left" 3 { resize-pane -x "50%" -y "50%" ; move-pane -P bottom-left } "Bottom Right" 4 { resize-pane -x "50%" -y "50%" ; move-pane -P bottom-right } '' Top t { resize-pane -x "100%" -y "50%" ; move-pane -P top-centre } Bottom b { resize-pane -x "100%" -y "50%" ; move-pane -P bottom-centre } Left l { resize-pane -x "50%" -y "100%" ; move-pane -P centre-left } Right r { resize-pane -x "50%" -y "100%" ; move-pane -P centre-right } } "#{?#{#{pane_floating_flag}},Tile,}" t { join-pane } "#{?#{!:#{pane_floating_flag}},Float,}" f { break-pane -W } "#{?#{!:#{pane_floating_flag}},Horizontal Split,}" h { split-window -h -c "#{pane_current_path}" } "#{?#{!:#{pane_floating_flag}},Vertical Split,}" v { split-window -v -c "#{pane_current_path}" } '' "#{?#{&&:#{!:#{pane_floating_flag}},#{>:#{window_panes},1}},Swap Up,}" u { swap-pane -U } "#{?#{&&:#{!:#{pane_floating_flag}},#{>:#{window_panes},1}},Swap Down,}" d { swap-pane -D } "#{?pane_marked_set,,-}Swap Marked" s { swap-pane } '' Kill X { kill-pane } Respawn R { respawn-pane -k } "#{?pane_marked,Unmark,Mark}" m { select-pane -m } "#{?#{>:#{window_panes},1},,-}#{?window_zoomed_flag,Unzoom,Zoom}" z { resize-pane -Z } }
bind-key    -T root             MouseDown3Status          display-menu -T "#[align=centre]#{window_index}:#{window_name}" -t = -x W -y W "#{?#{>:#{session_windows},1},,-}Swap Left" l { swap-window -t :-1 } "#{?#{>:#{session_windows},1},,-}Swap Right" r { swap-window -t :+1 } "#{?pane_marked_set,,-}Swap Marked" s { swap-window } '' Kill X { kill-window } Respawn R { respawn-window -k } "#{?pane_marked,Unmark,Mark}" m { select-pane -m } Rename n { command-prompt -F -I "#W" { rename-window -t "#{window_id}" "%%" } } '' "New After" w { new-window -a -c "#{pane_current_path}" } "New At End" W { new-window -c "#{pane_current_path}" }
bind-key    -T root             MouseDown3StatusLeft      run-shell -C "display-menu -t= -xM -yW -T '#[align=centre]#{session_name}'  #{S/t:#{?#{&&:#{<:#{loop_index},6},#{!:#{session_active}}},'Switch To #[underscore]#{session_name}' '' {switch-client -t=#{session_id}#} ,}} '' 'Renumber' 'N' {move-window -r} 'Rename' 'r' {command-prompt -I '#S' {rename-session -- '%%'}} 'Detach' 'd' {detach-client} '' 'New Session' 's' {new-session} 'New Window' 'w' {{{{{{{{{{{new-window -c '#{pane_current_path}'}}}}}}}}}}}"
bind-key    -T root             MouseDown3Empty           display-menu -T "#[align=centre]#{window_index}:#{window_name}" -t = -x M -y M "New Pane" p { new-pane ; join-pane } "New Window" w { new-window -c "#{pane_current_path}" }
bind-key    -T root             MouseDrag1Pane            if-shell -F "#{||:#{pane_in_mode},#{mouse_any_flag}}" { send-keys -M } { copy-mode -M }
bind-key    -T root             MouseDrag1Border          resize-pane -M
bind-key    -T root             MouseDrag1ScrollbarSlider if-shell -F -t = "#{pane_in_mode}" { send-keys -X scroll-to-mouse } { copy-mode -S }
bind-key    -T root             WheelDownPane             if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "         if -Ft= \"\"           \"send-keys -t= down ; send-keys -t= down ; send-keys -t= down ; \"           \"select-pane -t= ; send-keys -M ; send-keys -M ; send-keys -M ; \"       "
bind-key    -T root             WheelDownStatus           next-window
bind-key    -T root             WheelUpPane               if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "         if -Ft= ''           \"send-keys -t= up ; send-keys -t= up ; send-keys -t= up ; \"           \"             select-pane -t= ;             if -Ft= '#{pane_in_mode}'               'send-keys -M ; send-keys -M ; send-keys -M ; '               'copy-mode -e ; send-keys -M ; send-keys -M ; send-keys -M ; '           \"       "
bind-key    -T root             WheelUpStatus             previous-window
bind-key    -T root             DoubleClick1Pane          select-pane -t = \; if-shell -F "#{||:#{pane_in_mode},#{mouse_any_flag}}" { send-keys -M } { copy-mode -H ; send-keys -X select-word ; run-shell -d 0.3 ; send-keys -X copy-pipe-and-cancel "xsel -i -b" }
bind-key    -T root             TripleClick1Pane          select-pane -t = \; if-shell -F "#{||:#{pane_in_mode},#{mouse_any_flag}}" { send-keys -M } { copy-mode -H ; send-keys -X select-line ; run-shell -d 0.3 ; send-keys -X copy-pipe-and-cancel "xsel -i -b" }
bind-key    -T root             M-,                       run-shell "${HOME}/.tmux/plugins/tmux-jumplist/scripts/jumplist.sh back"
bind-key    -T root             M-.                       run-shell "${HOME}/.tmux/plugins/tmux-jumplist/scripts/jumplist.sh forward"
bind-key    -T root             M-[                       switch-client -p
bind-key    -T root             M-]                       switch-client -n
bind-key    -T root             M-e                       display-popup -E -h "90%" -w "90%" "  f=$(mktemp /tmp/tmux-pane-XXXXXX);   SCROLL=$(tmux display-message -p '#{scroll_position}');   LINES=$(tmux capture-pane -p -S - | wc -l);   LINE=$((LINES - SCROLL));   tmux capture-pane -p -S - > \$f;   nvim +'set binary noeol' +\${LINE} \$f;   rm -f \$f"
bind-key    -T root             M-MouseDown3Pane          display-menu -T "#[align=centre]#{pane_index} (#{pane_id})" -t = -x M -y M "#{?#{m/r:(copy|view)-mode,#{pane_mode}},Go To Top,}" < { send-keys -X history-top } "#{?#{m/r:(copy|view)-mode,#{pane_mode}},Go To Bottom,}" > { send-keys -X history-bottom } '' "#{?#{==:#{pane_mode},copy-mode},#{?copy_line_numbers,Hide Line Numbers,Show Line Numbers},}" L { send-keys -X line-numbers-toggle } "#{?#{==:#{pane_mode},copy-mode},#{?refresh_active,Refresh Off,Refresh On},}" r { send-keys -X refresh-toggle } '' "#{?#{&&:#{buffer_size},#{!:#{pane_in_mode}}},Paste #[underscore]#{=/9/...:buffer_sample},}" p { paste-buffer } '' "#{?mouse_word,Search For #[underscore]#{=/9/...:mouse_word},}" C-r { if-shell -F "#{?#{m/r:(copy|view)-mode,#{pane_mode}},0,1}" "copy-mode -t=" ; send-keys -X -t = search-backward -- "#{q:mouse_word}" } "#{?mouse_word,Type #[underscore]#{=/9/...:mouse_word},}" C-y { copy-mode -q ; send-keys -l "#{q:mouse_word}" } "#{?mouse_word,Copy #[underscore]#{=/9/...:mouse_word},}" c { copy-mode -q ; set-buffer "#{q:mouse_word}" } "#{?mouse_line,Copy Line,}" l { copy-mode -q ; set-buffer "#{q:mouse_line}" } '' "#{?mouse_hyperlink,Type #[underscore]#{=/9/...:mouse_hyperlink},}" C-h { copy-mode -q ; send-keys -l "#{q:mouse_hyperlink}" } "#{?mouse_hyperlink,Copy #[underscore]#{=/9/...:mouse_hyperlink},}" h { copy-mode -q ; set-buffer "#{q:mouse_hyperlink}" } '' "#{?#{#{pane_floating_flag}},Move,}" '' { display-menu -T "#[align=centre]Move" -x L -y L Centre c { move-pane -P centre } '' "Top Left" 1 { move-pane -P top-left } "Top Right" 2 { move-pane -P top-right } "Bottom Left" 3 { move-pane -P bottom-left } "Bottom Right" 4 { move-pane -P bottom-right } '' Top t { move-pane -P top-centre } Bottom b { move-pane -P bottom-centre } Left l { move-pane -P centre-left } Right r { move-pane -P centre-right } } "#{?#{#{pane_floating_flag}},Move & Resize,}" '' { display-menu -T "#[align=centre]Move & Resize" -x L -y L Fill 0 { resize-pane -x "100%" -y "100%" ; move-pane -P top-left } '' "Top Left" 1 { resize-pane -x "50%" -y "50%" ; move-pane -P top-left } "Top Right" 2 { resize-pane -x "50%" -y "50%" ; move-pane -P top-right } "Bottom Left" 3 { resize-pane -x "50%" -y "50%" ; move-pane -P bottom-left } "Bottom Right" 4 { resize-pane -x "50%" -y "50%" ; move-pane -P bottom-right } '' Top t { resize-pane -x "100%" -y "50%" ; move-pane -P top-centre } Bottom b { resize-pane -x "100%" -y "50%" ; move-pane -P bottom-centre } Left l { resize-pane -x "50%" -y "100%" ; move-pane -P centre-left } Right r { resize-pane -x "50%" -y "100%" ; move-pane -P centre-right } } "#{?#{#{pane_floating_flag}},Tile,}" t { join-pane } "#{?#{!:#{pane_floating_flag}},Float,}" f { break-pane -W } "#{?#{!:#{pane_floating_flag}},Horizontal Split,}" h { split-window -h -c "#{pane_current_path}" } "#{?#{!:#{pane_floating_flag}},Vertical Split,}" v { split-window -v -c "#{pane_current_path}" } '' "#{?#{&&:#{!:#{pane_floating_flag}},#{>:#{window_panes},1}},Swap Up,}" u { swap-pane -U } "#{?#{&&:#{!:#{pane_floating_flag}},#{>:#{window_panes},1}},Swap Down,}" d { swap-pane -D } "#{?pane_marked_set,,-}Swap Marked" s { swap-pane } '' Kill X { kill-pane } Respawn R { respawn-pane -k } "#{?pane_marked,Unmark,Mark}" m { select-pane -m } "#{?#{>:#{window_panes},1},,-}#{?window_zoomed_flag,Unzoom,Zoom}" z { resize-pane -Z }
bind-key    -T root             M-MouseDown3Status        display-menu -T "#[align=centre]#{window_index}:#{window_name}" -t = -x W -y W "#{?#{>:#{session_windows},1},,-}Swap Left" l { swap-window -t :-1 } "#{?#{>:#{session_windows},1},,-}Swap Right" r { swap-window -t :+1 } "#{?pane_marked_set,,-}Swap Marked" s { swap-window } '' Kill X { kill-window } Respawn R { respawn-window -k } "#{?pane_marked,Unmark,Mark}" m { select-pane -m } Rename n { command-prompt -F -I "#W" { rename-window -t "#{window_id}" "%%" } } '' "New After" w { new-window -a -c "#{pane_current_path}" } "New At End" W { new-window -c "#{pane_current_path}" }
bind-key    -T root             M-MouseDown3StatusLeft    run-shell -C "display-menu -t= -xM -yW -T '#[align=centre]#{session_name}'  #{S/t:#{?#{&&:#{<:#{loop_index},6},#{!:#{session_active}}},'Switch To #[underscore]#{session_name}' '' {switch-client -t=#{session_id}#} ,}} '' 'Renumber' 'N' {move-window -r} 'Rename' 'r' {command-prompt -I '#S' {rename-session -- '%%'}} 'Detach' 'd' {detach-client} '' 'New Session' 's' {new-session} 'New Window' 'w' {{{{{{{{{{{new-window -c '#{pane_current_path}'}}}}}}}}}}}"
bind-key    -T root             M-MouseDown3Empty         display-menu -T "#[align=centre]#{window_index}:#{window_name}" -t = -x M -y M "New Pane" p { new-pane ; join-pane } "New Window" w { new-window -c "#{pane_current_path}" }
bind-key    -T root             M-MouseDrag1Pane          move-pane -M
bind-key    -T root             M-MouseDrag1Border        move-pane -M
bind-key    -T root             C-b                       switch-client -T layout-mode
bind-key    -T root             C-h                       if-shell "ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?((n?vim|vim|view|nvim|vimdiff|nvimdiff)(diff)?)$'" "send-keys C-h" "select-pane -L"
bind-key    -T root             C-j                       if-shell "ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?((n?vim|vim|view|nvim|vimdiff|nvimdiff)(diff)?)$'" "send-keys C-j" "select-pane -D"
bind-key    -T root             C-k                       if-shell "ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?((n?vim|vim|view|nvim|vimdiff|nvimdiff)(diff)?)$'" "send-keys C-k" "select-pane -U"
bind-key    -T root             C-l                       if-shell "ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?((n?vim|vim|view|nvim|vimdiff|nvimdiff)(diff)?)$'" "send-keys C-l" "select-pane -R"
bind-key    -T root             C-MouseDown1Status        swap-window -t @
bind-key    -T root             C-MouseDrag1Pane          new-pane -M
bind-key    -T root             C-MouseDrag1Empty         new-pane -M
bind-key    -T second-brain     0                         new-window -c "#{pane_current_path}" "h=$(find /tmp -maxdepth 1 -name \"sb-cycle-helper-*\" 2>/dev/null | head -1); c=$(find /tmp -maxdepth 1 -name \"sb-cycle-*\" ! -name \"*-helper-*\" 2>/dev/null | head -1); echo \"Helper: \$h\"; echo \"Cycle: \$c\"; if [ -n \"\$h\" ] && [ -n \"\$c\" ]; then bash -x \"\$h\" \"\$c\" text; echo \"--- EXIT CODE: $? ---\"; else echo \"Temp files not found. Open C-a C-b f first, then press C-a C-b 0.\"; fi; echo \"\"; exec bash -i"
bind-key    -T second-brain     ?                         run-shell "${HOME}/.config/tmux/scripts/popup/help/help.sh second-brain"
bind-key    -T second-brain     D                         run-shell "#{@tpad-path} toggle daily-work-todo"
bind-key    -T second-brain     I                         run-shell "#{@tpad-path} toggle ai-journal"
bind-key    -T second-brain     J                         run-shell "#{@tpad-path} toggle journal-work"
bind-key    -T second-brain     N                         run-shell "#{@tpad-path} toggle notes-work"
bind-key    -T second-brain     S                         run-shell "#{@tpad-path} toggle scratch-work"
bind-key    -T second-brain     T                         run-shell "#{@tpad-path} toggle todos-work"
bind-key    -T second-brain     a                         display-popup -E -h "90%" -w "90%" "${HOME}/.config/tmux/scripts/popup/second-brain-search.sh text ai"
bind-key    -T second-brain     c                         display-popup -E -h "90%" -w "90%" "${HOME}/.config/tmux/scripts/popup/second-brain-search.sh file ai"
bind-key    -T second-brain     d                         run-shell "#{@tpad-path} toggle daily-personal-todo"
bind-key    -T second-brain     f                         display-popup -E -h "90%" -w "90%" "${HOME}/.config/tmux/scripts/popup/second-brain-search.sh text"
bind-key    -T second-brain     g                         display-popup -E -h "90%" -w "90%" "${HOME}/.config/tmux/scripts/popup/second-brain-search.sh file"
bind-key    -T second-brain     h                         display-popup -E -h "90%" -w "90%" "${HOME}/.config/tmux/scripts/popup/second-brain-search.sh file work"
bind-key    -T second-brain     i                         run-shell "#{@tpad-path} toggle ai-notes"
bind-key    -T second-brain     j                         run-shell "#{@tpad-path} toggle journal-personal"
bind-key    -T second-brain     k                         display-popup -E -h "90%" -w "90%" "${HOME}/.config/tmux/scripts/popup/second-brain-search.sh file personal"
bind-key    -T second-brain     l                         run-shell "#{@tpad-path} toggle backup-logs"
bind-key    -T second-brain     n                         run-shell "#{@tpad-path} toggle notes-personal"
bind-key    -T second-brain     p                         display-popup -E -h "90%" -w "90%" "${HOME}/.config/tmux/scripts/popup/second-brain-search.sh text personal"
bind-key    -T second-brain     q                         switch-client -T root
bind-key    -T second-brain     s                         run-shell "#{@tpad-path} toggle scratch-personal"
bind-key    -T second-brain     t                         run-shell "#{@tpad-path} toggle todos-personal"
bind-key    -T second-brain     w                         display-popup -E -h "90%" -w "90%" "${HOME}/.config/tmux/scripts/popup/second-brain-search.sh text work"
bind-key    -T spotify-mode     ?                         run-shell "${HOME}/.config/tmux/scripts/popup/help/help.sh spotify-mode"
bind-key    -T spotify-mode     d                         run-shell "${HOME}/.config/tmux/scripts/popup/spotify/spotify-action.sh volume-down"
bind-key    -T spotify-mode     n                         run-shell "${HOME}/.config/tmux/scripts/popup/spotify/spotify-action.sh next"
bind-key    -T spotify-mode     p                         run-shell "${HOME}/.config/tmux/scripts/popup/spotify/spotify-action.sh previous"
bind-key    -T spotify-mode     q                         switch-client -T root
bind-key    -T spotify-mode     s                         run-shell "${HOME}/.config/tmux/scripts/popup/spotify/spotify-action.sh play-pause"
bind-key    -T spotify-mode     u                         run-shell "${HOME}/.config/tmux/scripts/popup/spotify/spotify-action.sh volume-up"
bind-key    -T work-sessions    0                         display-popup -E -h "80%" -w "80%" "${HOME}/.config/tmux/scripts/work-sessions/work-sessions.sh 0"
bind-key    -T work-sessions    1                         display-popup -E -h "80%" -w "80%" "${HOME}/.config/tmux/scripts/work-sessions/work-sessions.sh 1"
bind-key    -T work-sessions    2                         display-popup -E -h "80%" -w "80%" "${HOME}/.config/tmux/scripts/work-sessions/work-sessions.sh 2"
bind-key    -T work-sessions    3                         display-popup -E -h "80%" -w "80%" "${HOME}/.config/tmux/scripts/work-sessions/work-sessions.sh 3"
bind-key    -T work-sessions    4                         display-popup -E -h "80%" -w "80%" "${HOME}/.config/tmux/scripts/work-sessions/work-sessions.sh 4"
bind-key    -T work-sessions    5                         display-popup -E -h "80%" -w "80%" "${HOME}/.config/tmux/scripts/work-sessions/work-sessions.sh 5"
bind-key    -T work-sessions    ?                         run-shell "${HOME}/.config/tmux/scripts/popup/help/help.sh work-sessions"
bind-key    -T work-sessions    k                         display-popup -E -h "80%" -w "80%" "${HOME}/.config/tmux/scripts/work-sessions/work-sessions.sh --kill"
bind-key    -T work-sessions    l                         display-popup -E -h "80%" -w "80%" "${HOME}/.config/tmux/scripts/work-sessions/work-sessions.sh --list"
bind-key    -T work-sessions    p                         display-popup -E -h "80%" -w "80%" ${HOME}/.config/tmux/scripts/work-sessions/work-sessions.sh
bind-key    -T work-sessions    q                         switch-client -T root
```

## Global session defaults

```text
@battery_charge 1
@battery_percentage "100%"
@battery_status ↑
@fingers-cli ${HOME}/.tmux/plugins/tmux-fingers/bin/tmux-fingers
@fingers-key F
@jumplist-cursor 0
@jumplist-key-back M-,
@jumplist-key-forward M-.
@jumplist-navigating 0
@sesh-wide on
@session-dots-active "● "
@session-dots-color "#ffc600"
@session-dots-inactive "○ "
@tmux-expose-attached-color "#5fff00"
@tmux-expose-border-style "fg=#0050a4,border-lines=rounded"
@tmux-expose-height "100%"
@tmux-expose-inactive-color "#8a8a8a"
@tmux-expose-key e
@tmux-expose-key-table prefix
@tmux-expose-selected-color "#ffc600"
@tmux-expose-style "bg=#0d3a58"
@tmux-expose-width "100%"
@tome_key C-t
@tome_playbook .playbook.md
@tome_scratch_key C-s
@tome_size "40%"
@tpad-ai-journal-border_lines rounded
@tpad-ai-journal-border_style "fg=#e4e4e4,bg=#193549"
@tpad-ai-journal-cmd "mkdir -p \$HOME/Projects/Personal/Github/ai-brain/journal/$(date +%Y/%m) && nvim \$HOME/Projects/Personal/Github/ai-brain/journal/$(date +%Y/%m/%d).md"
@tpad-ai-journal-height "90%"
@tpad-ai-journal-style "fg=#00AAFF"
@tpad-ai-journal-title " AI Journal "
@tpad-ai-journal-width "90%"
@tpad-ai-notes-border_lines rounded
@tpad-ai-notes-border_style "fg=#e4e4e4,bg=#193549"
@tpad-ai-notes-cmd "nvim ${HOME}/Projects/Personal/Github/ai-brain/notes/inbox.md"
@tpad-ai-notes-height "90%"
@tpad-ai-notes-style "fg=#00AAFF"
@tpad-ai-notes-title " AI Notes "
@tpad-ai-notes-width "90%"
@tpad-backup-logs-border_lines rounded
@tpad-backup-logs-border_style "fg=#e4e4e4,bg=#193549"
@tpad-backup-logs-cmd "nvim \$HOME/.local/share/backup-logs/"
@tpad-backup-logs-height "90%"
@tpad-backup-logs-style "fg=#00AAFF"
@tpad-backup-logs-title " Backup Logs "
@tpad-backup-logs-width "90%"
@tpad-bind-fullscreen C-u
@tpad-cht-sh-border_lines rounded
@tpad-cht-sh-border_style "fg=#e4e4e4,bg=#193549"
@tpad-cht-sh-cmd ${HOME}/.config/tmux/scripts/cht-sh/cht.sh
@tpad-cht-sh-height "90%"
@tpad-cht-sh-style "fg=#00AAFF"
@tpad-cht-sh-title " Cht.sh "
@tpad-cht-sh-width "90%"
@tpad-daily-personal-todo-border_lines rounded
@tpad-daily-personal-todo-border_style "fg=#e4e4e4,bg=#193549"
@tpad-daily-personal-todo-cmd "nvim \$HOME/Projects/Personal/Github/second-brain/daily/agenda/daily/$(date +%Y-%m-%d).org"
@tpad-daily-personal-todo-height "90%"
@tpad-daily-personal-todo-style "fg=#00AAFF"
@tpad-daily-personal-todo-title " Daily Personal Todos "
@tpad-daily-personal-todo-width "90%"
@tpad-daily-work-todo-border_lines rounded
@tpad-daily-work-todo-border_style "fg=#e4e4e4,bg=#193549"
@tpad-daily-work-todo-cmd "nvim \$HOME/Projects/Work/Github/second-brain/agenda/daily/$(date +%Y-%m-%d).org"
@tpad-daily-work-todo-height "90%"
@tpad-daily-work-todo-style "fg=#00AAFF"
@tpad-daily-work-todo-title " Daily Work Todos "
@tpad-daily-work-todo-width "90%"
@tpad-default-border-lines rounded
@tpad-default-border-style "fg=#e4e4e4,bg=#193549"
@tpad-default-height "90%"
@tpad-default-style "fg=#00AAFF"
@tpad-default-width "90%"
@tpad-espanso-edit-border_lines rounded
@tpad-espanso-edit-border_style "fg=#e4e4e4,bg=#193549"
@tpad-espanso-edit-cmd "espanso edit"
@tpad-espanso-edit-height "90%"
@tpad-espanso-edit-style "fg=#00AAFF"
@tpad-espanso-edit-title " Espanso Edit "
@tpad-espanso-edit-width "90%"
@tpad-gh-dash-border_lines rounded
@tpad-gh-dash-border_style "fg=#e4e4e4,bg=#193549"
@tpad-gh-dash-cmd "gh dash"
@tpad-gh-dash-height "90%"
@tpad-gh-dash-style "fg=#00AAFF"
@tpad-gh-dash-title " GitHub Dash "
@tpad-gh-dash-width "90%"
@tpad-git-help-border_lines rounded
@tpad-git-help-border_style "fg=#e4e4e4,bg=#193549"
@tpad-git-help-cmd "git help -a | less"
@tpad-git-help-height "90%"
@tpad-git-help-style "fg=#00AAFF"
@tpad-git-help-title " Git Help "
@tpad-git-help-width "90%"
@tpad-grimoire-border_lines rounded
@tpad-grimoire-border_style "fg=#e4e4e4,bg=#193549"
@tpad-grimoire-cmd zsh
@tpad-grimoire-height "90%"
@tpad-grimoire-style "fg=#00AAFF"
@tpad-grimoire-title " Grimoire Scratchpad "
@tpad-grimoire-width "90%"
@tpad-journal-personal-border_lines rounded
@tpad-journal-personal-border_style "fg=#e4e4e4,bg=#193549"
@tpad-journal-personal-cmd "nvim \$HOME/Projects/Personal/Github/second-brain/daily/journal/$(date +%Y-%m-%d).org"
@tpad-journal-personal-height "90%"
@tpad-journal-personal-style "fg=#00AAFF"
@tpad-journal-personal-title " Personal Journal "
@tpad-journal-personal-width "90%"
@tpad-journal-work-border_lines rounded
@tpad-journal-work-border_style "fg=#e4e4e4,bg=#193549"
@tpad-journal-work-cmd "nvim \$HOME/Projects/Work/Github/second-brain/journal/$(date +%Y-%m-%d).org"
@tpad-journal-work-height "90%"
@tpad-journal-work-style "fg=#00AAFF"
@tpad-journal-work-title " Work Journal "
@tpad-journal-work-width "90%"
@tpad-lazydocker-border_lines rounded
@tpad-lazydocker-border_style "fg=#e4e4e4,bg=#193549"
@tpad-lazydocker-cmd lazydocker
@tpad-lazydocker-height "90%"
@tpad-lazydocker-style "fg=#00AAFF"
@tpad-lazydocker-title " Lazydocker "
@tpad-lazydocker-width "90%"
@tpad-lazygit-border_lines rounded
@tpad-lazygit-border_style "fg=#e4e4e4,bg=#193549"
@tpad-lazygit-cmd lazygit
@tpad-lazygit-height "90%"
@tpad-lazygit-per-dir true
@tpad-lazygit-style "fg=#00AAFF"
@tpad-lazygit-title " Lazygit "
@tpad-lazygit-width "90%"
@tpad-manpage-border_lines rounded
@tpad-manpage-border_style "fg=#e4e4e4,bg=#193549"
@tpad-manpage-cmd "man zsh"
@tpad-manpage-height "90%"
@tpad-manpage-style "fg=#00AAFF"
@tpad-manpage-title " Man Page "
@tpad-manpage-width "90%"
@tpad-notes-personal-border_lines rounded
@tpad-notes-personal-border_style "fg=#e4e4e4,bg=#193549"
@tpad-notes-personal-cmd "nvim ${HOME}/Projects/Personal/Github/second-brain/brain/notes/inbox.org"
@tpad-notes-personal-height "90%"
@tpad-notes-personal-style "fg=#00AAFF"
@tpad-notes-personal-title " Personal Notes "
@tpad-notes-personal-width "90%"
@tpad-notes-work-border_lines rounded
@tpad-notes-work-border_style "fg=#e4e4e4,bg=#193549"
@tpad-notes-work-cmd "nvim ${HOME}/Projects/Work/Github/second-brain/notes/inbox.org"
@tpad-notes-work-height "90%"
@tpad-notes-work-style "fg=#00AAFF"
@tpad-notes-work-title " Work Notes "
@tpad-notes-work-width "90%"
@tpad-path ${HOME}/.config/tmux/scripts/tpad-wrapper.sh
@tpad-process-viewer-border_lines rounded
@tpad-process-viewer-border_style "fg=#e4e4e4,bg=#193549"
@tpad-process-viewer-cmd btm
@tpad-process-viewer-height "90%"
@tpad-process-viewer-style "fg=#00AAFF"
@tpad-process-viewer-title " Process Viewer "
@tpad-process-viewer-width "90%"
@tpad-regex-test-border_lines rounded
@tpad-regex-test-border_style "fg=#e4e4e4,bg=#193549"
@tpad-regex-test-cmd "python3 -c \"import re; help(re)\" | less"
@tpad-regex-test-height "90%"
@tpad-regex-test-style "fg=#00AAFF"
@tpad-regex-test-title " Regex Help "
@tpad-regex-test-width "90%"
@tpad-scratch-personal-border_lines rounded
@tpad-scratch-personal-border_style "fg=#e4e4e4,bg=#193549"
@tpad-scratch-personal-cmd "nvim ${HOME}/Projects/Personal/Github/second-brain/sandbox/scratch/inbox.org"
@tpad-scratch-personal-height "90%"
@tpad-scratch-personal-style "fg=#00AAFF"
@tpad-scratch-personal-title " Personal Scratchpad "
@tpad-scratch-personal-width "90%"
@tpad-scratch-work-border_lines rounded
@tpad-scratch-work-border_style "fg=#e4e4e4,bg=#193549"
@tpad-scratch-work-cmd "nvim ${HOME}/Projects/Work/Github/second-brain/scratch/inbox.org"
@tpad-scratch-work-height "90%"
@tpad-scratch-work-style "fg=#00AAFF"
@tpad-scratch-work-title " Work Scratchpad "
@tpad-scratch-work-width "90%"
@tpad-scratchpad-border_lines rounded
@tpad-scratchpad-border_style "fg=#e4e4e4,bg=#193549"
@tpad-scratchpad-cmd ''
@tpad-scratchpad-height "90%"
@tpad-scratchpad-style "fg=#00AAFF"
@tpad-scratchpad-title " Scratchpad "
@tpad-scratchpad-width "90%"
@tpad-todos-personal-border_lines rounded
@tpad-todos-personal-border_style "fg=#e4e4e4,bg=#193549"
@tpad-todos-personal-cmd "nvim ${HOME}/Projects/Personal/Github/second-brain/daily/agenda/todos.org"
@tpad-todos-personal-height "90%"
@tpad-todos-personal-style "fg=#00AAFF"
@tpad-todos-personal-title " Personal Todos "
@tpad-todos-personal-width "90%"
@tpad-todos-work-border_lines rounded
@tpad-todos-work-border_style "fg=#e4e4e4,bg=#193549"
@tpad-todos-work-cmd "nvim ${HOME}/Projects/Work/Github/second-brain/agenda/todos.org"
@tpad-todos-work-height "90%"
@tpad-todos-work-style "fg=#00AAFF"
@tpad-todos-work-title " Work Todos "
@tpad-todos-work-width "90%"
@tpad-worktree-logs-border_lines rounded
@tpad-worktree-logs-border_style "fg=#e4e4e4,bg=#193549"
@tpad-worktree-logs-cmd "nvim ${HOME}/.local/share/tmux/logs/git-worktree.log"
@tpad-worktree-logs-height "90%"
@tpad-worktree-logs-style "fg=#00AAFF"
@tpad-worktree-logs-title " Worktree Logs "
@tpad-worktree-logs-width "90%"
@uptime_d 0
@uptime_dy 0
@uptime_h 4
@uptime_m 57
@uptime_s 52
@uptime_y 0
activity-action other
assume-paste-time 1
base-index 1
bell-action any
default-command "exec /bin/zsh"
default-shell /usr/bin/zsh
default-size 80x24
destroy-unattached off
detach-on-destroy off
display-time 1000
focus-follows-mouse off
history-limit 10000
initial-repeat-time 0
key-table root
lock-after-time 0
lock-command "lock -np"
message-command-style "fg=#ffff00,bg=#080808,bold"
message-format "#[#{?#{command_prompt},#{E:message-command-style},#{E:message-style}}]#{message}"
message-line 0
message-style "fg=#080808,bg=#ffff00,bold"
mouse on
prefix C-a
prefix2 C-a
renumber-windows on
repeat-time 600
set-titles on
set-titles-string "#h ❐ #S ● #I #W"
silence-action other
status on
status-bg #193549
status-fg default
status-format[0] "#[align=left range=left #{E:status-left-style}]#[push-default]#{T;=/#{status-left-length}:status-left}#[pop-default]#[norange default]#[list=on align=#{status-justify}]#[list=left-marker]<#[list=right-marker]>#[list=on]#{W:#[range=window|#{window_index} #{E:window-status-style}#{?#{&&:#{window_last_flag},#{!=:#{E:window-status-last-style},default}}, #{E:window-status-last-style},}#{?#{&&:#{window_bell_flag},#{!=:#{E:window-status-bell-style},default}}, #{E:window-status-bell-style},#{?#{&&:#{||:#{window_activity_flag},#{window_silence_flag}},#{!=:#{E:window-status-activity-style},default}}, #{E:window-status-activity-style},}}]#[push-default]#{T:window-status-format}#[pop-default]#[norange default]#{?loop_last_flag,,#{E:window-status-separator}},#[range=window|#{window_index} list=focus #{?#{!=:#{E:window-status-current-style},default},#{E:window-status-current-style},#{E:window-status-style}}#{?#{&&:#{window_last_flag},#{!=:#{E:window-status-last-style},default}}, #{E:window-status-last-style},}#{?#{&&:#{window_bell_flag},#{!=:#{E:window-status-bell-style},default}}, #{E:window-status-bell-style},#{?#{&&:#{||:#{window_activity_flag},#{window_silence_flag}},#{!=:#{E:window-status-activity-style},default}}, #{E:window-status-activity-style},}}]#[push-default]#{T:window-status-current-format}#[pop-default]#[norange list=on default]#{?loop_last_flag,,#{E:window-status-separator}}}#[nolist align=right range=right #{E:status-right-style}]#[push-default]#{T;=/#{status-right-length}:status-right}#[pop-default]#[norange default]"
status-format[1] "#[align=left]#{R: ,#{e|-:#{w;T;=/#{status-left-length}:status-left},3}}P: #[norange default]#[list=on align=#{status-justify}]#[list=left-marker]<#[list=right-marker]>#[list=on]#{P:#[range=pane|#{pane_id} #{E:pane-status-style}]#[push-default]#{T:window-pane-status-format}#[pop-default]#[norange list=on default]#{?loop_last_flag,,#{E:window-status-separator}},#[range=pane|#{pane_id} list=focus #{?#{!=:#{E:pane-status-current-style},default},#{E:pane-status-current-style},#{E:pane-status-style}}]#[push-default]#{T:window-pane-current-status-format}#[pop-default]#[norange list=on default]#{?loop_last_flag,,#{E:window-status-separator}}}"
status-format[2] "#[align=left]#{R: ,#{e|-:#{w;T;=/#{status-left-length}:status-left},3}}S: #[norange default]#[list=on align=#{status-justify}]#[list=left-marker]<#[list=right-marker]>#[list=on]#{S:#[range=session|#{session_id} #{E:session-status-style}]#[push-default]#S#{q/h:session_alert}#[pop-default]#[norange list=on default]  ,#[range=session|#{session_id} list=focus #{?#{!=:#{E:session-status-current-style},default},#{E:session-status-current-style},#{E:session-status-style}}]#[push-default]#S*#{q/h:session_alert}#[pop-default]#[norange list=on default] }"
status-interval 10
status-justify left
status-keys emacs
status-left "#[fg=#080808,bg=#ffff00,bold] ❐ #S #[fg=#ffff00,bg=#ff00af,none]#[fg=#e4e4e4,bg=#ff00af,none] ↑#{?@uptime_y, #{@uptime_y}y,}#{?@uptime_dy, #{@uptime_dy}d,}#{?@uptime_h, #{@uptime_h}h,}#{?@uptime_m, #{@uptime_m}m,} #[fg=#ff00af,bg=#080808,none] "
status-left-length 1000
status-left-style "fg=#8a8a8a,bg=#080808,none"
status-position top
status-right "#(echo; nice cut -c3- '${HOME}/.tmux.conf' | sh -s _battery_status '↑' '↓')#[fg=#080808,bg=#080808,none]#[fg=#8a8a8a,bg=#080808,none] #[fg=none]#[bg=none]#[none]#{?client_prefix,⌨ ,  }#[default]#[fg=#8a8a8a,bg=#080808,none]#[fg=none]#[bg=none]#[none]#{?mouse,↗ ,  }#[default]#[fg=#8a8a8a,bg=#080808,none]#[fg=none]#[bg=none]#[none]#{?session_many_attached,⚇ ,}#[default]#[fg=#8a8a8a,bg=#080808,none]#[fg=none]#[bg=none]#[none]#{?pane_synchronized,⚏ ,}#[default]#[fg=#8a8a8a,bg=#080808,none]#{?@battery_status, #{@battery_status},}#{?@battery_percentage, #(nice cut -c3- '${HOME}/.tmux.conf' | sh -s _bar 'gradient' '◻' '◼' 'auto' '#{@battery_charge}' '#{client_width}'),}#{?@battery_percentage, #{@battery_percentage},} #[fg=#8a8a8a,bg=#080808,none]| %R #[fg=#8a8a8a,bg=#080808,none]| %d %b #[fg=#d70000,bg=#080808,none]#[fg=#e4e4e4,bg=#d70000,none] #(cut -c3- '${HOME}/.tmux.conf' | sh -s _username '#{pane_pid}' '#{b:pane_tty}' false '#D')#[fg=none]#[bg=none]#[bold,blink]#{?#{==:#(cut -c3- '${HOME}/.tmux.conf' | sh -s _username '#{pane_pid}' '#{b:pane_tty}' '#D'),root},!,}#[default]#[fg=#e4e4e4,bg=#d70000,none] #[fg=#e4e4e4,bg=#d70000,none]#[fg=#080808,bg=#e4e4e4,bold] #(cut -c3- '${HOME}/.tmux.conf' | sh -s _hostname '#{pane_pid}' '#{b:pane_tty}' false false '#h' '#D') "
status-right-length 1000
status-right-style "fg=#8a8a8a,bg=#080808,none"
status-style "fg=#8a8a8a,bg=#080808,none"
prompt-cursor-colour black
prompt-command-cursor-colour ''
prompt-cursor-style default
prompt-command-cursor-style default
update-environment[0] DISPLAY
update-environment[1] KRB5CCNAME
update-environment[2] MSYSTEM
update-environment[3] SSH_ASKPASS
update-environment[4] SSH_AUTH_SOCK
update-environment[5] SSH_AGENT_PID
update-environment[6] SSH_CONNECTION
update-environment[7] WAYLAND_DISPLAY
update-environment[8] WINDOWID
update-environment[9] XAUTHORITY
update-environment[10] XDG_CURRENT_DESKTOP
update-environment[11] XDG_SESSION_DESKTOP
update-environment[12] XDG_SESSION_TYPE
visual-activity off
visual-bell off
visual-silence off
word-separators "!\"#$%&'()*+,-./:;<=>?@[\\]^`{|}~"
```

## Global window defaults

```text
cursor-colour ''
cursor-style default
menu-style bg=themedarkgrey,fg=themewhite
menu-selected-style bg=themeyellow,fg=themeblack
menu-border-style bg=themedarkgrey,fg=themelightgrey
menu-border-lines single
pane-status-current-style underscore
pane-status-style default
session-status-current-style underscore
session-status-style default
aggressive-resize on
allow-passthrough off
allow-rename off
allow-set-title on
alternate-screen on
automatic-rename on
automatic-rename-format "#{?pane_in_mode,[tmux],#{pane_current_command}}#{?pane_dead,[dead],}"
clock-mode-colour "#00afff"
clock-mode-style 24
display-panes-active-colour "#00afff"
display-panes-border-style bg=themedarkgrey,fg=themelightgrey
display-panes-colour "#00afff"
display-panes-format "#[align=right]#{pane_unzoomed_width}x#{pane_unzoomed_height}"
display-panes-time 800
copy-mode-match-style bg=themecyan,fg=themeblack
copy-mode-current-match-style bg=thememagenta,fg=themeblack
copy-mode-mark-style bg=themeyellow,fg=themeblack
copy-mode-position-format "#[align=right]#{t/p:top_line_time}#{?#{e|>:#{top_line_time},0}, ,}[#{copy_position}/#{copy_position_limit}]#{?search_timed_out, (timed out),#{?search_count, (#{search_count}#{?search_count_partial,+,} results),}}"
copy-mode-position-style "#{E:mode-style}"
copy-mode-selection-style "#{E:mode-style}"
copy-mode-current-line-number-style fg=themeyellow
copy-mode-current-line-style default
copy-mode-line-number-style fg=themelightgrey,dim
copy-mode-line-numbers off
fill-character "#{?is_inside,#[bg=themedarkgrey] ,#[fg=themelightgrey]#[acs]~}"
main-pane-height 24
main-pane-width 80
mode-keys vi
mode-style "fg=#080808,bg=#ffff00,bold"
monitor-activity on
monitor-bell on
monitor-silence 0
other-pane-height 0
other-pane-width 0
pane-active-border-style "fg=#00afff,bg=default"
pane-base-index 1
pane-border-format "#{?pane_active,#[reverse],}#{pane_index}#[default] \"#{pane_title}\"#{?#{mouse},#[align=right]#[range=control|7][#{?#{pane_floating_flag},t,f}]#[norange]#[range=control|8][#{?#{window_zoomed_flag},u,z}]#[norange]#[range=control|9][x]#[norange],}"
pane-border-indicators colour
pane-border-lines single
pane-border-status off
pane-border-style "fg=#303030,bg=default"
pane-colours
pane-scrollbars off
pane-scrollbars-timeout 500
pane-scrollbars-style bg=themedarkgrey,fg=themelightgrey,width=1,pad=0
pane-scrollbars-position right
popup-style "fg=#e4e4e4,bg=#193549"
popup-border-style "fg=#00AAFF,bg=#193549"
popup-border-lines rounded
remain-on-exit off
remain-on-exit-format "Pane is dead (#{?#{!=:#{pane_dead_status},},status #{pane_dead_status},}#{?#{!=:#{pane_dead_signal},},signal #{pane_dead_signal},}, #{t:pane_dead_time})"
scroll-on-clear on
switch-mode-match-style "bg=cyan fg=black"
synchronize-panes off
tiled-layout-max-columns 0
tree-mode-border-style "fg=#00AAFF,bg=default"
tree-mode-preview-format "#{?pane_format,#{pane_index}:#{pane_title},#{window_index}:#{window_name}}"
tree-mode-preview-style "fg=#{?#{||:#{&&:#{pane_format},#{pane_active}},#{&&:#{window_format},#{window_active}}},themered,themeblue}"
tree-mode-selection-style "#{E:mode-style}"
window-active-style default
window-pane-current-status-format "#P:[#T]#{?pane_flags,#{pane_flags}, }"
window-pane-status-format "#P:[#T]#{?pane_flags,#{pane_flags}, }"
window-size latest
window-style fg=default,bg=default
window-status-activity-style fg=default,bg=default,underscore
window-status-bell-style "fg=#ffff00,bg=default,blink,bold"
window-status-current-format "#[fg=#080808,bg=#00afff,none]#[fg=#080808,bg=#00afff,bold] #I #W#{?#{||:#{window_bell_flag},#{window_zoomed_flag}}, ,}#{?window_bell_flag,!,}#{?window_zoomed_flag,Z,} #[fg=#00afff,bg=#080808]"
window-status-current-style "fg=#080808,bg=#00afff,bold"
window-status-format "#[fg=#080808,bg=#080808,none]#{?window_last_flag,,}#{?window_activity_flag,,}#{?window_bell_flag,,}#[fg=#8a8a8a,bg=#080808,none]#{?window_last_flag,#[fg=#00afff],}#{?window_last_flag,,}#{?window_activity_flag,,}#{?window_activity_flag,,}#{?window_bell_flag,#[fg=#ffff00],}#{?window_bell_flag,,}#{?window_last_flag,#{?window_activity_flag,#{?window_bell_flag,,},#{?window_bell_flag,,}},#{?window_activity_flag,#{?window_bell_flag,,},#{?window_bell_flag,,}}}#{?window_last_flag,#[none],}#{?window_last_flag,#[none],}#{?window_activity_flag,#[none],}#{?window_activity_flag,#[underscore],}#{?window_bell_flag,#[blink],}#{?window_bell_flag,#[bold],}#I #W#{?#{||:#{window_bell_flag},#{window_zoomed_flag}}, ,}#{?window_bell_flag,!,}#{?window_zoomed_flag,Z,}#[none]#{?window_last_flag,#{?window_activity_flag,#{?window_bell_flag,,},#{?window_bell_flag,,}},#{?window_activity_flag,#{?window_bell_flag,,},#{?window_bell_flag,,}}}#[fg=#080808,bg=#080808]#{?window_last_flag,,}#{?window_activity_flag,,}#{?window_bell_flag,,}"
window-status-last-style "fg=#00afff,bg=default,none"
window-status-separator " "
window-status-style "fg=#8a8a8a,bg=#080808,none"
wrap-search on
xterm-keys on
```

## Per-session effective options (session names omitted)

### Session 1 options

```text
```

### Session 1 window options

```text
automatic-rename off
```

### Session 2 options

```text
```

### Session 2 window options

```text
```

### Session 3 options

```text
```

### Session 3 window options

```text
@workmux_primary 1
[REDACTED sensitive baseline entry]
automatic-rename off
```

## Reconciliation and unstable values

- The plan/spec notes 18 active key tables. This live server lists 17 distinct table names and all 595 bindings; the absent `copy-mode-emacs` table returns “table does not exist” while `mode-keys` is `vi`. Preserve the actual captured set and recheck before parity comparison rather than inventing an empty table.
- OMT-expanded status strings embed helper calls and dynamic battery, uptime, username, and hostname data; compare their intended display semantics, not exact expanded output.
- Session names are omitted. Per-session options are labeled by ordinal; runtime values such as pane paths and process state are not asserted.
- Private custom option values are redacted; plugin/custom option names remain for inventory.

## Native migration differences (reviewed and approved before cutover)

- Replaced OMT's sourced shell helpers with tmux formats and direct status commands. The native status keeps session dots, prefix/mouse/attached-session/synchronized indicators, time/date, uptime, local username/root marker, and hostname.
- OMT's optional battery-status/percentage helpers are not represented in the native status line.
- OMT's username/hostname helpers can inspect SSH/Mosh pane commands; native `id -un` and `#h` report the local tmux host/user instead.
- The OMT `+` maximize helper is represented by native `resize-pane -Z`; plugin update remains an explicit TPM binding, not an automatic reload action.
- The user explicitly approved these differences before Task 5: omit the optional battery indicator, report local rather than SSH/Mosh-aware user/host, map `+` to native pane zoom, and keep plugin updates explicit rather than automatic on reload.

## Cutover and rollback record

- User separately authorized Task 5, including retargeting `~/.tmux.conf.local` and `~/.config/tmux/themes/cobalt2.conf` to the worktree after preserving their prior states.
- Original OMT entrypoint backup: `/home/lalitmee/.tmux.conf.omt-backup-20261014-103324` (SHA256 `82e63e90d86af71e310676e2fdc016884238af2c34d8bd137ca791892cee9e05`).
- Original local-settings symlink backup: `/home/lalitmee/.tmux.conf.local.omt-backup-20261014-103324` (preserved symlink target `dotfiles/tmux/.tmux.conf.local`).
- Original theme backup: `/home/lalitmee/.config/tmux/themes/cobalt2.conf.omt-backup-20261014-103324` (SHA256 `7e790e2f5d062c958d7a1032c5ed8d6910bf8b8b1175acbb2e2223bc629d0f04`).
- At initial cutover, the active entrypoint and dependencies resolved into the feature worktree. After integration, `~/.tmux.conf` and `~/.tmux.conf.local` resolve into `/home/lalitmee/dotfiles/`; the Cobalt2 theme is supplied through the Stow-linked `~/.config/tmux` directory. `tmux source-file ~/.tmux.conf` succeeded; live state verified after integration includes 595 binding identities, prefix `C-a`, terminal `tmux-256color`, clipboard on, status top, and inactive/last-active styles `#FFFFFF/#193549` and `#FFC600/#193549`. OMT and legacy theme rollback copies remain in `$HOME`.
- Post-review corrections restored prefix `l`/`L` pane navigation and resize, native `m` mouse toggle, native `r`/`R` reload, baseline `display-time 1000`, `repeat-time 600`, `monitor-activity on`, and `display-panes-time 800`; status formats leave last-window foreground to its yellow style and find pane user/root status from the foreground process on the pane TTY. The focused isolated test passed after the corrections, and live `tmux source-file ~/.tmux.conf` plus checks of those bindings/options/styles succeeded with 595 live bindings. Rollback files remain in place.
