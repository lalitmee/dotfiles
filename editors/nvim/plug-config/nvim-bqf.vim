" :h CocLocationsChange for detail
let g:coc_enable_locationlist = 0
augroup Coc
    autocmd!
    autocmd User CocLocationsChange ++nested call Coc_qf_jump2loc(g:coc_jump_locations)
augroup END

nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> <leader>qd <Cmd>call Coc_qf_diagnostic()<CR>

function! Coc_qf_diagnostic() abort
    let diagnostic_list = CocAction('diagnosticList')
    let items = []
    let loc_ranges = []
    for d in diagnostic_list
        let text = printf('[%s%s] %s', (empty(d.source) ? 'coc.nvim' : d.source),
                    \ (d.code ? ' ' . d.code : ''), split(d.message, '\n')[0])
        let item = {'filename': d.file, 'lnum': d.lnum, 'col': d.col, 'text': text, 'type':
                    \ d.severity[0]}
        call add(loc_ranges, d.location.range)
        call add(items, item)
    endfor
    call setqflist([], ' ', {'title': 'CocDiagnosticList', 'items': items,
                \ 'context': {'bqf': {'lsp_ranges_hl': loc_ranges}}})
    botright copen
endfunction

function! Coc_qf_jump2loc(locs) abort
    let loc_ranges = map(deepcopy(a:locs), 'v:val.range')
    call setloclist(0, [], ' ', {'title': 'CocLocationList', 'items': a:locs,
                \ 'context': {'bqf': {'lsp_ranges_hl': loc_ranges}}})
    let winid = getloclist(0, {'winid': 0}).winid
    if winid == 0
        aboveleft lwindow
    else
        call win_gotoid(winid)
    endif
endfunction

augroup Grepper
    autocmd!
    autocmd User Grepper call setqflist([], 'r',
                \ {'context': {'bqf': {'pattern_hl': histget('/')}}}) |
                \ botright copen
augroup END

let g:grepper = {
            \ 'open': 0,
            \ 'quickfix': 1,
            \ 'searchreg': 1,
            \ 'highlight': 0,
            \ }

" " try `gsiw` under word
" nmap gs  <plug>(GrepperOperator)
" xmap gs  <plug>(GrepperOperator)

