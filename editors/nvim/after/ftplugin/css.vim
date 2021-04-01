set iskeyword+=- "Enables better css syntax highlighting
setlocal foldlevelstart=99
setlocal nofoldenable

set formatoptions-=o

highlight VendorPrefix guifg=#00ffff gui=bold
match VendorPrefix /-\(moz\|webkit\|o\|ms\)-[a-zA-Z-]\+/
