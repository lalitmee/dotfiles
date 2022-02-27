local saga = require("lspsaga")
local nnoremap = lk_utils.nnoremap

saga.init_lsp_saga({
  use_saga_diagnostic_sign = true,
  finder_action_keys = { vsplit = "v", split = "s", quit = { "q", "<ESC>" } },
  code_action_icon = "💡",
  code_action_prompt = { enable = true, sign = true, virtual_text = false },
})

require("lk.highlights").highlight("LspSagaLightbulb", { guifg = "NONE", guibg = "NONE" })

-- scroll down hover doc
nnoremap("<C-f>", [[<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>]])
-- scroll up hover doc
nnoremap("<C-b>", [[<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>]])

require("lk.autocommands").augroup("LspSagaCursorCommands", {
  -- {
  --   events = { 'CursorHold' },
  --   targets = { '*' },
  --   command = 'lua require(\'lspsaga.diagnostic\').show_cursor_diagnostics()'
  -- },
  -- {
  --   events = { 'CompleteDone' },
  --   targets = { '*' },
  --   command = 'lua require(\'lspsaga.signaturehelp\').signature_help()'
  -- }
})
