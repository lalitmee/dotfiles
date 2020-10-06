" Folding settings {{{

augroup ft_vim
	au!
	au FileType vim setlocal foldmethod=marker foldmarker={{{,}}}
augroup END

augroup ft_js
	au!
	au FileType javascript setlocal foldmethod=marker foldmarker={,}
augroup END

" }}}
