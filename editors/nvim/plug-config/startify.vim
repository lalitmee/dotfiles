" function! StartifyEntryFormat()
"   return ' ."(". WebDevIconsGetFileTypeSymbol(absolute_path) .")". ." ". entry_path'
" endfunction

" returns all modified files of the current git repo
" `2>/dev/null` makes the command fail quietly, so that when we are not
" in a git repo, the list will be empty
function! s:gitModified()
    let files = systemlist('git ls-files -m 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction

" same as above, but show untracked files, honouring .gitignore
function! s:gitUntracked()
    let files = systemlist('git ls-files -o --exclude-standard 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction

let g:startify_lists = [
            \ { 'type': 'files',     'header': ['   Recent Files']            },
            \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
            \ { 'type': 'sessions',  'header': ['   Sessions']       },
            \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
            \ { 'type': function('s:gitModified'),  'header': ['   git modified']},
            \ { 'type': function('s:gitUntracked'), 'header': ['   git untracked']},
            \ { 'type': function('helpers#startify#listcommits'), 'header': [ '   Recent Commits' ] },
            \ { 'type': 'commands',  'header': ['   Commands']       },
            \ ]

let g:startify_session_dir = '~/.local/share/nvim/sessions'

let g:startify_session_autoload = 1
let g:startify_session_delete_buffers = 1
let g:startify_change_to_vcs_root = 1
let g:startify_fortune_use_unicode = 1
let g:startify_session_persistence = 1
let g:startify_update_oldfiles = 1
let g:webdevicons_enable_startify = 1
let g:startify_session_sort = 1

let g:startify_bookmarks = [
            \ { 'be': '~/.config/bat/config' },
            \ { 'dec': '~/.doom.d/config.el' },
            \ { 'dei': '~/.doom.d/init.el' },
            \ { 'ge': '~/.goneovim/setting.toml' },
            \ { 'ne': '~/.config/nvim/init.vim' },
            \ { 'ze': '~/.zshrc' },
            \ ]

" function! StartifyEntryFormat()
"     return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
" endfunction

" function! GetUniqueSessionName()
"   let path = fnamemodify(getcwd(), ':~:t')
"   let path = empty(path) ? 'no-project' : path
"   let branch = gitbranch#name()
"   let branch = empty(branch) ? '' : '-' . branch
"   return substitute(path . branch, '/', '-', 'g')
" endfunction

" autocmd VimLeavePre * silent execute 'SSave! ' . GetUniqueSessionName()


