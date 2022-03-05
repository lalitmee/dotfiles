" luafile $HOME/.config/nvim/init.lua

" NOTE: make ctags {{{

" command for making ctags in a project
command! MakeTags !ctags -R .
command! MakeCTags !ctags-exuberant -R .

" }}}

" NOTE: Qargs with only filenames {{{

" populate args list with only those files which have matching text in them
command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
function! QuickfixFilenames()
  " Building a hash ensures we get each buffer only once
  let buffer_numbers = {}
  for quickfix_item in getqflist()
    let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
  endfor
  return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction

"}}}

" vim:foldmethod=marker
