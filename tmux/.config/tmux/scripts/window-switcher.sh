#!/usr/bin/env zsh
set -euo pipefail

# Keep session + window IDs: linked windows can belong to multiple sessions.
# Let fzf expand tabs using display widths (including emoji), not awk byte counts.
window_format='#{session_id}:#{window_id}'
window_format+=$'\t#{pane_id}'
window_format+=$'\t#{=24:session_name}'
window_format+=$'\t#{=28:window_name}'
window_format+=$'\t#{pane_current_command}'
window_format+=$'\t#{window_index}'
windows=$(tmux list-windows -a -F "$window_format")

# Shared hint styling: keys blue, values yellow.
source "${0:A:h}/lib/popup-style.sh"

if selection=$(printf '%s\n' "$windows" | awk -F '\t' '
    BEGIN {
        # Approved palette; header labels are pink, session names take these in order.
        palette_list = "255;198;0 0;170;255 58;217;0 255;98;140 255;157;0 " \
                       "150;126;251 128;252;255 238;128;225 242;237;127 " \
                       "187;255;221 66;133;244 234;67;53 251;188;5 52;168;83"
        split(palette_list, palette, " ")
        for (i in palette) used[palette[i]] = 1
        print "\033[1;38;2;255;98;140mSESSION:INDEX\tWINDOW NAME\tCOMMAND\033[0m"
    }
    {
        split($1, target, ":")
        session = target[1]
        if (!(session in colors)) {
            n++
            color = palette[n]
            # Beyond the approved palette, generate unused RGBs instead of cycling.
            while (color == "" || (n > 14 && color in used)) {
                rgb = (8421504 + ++extra * 7919) % 16777216
                color = int(rgb / 65536) ";" int(rgb / 256) % 256 ";" rgb % 256
            }
            used[color] = 1
            colors[session] = color
        }
        index_color = palette[($6 % 14) + 1]
        printf "\033[1;38;2;%sm%s:\033[38;2;%sm%s\033[0m" \
               "\t%s\t%s\t%s\t%s\n", \
               colors[session], $3, index_color, $6, $4, $5, $1, $2
    }
' | fzf --ansi \
    --delimiter='\t' \
    --with-nth=1,2,3 \
    --tabstop=32 \
    --no-multi \
    --header-lines=1 \
    --layout=reverse \
    --info=inline \
    --prompt='Jump To Window > ' \
    --pointer='➜' \
    --header="$(popup_hints \
        'Enter:switch' 'Esc:close' 'Ctrl-d/u:scroll preview' \
        'Alt-p:expand preview' 'Ctrl-/:hide preview')" \
    --preview='session=$(tmux display-message -p -t {4} "#{session_name}:#{window_index}")
window=$(tmux display-message -p -t {4} "#{window_name}")
printf "\033[1;38;2;102;179;255m%s\033[0m \033[2m|\033[0m \
\033[1;38;2;255;98;140m%s\033[0m\n" "$session" "$window"
tmux capture-pane -ep -t {5}' \
    --preview-window='right:60%:nowrap:<120(bottom:45%)' \
    --bind='tab:down,btab:up' \
    --bind='ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up' \
    --bind='ctrl-/:toggle-preview' \
    --bind='alt-p:change-preview-window[bottom:99%:<1(bottom:99%)|]' \
    --color='fg:#FFFFFF,bg:#193549' \
    --color='fg+:#FFFFFF,bg+:#185294' \
    --color='hl:#FFC600,hl+:#FF9D00' \
    --color='info:#8fbfdc,prompt:#3AD900,pointer:#00AAFF,header:#66B3FF'); then
    [[ -n "$selection" ]] || exit 0
    target=$(printf '%s\n' "$selection" | cut -f4)
    tmux switch-client -t "$target"
else
    code=$?
    # No match and user cancellation are normal exits, not popup errors.
    [[ "$code" == 1 || "$code" == 130 ]] && exit 0
    exit "$code"
fi
