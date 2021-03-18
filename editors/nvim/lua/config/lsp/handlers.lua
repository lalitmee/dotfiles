-- fzf lsp handlers
local lsp_handlers = vim.lsp.handlers

-- telescpe handlers
lsp_handlers['textDocument/codeAction'] =
    require'telescope.builtin'.lsp_code_actions
lsp_handlers['textDocument/definition'] =
    require'telescope.builtin'.lsp_definitions
lsp_handlers['textDocument/references'] =
    require'telescope.builtin'.lsp_references
lsp_handlers['textDocument/documentSymbol'] =
    require'telescope.builtin'.lsp_document_symbols
lsp_handlers['workspace/symbol'] =
    require'telescope.builtin'.lsp_workspace_symbols

-- LSP definition
lsp_handlers['textDocument/definition'] =
    function(_, _, result)
      if not result or vim.tbl_isempty(result) then
        print('[LSP] Could not find definition')
        return
      end

      if vim.tbl_islist(result) then
        vim.lsp.util.jump_to_location(result[1])
      else
        vim.lsp.util.jump_to_location(result)
      end
    end

-- LSP diagnostics handler
-- vim.lsp.handlers['textDocument/publishDiagnostics'] =
--     function(...)
--       vim.lsp.handlers['textDocument/publishDiagnostics'] =
--           vim.lsp.with(
--               vim.lsp.diagnostic.on_publish_diagnostics, {
--                 underline = true,
--                 -- virtual_text = true,
--                 signs = true,
--                 update_in_insert = true
--               }
--           )(...)
--       pcall(vim.lsp.diagnostic.set_loclist, { open_loclist = false })
--     end

vim.lsp.handlers['textDocument/publishDiagnostics'] =
    vim.lsp.with(
        require('lsp_extensions.workspace.diagnostic').handler,
        { signs = { severity_limit = 'Error' } }
    )

-- LSP hover
lsp_handlers['textDocument/hover'] = require('lspsaga.hover').handler

-- LSP show line diagnostics
vim.lsp.diagnostic.show_line_diagnostics =
    require('lspsaga.diagnostic').show_line_diagnostics

-- LSP Rename symbol
local ns_rename = vim.api.nvim_create_namespace('tj_rename')

local saga_config = require('lspsaga').config_values
saga_config.rename_prompt_prefix = '>'

function MyLspRename()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(bufnr, ns_rename, 0, -1)

  local current_word = vim.fn.expand('<cword>')

  local has_saga, saga = pcall(require, 'lspsaga.rename')
  if has_saga then
    local line, col = vim.fn.line('.'), vim.fn.col('.')
    local contents = vim.api.nvim_buf_get_lines(bufnr, line - 1, line, false)[1]

    local has_found_highlights, start, finish = false, 0, -1
    while not has_found_highlights do
      start, finish = contents:find(current_word, start + 1, true)

      if not start or not finish then
        break
      end

      if start <= col and finish >= col then
        has_found_highlights = true
      end
    end

    if has_found_highlights then
      vim.api.nvim_buf_add_highlight(
          bufnr, ns_rename, 'Visual', line - 1, start - 1, finish
      )
      vim.cmd(
          string.format(
              'autocmd BufEnter <buffer=%s> ++once :call nvim_buf_clear_namespace(%s, %s, 0, -1)',
              bufnr, bufnr, ns_rename
          )
      )
    end

    saga.rename()

    -- Just make escape quit the window as well.
    vim.api.nvim_buf_set_keymap(
        0, 'n', '<esc>',
        '<cmd>lua require("lspsaga.rename").close_rename_win()<CR>',
        { noremap = true, silent = true }
    )

    return
  end

  local plenary_window =
      require('plenary.window.float').percentage_range_window(0.5, 0.2)
  vim.api.nvim_buf_set_option(plenary_window.bufnr, 'buftype', 'prompt')
  vim.fn.prompt_setprompt(
      plenary_window.bufnr, string.format('Rename "%s" to > ', current_word)
  )
  vim.fn.prompt_setcallback(
      plenary_window.bufnr, function(text)
        vim.api.nvim_win_close(plenary_window.win_id, true)

        if text ~= '' then
          vim.schedule(
              function()
                vim.api.nvim_buf_delete(plenary_window.bufnr, { force = true })

                vim.lsp.buf.rename(text)
              end
          )
        else
          print('Nothing to rename!')
        end
      end
  )

  vim.cmd [[startinsert]]
end
