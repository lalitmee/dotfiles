set iskeyword+=- "Enables better css syntax highlighting
setlocal foldlevelstart=99
setlocal nofoldenable

autocmd FileType css setlocal ts=2 sw=2 sts=2 et

set formatoptions-=o

highlight VendorPrefix guifg=#00ffff gui=bold
match VendorPrefix /-\(moz\|webkit\|o\|ms\)-[a-zA-Z-]\+/
