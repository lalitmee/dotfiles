" better scrolling using vim-smooth-scroll
noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 20, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 20, 2)<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 20, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 20, 4)<CR>
noremap <silent> <c-y> :call smooth_scroll#up(&scroll, 20, 2)<CR>
noremap <silent> <c-e> :call smooth_scroll#down(&scroll, 20, 2)<CR>


" noremap <silent> k :call smooth_scroll#up(&scroll, 20, 0)<CR>
" noremap <silent> j :call smooth_scroll#down(&scroll, 20, 0)<CR>
