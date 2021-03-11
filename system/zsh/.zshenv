# XDG configuration home
if [[ -z $XDG_CONFIG_HOME ]]
then
   export XDG_CONFIG_HOME=$HOME/.config
fi

# XDG data home
if [[ -z $XDG_DATA_HOME ]]
then
   export XDG_DATA_HOME=$HOME/.local/share
fi

# function -d "Fuzzy change directory"  fcd
#    if set -q argv[1]
#       set searchdir $argv[1]
#    else
#       set searchdir $HOME
#    end

#    # https://github.com/fish-shell/fish-shell/issues/1362
#    set -l tmpfile (mktemp)
#    find $searchdir \( ! -regex '.*/\..*' \) ! -name __pycache__ -type d | fzf > $tmpfile
#    set -l destdir (cat $tmpfile)
#    rm -f $tmpfile

#    if test -z "$destdir"
#       return 1
#    end

#    cd $destdir
# end
