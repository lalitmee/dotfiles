-- local nnoremap = lk_utils.nnoremap
local vnoremap = lk_utils.vnoremap

vim.fn.sign_define('DapBreakpoint',
                   { text = '🛑', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped',
                   { text = '🟢', texthl = '', linehl = '', numhl = '' })

vnoremap('<leader>ddh',
         [[<cmd>lua require'dap.ui.variables'.visual_hover()<CR>]])
-- nnoremap('<localleader>d?', [[<cmd>lua require'dap.ui.variables'.scopes()<CR>]])
-- nnoremap('<localleader>dc', [[<cmd>lua require'dap'.continue()<CR>]])
-- nnoremap('<localleader>do', [[<cmd>lua require'dap'.step_over()<CR>]])
-- nnoremap('<localleader>di', [[<cmd>lua require'dap'.step_into()<CR>]])
-- nnoremap('<localleader>de', [[<cmd>lua require'dap'.step_out()<CR>]])
-- nnoremap('<localleader>db', [[<cmd>lua require'dap'.toggle_breakpoint()<CR>]])
-- nnoremap(
--     '<localleader>dB',
--     [[<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>]]
-- )
-- nnoremap(
--     '<localleader>dl',
--     [[<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>]]
-- )
-- nnoremap('<localleader>dr', [[<cmd>lua require'dap'.repl.open()<CR>]])
-- nnoremap('<localleader>dl', [[<cmd>lua require'dap'.repl.run_last()<CR>]])
