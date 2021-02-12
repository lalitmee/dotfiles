let g:xtabline_settings = {}

" let g:xtabline_settings.enable_mappings = 0

let g:xtabline_settings.tabline_modes = ['buffers', 'tabs', 'arglist']

let g:xtabline_settings.enable_persistance = 0

" let g:xtabline_settings.last_open_first = 1
let g:xtabline_lazy = 1

let g:xtabline_settings.special_tabs = 1

let g:xtabline_settings.indicators = {
      \ 'modified': '●',
      \ 'pinned': '[📌]',
      \}
      " \ 'modified': '+',

let g:xtabline_settings.icons = {
      \'pin': '📌',
      \'star': '*',
      \'book': '📖',
      \'lock': '🔒',
      \'hammer': '🔨',
      \'tick': '✔',
      \'cross': '✖',
      \'warning': '⚠',
      \'menu': '☰',
      \'apple': '🍎',
      \'linux': '🐧',
      \'windows': '⌘',
      \'git': '',
      \'palette': '🎨',
      \'lens': '🔍',
      \'flag': '🏁',
      \}

let g:xtabline_settings.buffers_paths = -2
let g:xtabline_settings.current_tab_paths = -2
let g:xtabline_settings.other_tabs_paths = -2


let g:xtabline_settings.todo = {
      \'file': '.TODO',
      \'command': 'vsplit',
      \'syntax': 'javascript'
      \}
