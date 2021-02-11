let g:far#source='rgnvim'
" let g:far#source='rg'
" let g:far#source='vimgrep'
" let g:far#source='ag'

" improve scrolling performance when navigating through large results
set lazyredraw

let g:far#window_width=60
" Use %:p with buffer option only
let g:far#file_mask_favorites=[
            \ '%:p',
            \ '**/*.*',
            \ '**/*.js',
            \ '**/*.py',
            \ '**/*.java',
            \ '**/*.css',
            \ '**/*.html',
            \ '**/*.vim',
            \ '**/*.cpp',
            \ '**/*.c',
            \ '**/*.h',
            \ ]
let g:far#window_min_content_width=30
let g:far#enable_undo=1
