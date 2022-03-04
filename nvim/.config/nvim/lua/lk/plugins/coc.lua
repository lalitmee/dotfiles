function _G.__coc_apply_highlights()
  local highlight = require("lk.highlights").all
  highlight({
    { "CocErrorHighlight", { guisp = "#E06C75", gui = "undercurl" } },
    { "CocWarningHighlight", { guisp = "orange", gui = "undercurl" } },
    { "CocInfoHighlight", { guisp = "orange", gui = "undercurl" } },
    -- { 'CocHighlightText', { gui = 'underline' } },
    { "CocHintHighlight", { guisp = "#15aabf", gui = "undercurl" } },
    { "CocOutlineIndentLine", { link = "LineNr" } },
    -- By default this links to CocHintSign but that keeps getting cleared mysteriously
    { "CocRustChainingHint", { guifg = "#15aabf" } },
  })
end

local map = lk.map
local command = lk.command

-- vim.g.coc_config_home = '~/Desktop/Github/dotfiles/editors/nvim/coc-settings.json'

-- Extensions {{{

vim.g.coc_global_extensions = {
  "coc-actions",
  "coc-angular",
  "coc-bootstrap-classname",
  "coc-browser",
  "coc-css",
  "coc-css-block-comments",
  "coc-cssmodules",
  "coc-diagnostic",
  "coc-docker",
  "coc-docthis",
  "coc-emmet",
  "coc-emoji",
  "coc-eslint",
  "coc-fzf-preview",
  "coc-gist",
  "coc-go",
  "coc-highlight",
  "coc-html",
  "coc-html-css-support",
  "coc-htmlhint",
  "coc-json",
  "coc-jsref",
  "coc-lists",
  "coc-lit-html",
  "coc-markdownlint",
  "coc-marketplace",
  "coc-pairs",
  "coc-prettier",
  "coc-pyright",
  "coc-react-refactor",
  "coc-sh",
  "coc-snippets",
  "coc-sumneko-lua",
  "coc-svg",
  "coc-tabnine",
  "coc-toml",
  "coc-tsdetect",
  "coc-tsserver",
  "coc-ultisnips",
  "coc-vimlsp",
  "coc-xml",
  "coc-yaml",
  "coc-yank",
  "coc-zi",
}

-- }}}

-- options {{{

vim.g.coc_snippet_next = "<tab>"
vim.g.coc_fzf_opts = { "--layout=reverse", "--inline-info" }
vim.g.coc_fzf_preview = "right:60%"

-- }}}

-- CoC Mappings {{{

-- Use tab for trigger completion with characters ahead and navigate.
-- Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
map(
  "i",
  "<TAB>",
  [[pumvisible() ? "\<C-n>" : v:lua.__coc_check_back_space() ? "\<TAB>" : coc#refresh()]],
  { expr = true, silent = true }
)
map("i", "<S-TAB>", [[pumvisible() ? "\<C-p>" : "\<C-h>"]], { expr = true, silent = true })

-- use <TAB> like in vscode for snippets
map(
  "i",
  "<TAB>",
  [[pumvisible() ? coc#_select_confirm() : coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" : v:lua.__coc_check_back_space() ? "\<TAB>" : coc#refresh()]],
  { expr = true, silent = true }
)

function _G.__coc_check_back_space()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  return (col == 0 or vim.api.nvim_get_current_line():sub(col, col):match("%s")) and true
end

local expr = { expr = true, silent = true }
local expr_recursive = { expr = true, noremap = true, silent = true }
local recursive = { noremap = false, silent = true }

-- Use <C-l> for trigger snippet expand.
map("i", "<C-l>", [[<Plug>(coc-snippets-expand)]], recursive)

-- Use <C-j> for select text for visual placeholder of snippet.
map("v", "<C-j>", [[<Plug>(coc-snippets-select]], recursive)

-- Use <C-j> for both expand and jump (make expand higher priority.)
map("i", "<C-j>", [[<Plug>(coc-snippets-expand-jump)]], recursive)

-- Use <c-space> for trigger completion.
map("i", "<C-@>", [[coc#refresh()]], expr)

-- Make <CR> auto-select the first completion item and notify coc.nvim to
-- format on enter, <cr> could be remapped by other vim plugin
map("i", "<cr>", [[pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], expr_recursive)

map("n", "gep", [[&diff ? ']c' : "\<Plug>(coc-diagnostic-prev)"]], expr_recursive)
map("n", "gen", [[&diff ? '[c' : "\<Plug>(coc-diagnostic-next)"]], expr_recursive)

-- GoTo code navigation.
-- map('n', 'gd', [[<Plug>(coc-definition)]], recursive)
-- map('n', 'gy', [[<Plug>(coc-type-definition)]], recursive)
-- map('n', 'gi', [[<Plug>(coc-implementation)]], recursive)
-- map('n', 'gr', [[<Plug>(coc-references)]], recursive)
map("n", "gd", [[<cmd>Telescope coc definitions<CR>]], recursive)
map("n", "ge", [[<cmd>Telescope coc diagnostics<CR>]], recursive)
map("n", "gE", [[<cmd>Telescope coc workspace_diagnostics<CR>]], recursive)
map("n", "gi", [[<cmd>Telescope coc implementations<CR>]], recursive)
map("n", "gr", [[<cmd>Telescope coc references<CR>]], recursive)
map("n", "gw", [[<cmd>Telescope coc document_symbols<CR>]], recursive)
map("n", "gW", [[<cmd>Telescope coc workspace_symbols<CR>]], recursive)
map("n", "gwn", [[<cmd>CocCommand document.jumpToNextSymbol<CR>]], recursive)
map("n", "gwp", [[<cmd>CocCommand document.jumpToPrevSymbol<CR>]], recursive)
map("n", "gy", [[<cmd>Telescope coc type_definitions<CR>]], recursive)

-- Use K for show documentation in preview window
map("n", "K", [[<cmd>lua __coc_show_documentation()<CR>]])

function _G.__coc_show_documentation()
  if vim.tbl_contains({ "vim", "help" }, vim.bo.filetype) then
    vim.cmd("h " .. vim.fn.expand("<cword>"))
  elseif vim.fn["coc#rpc#ready"]() then
    vim.fn["CocActionAsync"]("doHover")
  else
    vim.cmd("!" .. vim.bo.keywordprg .. " " .. vim.fn.expand("<cword>"))
  end
end

-- Map function and class text objects
-- NOTE: Requires 'textDocument.documentSymbol' support from the language server.
map("o", "af", [[<Plug>(coc-funcobj-a)]], recursive)
map("o", "am", [[<Plug>(coc-classobj-a)]], recursive)
map("o", "if", [[<Plug>(coc-funcobj-i)]], recursive)
map("o", "im", [[<Plug>(coc-classobj-i)]], recursive)
map("x", "af", [[<Plug>(coc-funcobj-a)]], recursive)
map("x", "am", [[<Plug>(coc-classobj-a)]], recursive)
map("x", "if", [[<Plug>(coc-funcobj-i)]], recursive)
map("x", "im", [[<Plug>(coc-classobj-i)]], recursive)

-- Use CTRL-S for selections ranges.
-- Requires 'textDocument/selectionRange' support of language server.
map("n", "<C-s>", [[<Plug>(coc-range-select)]], { silent = true })
map("x", "<C-s>", [[<Plug>(coc-range-select)]], { silent = true })

local opts = { noremap = true, silent = true, nowait = true, expr = true }

map("n", "<C-f>", [[coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"]], opts)
map("n", "<C-b>", [[coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"]], opts)
map("i", "<C-f>", [[coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"]], opts)
map("i", "<C-b>", [[coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"]], opts)
map("v", "<C-f>", [[coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"]], opts)
map("v", "<C-b>", [[coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"]], opts)

-- Keymapping for grep word under cursor with interactive mode
map("n", "<leader>cG", [[:exe 'CocList -I --input='.expand('<cword>').' grep'<CR>]], { silent = true })

-- grep current word in current buffer
map("n", "<leader>cg", [[:exe 'CocList -I --normal --input='.expand('<cword>').' words'<CR>]], { silent = true })

-- smartf settings
-- -- press <esc> to cancel.
-- lk.nmap('f', [[<Plug>(coc-smartf-forward)]])
-- lk.nmap('F', [[<Plug>(coc-smartf-backward)]])
-- lk.nmap(';', [[<Plug>(coc-smartf-repeat)]])
-- lk.nmap(',', [[<Plug>(coc-smartf-repeat-opposite)]])

-- vim.api.nvim_exec([[
--     augroup Smartf
--       autocmd User SmartfEnter :hi Conceal ctermfg=220 guibg=black guifg=yellow
--       autocmd User SmartfLeave :hi Conceal ctermfg=239 guifg=black
--     augroup end
-- ]], false)

-- }}}

-- Coc Autocommands {{{

require("lk.autocommands").create({
  coc_commands = {
    -- { 'VimEnter', '*', 'lua __coc_init()' },
    { "CursorHold", "*", "silent call CocActionAsync('highlight')" },
    -- Update signature help on jump placeholder.
    { "User CocJumpPlaceholder", "call CocActionAsync('showSignatureHelp')" },
    { "CompleteDone", "*", "if pumvisible() == 0 | pclose | endif" },
    -- Suggestions don't work and are not needed in the command line window
    { "CmdwinEnter", "*", "let b:coc_suggest_disable = 1" },
    { "User CocOpenFloat", "setlocal foldlevel=20 foldcolumn=0" },
    { "VimEnter,ColorScheme", "*", "lua __coc_apply_highlights()" },
    -- Setup formatexpr specified filetype(s).
    {
      "FileType",
      "typescript,json",
      "setl formatexpr=CocAction('formatSelected')",
    },
  },
})

-- }}}

-- COC commands {{{

-- Use `:Format` for format current buffer
command({ "Format", [[:call CocActionAsync('format')]], nargs = 0 })

-- Prettier command for coc-prettier
command({ "Prettier", [[:CocCommand prettier.formatFile]], nargs = 0 })

-- Add `:Fold` command to fold current buffer.
command({ "Fold", [[:call CocAction('fold')]], nargs = 0 })

-- Add `:OR` command for organize imports of the current buffer.
command({
  "OR",
  [[:call CocAction('runCommand', 'editor.action.organizeImport')]],
  nargs = 0,
})

vim.cmd("set tagfunc=CocTagFunc")
-- }}}
