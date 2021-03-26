set diffopt+=vertical

" fugitive git commands
command! -nargs=0 Gcm Git checkout master
command! -nargs=1 Gco Git checkout <q-args>
command! -nargs=1 Gcb Git checkout -b <q-args>
