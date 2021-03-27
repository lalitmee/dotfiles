local saga = require('lspsaga')

saga.init_lsp_saga {
  use_saga_diagnostic_sign = true,
  finder_action_keys = { vsplit = 'v', split = 's', quit = { 'q', '<ESC>' } },
  code_action_icon = '💡',
  code_action_prompt = { enable = true, sign = false, virtual_text = true }
}
