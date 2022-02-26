local notify = require 'notify'

local override = require 'lk.plugins.nvim_lsp.override'

-- Jump directly to the first available definition every time.
vim.lsp.handlers['textDocument/definition'] = function(_, result)
  if not result or vim.tbl_isempty(result) then
    print '[LSP] Could not find definition'
    return
  end

  if vim.tbl_islist(result) then
    vim.lsp.util.jump_to_location(result[1], 'utf-8')
  else
    vim.lsp.util.jump_to_location(result, 'utf-8')
  end
end

vim.lsp.handlers['textDocument/publishDiagnostics'] =
    vim.lsp.with(vim.lsp.handlers['textDocument/publishDiagnostics'], {
      signs = { severity_limit = 'Error' },
      underline = { severity_limit = 'Warning' },
      virtual_text = true,
    })

vim.lsp.handlers['window/showMessage'] =
    function(_, result, ctx)
      local client = vim.lsp.get_client_by_id(ctx.client_id)
      local lvl = ({ 'ERROR', 'WARN', 'INFO', 'DEBUG' })[result.type]
      notify({ result.message }, lvl, {
        title = 'LSP | ' .. client.name,
        timeout = 10000,
        keep = function()
          return lvl == 'ERROR' or lvl == 'WARN'
        end,
      })
    end

-- LSP Rename symbol
local ns_rename = vim.api.nvim_create_namespace('lk_rename')

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
      vim.api.nvim_buf_add_highlight(bufnr, ns_rename, 'Visual', line - 1,
                                     start - 1, finish)
      vim.cmd(string.format(
                  'autocmd BufEnter <buffer=%s> ++once :call nvim_buf_clear_namespace(%s, %s, 0, -1)',
                  bufnr, bufnr, ns_rename))
    end

    saga.rename()

    -- Just make escape quit the window as well.
    vim.api.nvim_buf_set_keymap(0, 'n', '<esc>',
                                '<cmd>lua require("lspsaga.rename").close_rename_win()<CR>',
                                { noremap = true, silent = true })

    return
  end

  local plenary_window =
      require('plenary.window.float').percentage_range_window(0.5, 0.2)
  vim.api.nvim_buf_set_option(plenary_window.bufnr, 'buftype', 'prompt')
  vim.fn.prompt_setprompt(plenary_window.bufnr,
                          string.format('Rename "%s" to > ', current_word))
  vim.fn.prompt_setcallback(plenary_window.bufnr, function(text)
    vim.api.nvim_win_close(plenary_window.win_id, true)

    if text ~= '' then
      vim.schedule(function()
        vim.api.nvim_buf_delete(plenary_window.bufnr, { force = true })

        vim.lsp.buf.rename(text)
      end)
    else
      print('Nothing to rename!')
    end
  end)

  vim.cmd [[startinsert]]
end

local M = {}

M.implementation = function()
  local params = vim.lsp.util.make_position_params()

  vim.lsp.buf_request(0, 'textDocument/implementation', params,
                      function(err, result, ctx, config)
    local bufnr = ctx.bufnr
    local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')

    -- In go code, I do not like to see any mocks for impls
    if ft == 'go' then
      local new_result = vim.tbl_filter(function(v)
        return not string.find(v.uri, 'mock_')
      end, result)

      if #new_result > 0 then
        result = new_result
      end
    end

    vim.lsp.handlers['textDocument/implementation'](err, result, ctx, config)
    vim.cmd [[normal! zz]]
  end)
end

-- vim.lsp.codelens.display = require('gl.codelens').display

return M
