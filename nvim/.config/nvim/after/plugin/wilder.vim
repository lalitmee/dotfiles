" call wilder#enable_cmdline_enter()
" set wildcharm=<Tab>
" cmap <expr> <Tab> wilder#in_context() ? wilder#next() : "\<Tab>"
" cmap <expr> <S-Tab> wilder#in_context() ? wilder#previous() : "\<S-Tab>"
" call wilder#set_option('modes', ['/', '?', ':'])

" call wilder#set_option('pipeline', [
"       \   wilder#branch(
"       \     wilder#python_file_finder_pipeline({
"       \       'file_command': {_, arg -> stridx(arg, '.') != -1 ? ['fd', '-tf', '-H'] : ['fd', '-tf']},
"       \       'dir_command': ['fd', '-td'],
"       \       'filters': ['cpsm_filter'],
"       \       'cache_timestamp': {-> 1},
"       \     }),
"       \     wilder#cmdline_pipeline({
"       \       'fuzzy': 1,
"       \       'fuzzy_filter': wilder#python_cpsm_filter(),
"       \       'set_pcre2_pattern': 0,
"       \     }),
"       \     wilder#python_search_pipeline({
"       \       'pattern': wilder#python_fuzzy_pattern({
"       \         'start_at_boundary': 0,
"       \       }),
"       \     }),
"       \   ),
"       \ ])

" let s:highlighters = [
"       \ wilder#pcre2_highlighter(),
"       \ wilder#lua_fzy_highlighter(),
"       \ ]

" call wilder#set_option('renderer', wilder#renderer_mux({
"       \ ':': wilder#popupmenu_renderer({
"       \   'highlighter': s:highlighters,
"       \   'left': [
"       \     wilder#popupmenu_devicons(),
"       \   ],
"       \   'right': [
"       \     ' ',
"       \     wilder#popupmenu_scrollbar(),
"       \   ],
"       \ }),
"       \ '/': wilder#wildmenu_renderer({
"       \   'highlighter': s:highlighters,
"       \ }),
"       \ }))
