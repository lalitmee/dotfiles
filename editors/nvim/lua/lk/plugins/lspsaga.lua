local saga = require('lspsaga')
local nnoremap = lk_utils.nnoremap

saga.init_lsp_saga {
  use_saga_diagnostic_sign = false,
  finder_action_keys = { vsplit = 'v', split = 's', quit = { 'q', '<ESC>' } },
  code_action_icon = '💡',
  code_action_prompt = { enable = true, sign = false, virtual_text = true }
}

require('lk.highlights').highlight(
    'LspSagaLightbulb', { guifg = 'NONE', guibg = 'NONE' }
)

-- mappings
nnoremap('<localleader>ma', '<cmd>Lspsaga code_action<CR>')
nnoremap('<localleader>mA', '<cmd>Lspsaga range_code_action<CR>')
nnoremap('<localleader>mc', '<cmd>Lspsaga close_floaterm<CR>')
nnoremap('<localleader>md', '<cmd>Lspsaga lsp_finder<CR>')
nnoremap('<localleader>me', '<cmd>Lspsaga show_cursor_diagnostics<CR>')
nnoremap('<localleader>mh', '<cmd>Lspsaga hover_doc<CR>')
nnoremap('<localleader>ml', '<cmd>Lspsaga show_line_diagnostics<CR>')
nnoremap('<localleader>mn', '<cmd>Lspsaga diagnostic_jump_next<CR>')
nnoremap('<localleader>mo', '<cmd>Lspsaga open_floaterm<CR>')
nnoremap('<localleader>mp', '<cmd>Lspsaga diagnostic_jump_prev<CR>')
nnoremap('<localleader>mr', '<cmd>Lspsaga rename<CR>')
nnoremap('<localleader>mv', '<cmd>Lspsaga preview_definition<CR>')

-- scroll down hover doc
nnoremap(
    '<C-f>',
    [[<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>]]
)
-- scroll up hover doc
nnoremap(
    '<C-b>',
    [[<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>]]
)

require('lk.autocommands').augroup(
    'LspSagaCursorCommands', {
      {
        events = { 'CursorHold' },
        targets = { '*' },
        command = 'lua require(\'lspsaga.diagnostic\').show_cursor_diagnostics()'
      }
      -- {
      --   events = {"CompleteDone"},
      --   targets = {"*"},
      --   command = "lua require('lspsaga.signaturehelp').signature_help()"
      -- }
    }
)
