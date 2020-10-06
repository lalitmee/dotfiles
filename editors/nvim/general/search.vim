" SilverSearcher for ack {{{

let g:ackprg = 'ag --nogroup --nocolor --column'
if executable('ag')
	let g:ackprg = 'ag --vimgrep'
endif

" }}}
