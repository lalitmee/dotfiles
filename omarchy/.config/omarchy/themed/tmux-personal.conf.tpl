# Personal status layout; loaded only by the dotfiles tmux configuration.
set -g window-status-format "#[fg={{ foreground }},bg={{ background }}] #I:#W#{?@workmux_status, #{@workmux_status},} #[default]"
set -g window-status-current-format "#[fg={{ background }},bg={{ blue }},bold] #I #[fg={{ accent }},bg={{ selection }},bold] #W#{?@workmux_status, #{@workmux_status},} #[default]"
set -g status-left "#[fg={{ background }},bg={{ yellow }},bold] ❐ #S #[default]"
set -g status-right "#[fg={{ yellow }},bg={{ background }}] #(~/.config/tmux/plugins/tmux-session-dots/scripts/session-dots.sh '#S' '#{@session-dots-active}' '#{@session-dots-inactive}') #{?client_prefix,⌨ ,}#{?mouse,↗ ,}#{?session_many_attached,⚇ ,}#{?pane_synchronized,⚏ ,}#[fg={{ yellow }},bg={{ selection }},bold] ↑ #(bash ~/.config/tmux/scripts/uptime.sh) #[fg={{ background }},bg={{ yellow }},bold] #(id -un) #[default]"
set -g message-format '#{?#{command_prompt},#[fill={{ background }}],#[fill={{ accent }}]}#[width=100%]#[#{?#{command_prompt},#{E:message-command-style},#{E:message-style}}]#{message}'
set -g prompt-cursor-colour "{{ background }}"
set -g tree-mode-border-style "fg={{ accent }}"
set -g tree-mode-selection-style "fg={{ background }},bg={{ accent }},bold"
set -g tree-mode-preview-style "fg={{ accent }}"
set -g switch-mode-match-style "fg={{ background }},bg={{ yellow }},bold"
set -g copy-mode-selection-style "fg={{ background }},bg={{ accent }},bold"
set -g window-status-bell-style "fg={{ yellow }},bold"
set -g window-status-last-style "fg={{ yellow }},bg={{ background }}"
set -g @session-dots-color "{{ yellow }}"
set -g @tmux-expose-style "bg={{ background }}"
set -g @tmux-expose-border-style "fg={{ accent }},border-lines=rounded"
set -g @tmux-expose-selected-color "{{ yellow }}"
set -g @tmux-expose-attached-color "{{ green }}"
set -g @tmux-expose-inactive-color "{{ muted }}"
run-shell 'if [ -x "$HOME/.config/tmux/plugins/tmux.expose/tmux.expose.tmux" ]; then "$HOME/.config/tmux/plugins/tmux.expose/tmux.expose.tmux"; fi'
set -g @tpad-default-style "fg={{ accent }}"
set -g @tpad-default-border-style "fg={{ foreground }},bg={{ background }}"
run-shell 'style=$(tmux show-option -gqv @tpad-default-style); border=$(tmux show-option -gqv @tpad-default-border-style); for inst in $(tmux show-options -g | sed -n "s/^@tpad-\(.*\)-cmd .*/\1/p"); do tmux set -g "@tpad-${inst}-style" "$style"; tmux set -g "@tpad-${inst}-border_style" "$border"; done'
