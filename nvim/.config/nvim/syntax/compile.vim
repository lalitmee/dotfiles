" ~/.config/nvim/syntax/compile.vim
if exists("b:current_syntax")
  finish
endif

syn case ignore

" ---
" A. Whole-line matches (pytest E/F, PASSED/FAILED)
"    We want these to match the entire line for high visibility.
" ---
syn match   compileSuccess  "^\s*passed.*"
syn match   compileFailure  "^\s*failed.*"

" NEW: Add rules for pytest 'E' (Error) and 'F' (Failure) lines
" This will match "E   TypeError: ..."
syn match   compileError    "^\s*E\s\+.*"
syn match   compileFailure  "^\s*F\s\+.*"

" ---
" B. Partial-line matches (Location, Error, etc.)
"    These can be combined on the same line.
" ---

" Highlight file:lnum or file:lnum:col
syn match   compileLocation   "\.\?[/a-zA-Z0-9_.-]\+:\d\+\(:\d\+\)\?"

" Highlight error/warning/note keywords
" CHANGED: Added \< to match 'error' as a whole word.
" This will no longer match 'TypeError'.
syn match   compileError      "\<error\(\[[^]]*\]\)\?:"
syn match   compileWarning    "\<warning\(\[[^]]*\]\)\?:"
syn match   compileNote       "\<note\(\[[^]]*\]\)\?:"

" --- 3. Highlight Linking ---
hi link compileSuccess    DiffAdd
hi link compileFailure    DiffDelete
hi link compileError      Error
hi link compileWarning    Todo
hi link compileNote       SpecialComment
hi link compileLocation   Directory

let b:current_syntax = "compile"
