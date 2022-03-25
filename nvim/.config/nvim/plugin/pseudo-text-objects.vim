" 24 simple pseudo-text objects
" -----------------------------
" i_ i. i: i, i; i| i/ i\ i* i+ i- i#
" a_ a. a: a, a; a| a/ a\ a* a+ a- a#
" can take a count: 2i: 3a/
for char in [ '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '-', '#' ]
	execute "xnoremap i" . char . " :<C-u>execute 'normal! ' . v:count1 . 'T" . char . "v' . (v:count1 + (v:count1 - 1)) . 't" . char . "'<CR>"
	execute "onoremap i" . char . " :normal vi" . char . "<CR>"
	execute "xnoremap a" . char . " :<C-u>execute 'normal! ' . v:count1 . 'F" . char . "v' . (v:count1 + (v:count1 - 1)) . 'f" . char . "'<CR>"
	execute "onoremap a" . char . " :normal va" . char . "<CR>"
endfor

" line pseudo-text objects
" ------------------------
" il al
xnoremap il g_o^
onoremap il :<C-u>normal vil<CR>
xnoremap al $o0
onoremap al :<C-u>normal val<CR>

" number pseudo-text object (integer and float)
" ---------------------------------------------
" in
function! VisualNumber()
	call search('\d\([^0-9\.]\|$\)', 'cW')
	normal v
	call search('\(^\|[^0-9\.]\d\)', 'becW')
endfunction
xnoremap in :<C-u>call VisualNumber()<CR>
onoremap in :<C-u>normal vin<CR>

" buffer pseudo-text objects
" --------------------------
" i% a%
xnoremap i% :<C-u>let z = @/\|1;/^./kz<CR>G??<CR>:let @/ = z<CR>V'z
onoremap i% :<C-u>normal vi%<CR>
xnoremap a% GoggV
onoremap a% :<C-u>normal va%<CR>

" square brackets pseudo-text objects
" -----------------------------------
" ir ar
" can take a count: 2ar 3ir
xnoremap ir i[
onoremap ir :<C-u>execute 'normal v' . v:count1 . 'i['<CR>
xnoremap ar a[
onoremap ar :<C-u>execute 'normal v' . v:count1 . 'a['<CR>

" block comment pseudo-text objects
" ---------------------------------
" i? a?
xnoremap a? [*o]*
onoremap a? :<C-u>normal va?V<CR>
xnoremap i? [*jo]*k
onoremap i? :<C-u>normal vi?V<CR>

" C comment pseudo-text object
" ----------------------------
xnoremap i? [*jo]*k
onoremap i? :<C-u>normal vi?V<CR>
xnoremap a? [*o]*
onoremap a? :<C-u>normal va?V<CR>

" last change pseudo-text objects
" -------------------------------
" ik ak
xnoremap ik `]o`[
onoremap ik :<C-u>normal vik<CR>
onoremap ak :<C-u>normal vikV<CR>

" XML/HTML/etc. attribute pseudo-text object
" ------------------------------------------
" ix ax
xnoremap ix a"oB
onoremap ix :<C-u>normal vix<CR>
xnoremap ax a"oBh
onoremap ax :<C-u>normal vax<CR>
