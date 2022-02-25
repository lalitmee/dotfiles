#!/usr/bin/env bash
selected=`cat ~/.tmux-cht-languages ~/.tmux-cht-command | fzf --reverse --cycle --info=inline`
if [[ -z $selected ]]; then
    exit 0
fi

read -p "Enter Query: " query

if grep -qs "$selected" ~/.tmux-cht-languages; then
    query=`echo $query | tr ' ' '+'`
    tmux neww bash -c "echo \"curl cht.sh/$selected/$query/\" & curl cht.sh/$selected/$query & while [ : ]; do sleep 1; done"
else
    query=`echo $query | tr ' ' '~'`
    # tmux neww bash -c "curl cht.sh/$selected~$query | less"
    tmux neww bash -c "echo \"curl cht.sh/$selected~$query/\" & curl cht.sh/$selected~$query & while [ : ]; do sleep 1; done"
fi
