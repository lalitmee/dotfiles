set grepprg=rg\ --hidden\ --vimgrep\ --glob\ '!*{.git,node_modules,build,bin,obj,README.md,tags}'

function! Grep(...)
  let s:command = join([&grepprg] + [expandcmd(join(a:000, ' '))], ' ')
  return system(s:command)
endfunction

command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr Grep(<f-args>)
command! -nargs=+ -complete=file_in_path -bar LGrep lgetexpr Grep(<f-args>)

cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() ==# 'grep')  ? 'Grep'  : 'grep'
cnoreabbrev <expr> lgrep (getcmdtype() ==# ':' && getcmdline() ==# 'lgrep') ? 'LGrep' : 'lgrep'

augroup quickfix
  autocmd!
  autocmd QuickFixCmdPost cgetexpr cwindow
        \| call setqflist([], 'a', {'title': ':' . s:command})
  autocmd QuickFixCmdPost lgetexpr lwindow
        \| call setloclist(0, [], 'a', {'title': ':' . s:command})
augroup END
