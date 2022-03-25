""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NOTE: some useful commands {{{
" from here https://gist.github.com/romainl/1cad2606f7b00088dda3bb511af50d53
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! -range=% SP <line1>,<line2>w !curl -F 'sprunge=<-' http://sprunge.us | tr -d '\n' | xclip -i -selection clipboard
command! -range=% CL <line1>,<line2>w !curl -F 'clbin=<-' https://clbin.com | tr -d '\n' | xclip -i -selection clipboard
command! -range=% VP <line1>,<line2>w !curl -F 'text=<-' http://vpaste.net | tr -d '\n' | xclip -i -selection clipboard
command! -range=% PB <line1>,<line2>w !curl -F 'c=@-' https://ptpb.pw/?u=1 | tr -d '\n' | xclip -i -selection clipboard
command! -range=% IX <line1>,<line2>w !curl -F 'f:1=<-' http://ix.io | tr -d '\n' | xclip -i -selection clipboard
command! -range=% EN <line1>,<line2>w !curl -F 'file=@-;' https://envs.sh | tr -d '\n' | xclip -i -selection clipboard
command! -range=% TB <line1>,<line2>w !nc termbin.com 9999 | tr -d '\n' | xclip -i -selection clipboard
" }}}
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NOTE: git jump {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! -bar -nargs=* Jump cexpr system('git jump ' . expand(<q-args>))
" }}}
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
