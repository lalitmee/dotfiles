local nmap = lk.nmap
local imap = lk.imap
local vmap = lk.vmap
local omap = lk.omap
local xmap = lk.xmap
local command = lk.command

--------------------------------------------------------------------------------
-- NOTE: Extensions {{{
--------------------------------------------------------------------------------
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
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: options {{{
----------------------------------------------------------------------
vim.g.coc_snippet_next = "<tab>"
vim.g.coc_fzf_opts = { "--layout=reverse", "--inline-info" }
vim.g.coc_fzf_preview = "right:60%"
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: coc mappings {{{
----------------------------------------------------------------------

-- Use tab for trigger completion with characters ahead and navigate.
-- Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
imap(
  "<TAB>",
  [[pumvisible() ? "\<C-n>" : v:lua.__coc_check_back_space() ? "\<TAB>" : coc#refresh()]],
  { expr = true, silent = true }
)
imap("<S-TAB>", [[pumvisible() ? "\<C-p>" : "\<C-h>"]], { expr = true, silent = true })

-- use <TAB> like in vscode for snippets
imap(
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
imap("<C-l>", [[<Plug>(coc-snippets-expand)]], recursive)

-- Use <C-j> for select text for visual placeholder of snippet.
vmap("<C-j>", [[<Plug>(coc-snippets-select]], recursive)

-- Use <C-j> for both expand and jump (make expand higher priority.)
imap("<C-j>", [[<Plug>(coc-snippets-expand-jump)]], recursive)

-- Use <c-space> for trigger completion.
imap("<C-@>", [[coc#refresh()]], expr)

-- Make <CR> auto-select the first completion item and notify coc.nvim to
-- format on enter, <cr> could be remapped by other vim plugin
imap("<cr>", [[pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], expr_recursive)

nmap("gep", [[&diff ? ']c' : "\<Plug>(coc-diagnostic-prev)"]], expr_recursive)
nmap("gen", [[&diff ? '[c' : "\<Plug>(coc-diagnostic-next)"]], expr_recursive)

-- GoTo code navigation.
-- map('n', 'gd', [[<Plug>(coc-definition)]], recursive)
-- map('n', 'gy', [[<Plug>(coc-type-definition)]], recursive)
-- map('n', 'gi', [[<Plug>(coc-implementation)]], recursive)
-- map('n', 'gr', [[<Plug>(coc-references)]], recursive)
nmap("gd", [[<cmd>Telescope coc definitions<CR>]], recursive)
nmap("ge", [[<cmd>Telescope coc diagnostics<CR>]], recursive)
nmap("gE", [[<cmd>Telescope coc workspace_diagnostics<CR>]], recursive)
nmap("gi", [[<cmd>Telescope coc implementations<CR>]], recursive)
nmap("gr", [[<cmd>Telescope coc references<CR>]], recursive)
nmap("gw", [[<cmd>Telescope coc document_symbols<CR>]], recursive)
nmap("gW", [[<cmd>Telescope coc workspace_symbols<CR>]], recursive)
nmap("gwn", [[<cmd>CocCommand document.jumpToNextSymbol<CR>]], recursive)
nmap("gwp", [[<cmd>CocCommand document.jumpToPrevSymbol<CR>]], recursive)
nmap("gy", [[<cmd>Telescope coc type_definitions<CR>]], recursive)

-- Use K for show documentation in preview window
nmap("K", [[<cmd>lua __coc_show_documentation()<CR>]])

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
omap("af", [[<Plug>(coc-funcobj-a)]], recursive)
omap("am", [[<Plug>(coc-classobj-a)]], recursive)
omap("if", [[<Plug>(coc-funcobj-i)]], recursive)
omap("im", [[<Plug>(coc-classobj-i)]], recursive)
xmap("af", [[<Plug>(coc-funcobj-a)]], recursive)
xmap("am", [[<Plug>(coc-classobj-a)]], recursive)
xmap("if", [[<Plug>(coc-funcobj-i)]], recursive)
xmap("im", [[<Plug>(coc-classobj-i)]], recursive)

-- Use CTRL-S for selections ranges.
-- Requires 'textDocument/selectionRange' support of language server.
nmap("<C-s>", [[<Plug>(coc-range-select)]], { silent = true })
xmap("<C-s>", [[<Plug>(coc-range-select)]], { silent = true })

local opts = { noremap = true, silent = true, nowait = true, expr = true }

nmap("<C-f>", [[coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"]], opts)
nmap("<C-b>", [[coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"]], opts)
imap("<C-f>", [[coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"]], opts)
imap("<C-b>", [[coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"]], opts)
vmap("<C-f>", [[coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"]], opts)
vmap("<C-b>", [[coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"]], opts)

-- Keymapping for grep word under cursor with interactive mode
nmap("<leader>cG", [[:exe 'CocList -I --input='.expand('<cword>').' grep'<CR>]], { silent = true })

-- grep current word in current buffer
nmap("<leader>cg", [[:exe 'CocList -I --normal --input='.expand('<cword>').' words'<CR>]], { silent = true })

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
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: auto commands {{{
----------------------------------------------------------------------
lk.augroup("coc_autocommands", {
  {
    events = { "CursorHold" },
    targets = { "*" },
    command = "silent call CocActionAsync('highlight')",
  },
  {
    events = { "User CocJumpPlaceholder" },
    targets = { "<buffer>" },
    command = "call CocActionAsync('showSignatureHelp')",
  },
  {
    events = { "CmdwinEnter" },
    targets = { "*" },
    command = function()
      vim.b.coc_suggest_disable = 1
    end,
  },
  {
    events = { "FileType" },
    targets = { "TelescopePrompt" },
    command = function()
      vim.b.coc_pairs_disabled = { '"', "'", "(" }
    end,
  },
  {
    events = { "FileType" },
    targets = { "vim" },
    command = function()
      vim.b.coc_pairs_disabled = { '"' }
    end,
  },
})
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: commands {{{
----------------------------------------------------------------------
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
-- }}}
----------------------------------------------------------------------

vim.cmd("set tagfunc=CocTagFunc")

-- vim:foldmethod=marker
