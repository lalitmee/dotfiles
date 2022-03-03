local lsp = vim.lsp

--------------------------------------------------------------------------------
-- NOTE: definition handler {{{
-- Jump directly to the first available definition every time.
--------------------------------------------------------------------------------
lsp.handlers["textDocument/definition"] = function(_, result)
  if not result or vim.tbl_isempty(result) then
    print("[LSP] Could not find definition")
    return
  end

  if vim.tbl_islist(result) then
    lsp.util.jump_to_location(result[1], "utf-8")
  else
    lsp.util.jump_to_location(result, "utf-8")
  end
end
-- }}}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- NOTE: publish diagnostics handler {{{
--------------------------------------------------------------------------------
lsp.handlers["textDocument/publishDiagnostics"] = lsp.with(lsp.handlers["textDocument/publishDiagnostics"], {
  signs = { severity_limit = "Error" },
  underline = { severity_limit = "Warning" },
  virtual_text = true,
})
-- }}}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- NOTE: rename handler {{{
--------------------------------------------------------------------------------
-- LSP Rename symbol
local lk_rename = vim.api.nvim_create_namespace("lk_rename")
local saga_config = require("lspsaga").config_values
saga_config.rename_prompt_prefix = ">"

local function lsp_rename()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(bufnr, lk_rename, 0, -1)

  local current_word = vim.fn.expand("<cword>")

  local has_saga, saga = pcall(require, "lspsaga.rename")
  if has_saga then
    local line, col = vim.fn.line("."), vim.fn.col(".")
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
      vim.api.nvim_buf_add_highlight(bufnr, lk_rename, "Visual", line - 1, start - 1, finish)
      vim.cmd(
        string.format(
          "autocmd BufEnter <buffer=%s> ++once :call nvim_buf_clear_namespace(%s, %s, 0, -1)",
          bufnr,
          bufnr,
          lk_rename
        )
      )
    end
    saga.rename()

    -- Just make escape quit the window as well.
    vim.api.nvim_buf_set_keymap(
      0,
      "n",
      "<esc>",
      '<cmd>lua require("lspsaga.rename").close_rename_win()<CR>',
      { noremap = true, silent = true }
    )
    return
  end

  local plenary_window = require("plenary.window.float").percentage_range_window(0.5, 0.2)
  vim.api.nvim_buf_set_option(plenary_window.bufnr, "buftype", "prompt")
  vim.fn.prompt_setprompt(plenary_window.bufnr, string.format('Rename "%s" to > ', current_word))
  vim.fn.prompt_setcallback(plenary_window.bufnr, function(text)
    vim.api.nvim_win_close(plenary_window.win_id, true)
    if text ~= "" then
      vim.schedule(function()
        vim.api.nvim_buf_delete(plenary_window.bufnr, { force = true })
        vim.lsp.buf.rename(text)
      end)
    else
      print("Nothing to rename!")
    end
  end)

  vim.cmd([[startinsert]])
end

vim.lsp.buf.rename = lsp_rename
-- }}}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- NOTE: hover handler {{{
--------------------------------------------------------------------------------
local max_width = math.max(math.floor(vim.o.columns * 0.7), 100)
local max_height = math.max(math.floor(vim.o.lines * 0.3), 30)

-- NOTE: the hover handler returns the bufnr,winnr so can be used for mappings
lsp.handlers["textDocument/hover"] = lsp.with(
  lsp.handlers.hover,
  { border = "rounded", max_width = max_width, max_height = max_height }
)
-- }}}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- NOTE: signature help handler {{{
--------------------------------------------------------------------------------
lsp.handlers["textDocument/signatureHelp"] = lsp.with(lsp.handlers.signature_help, {
  border = "rounded",
  max_width = max_width,
  max_height = max_height,
})
-- }}}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- NOTE: show message handler {{{
--------------------------------------------------------------------------------
lsp.handlers["window/showMessage"] = function(_, result, ctx)
  local client = lsp.get_client_by_id(ctx.client_id)
  local lvl = ({
    "ERROR",
    "WARN",
    "INFO",
    "DEBUG",
  })[result.type]
  vim.notify({ result.message }, lvl, {
    title = "LSP | " .. client.name,
    timeout = 10000,
    keep = function()
      return lvl == "ERROR" or lvl == "WARN"
    end,
  })
end
-- }}}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- NOTE: implementation handler {{{
--------------------------------------------------------------------------------
local implementation = function()
  local params = lsp.util.make_position_params()

  lsp.buf_request(0, "textDocument/implementation", params, function(err, result, ctx, config)
    local bufnr = ctx.bufnr
    local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")

    -- In go code, I do not like to see any mocks for impls
    if ft == "go" then
      local new_result = vim.tbl_filter(function(v)
        return not string.find(v.uri, "mock_")
      end, result)

      if #new_result > 0 then
        result = new_result
      end
    end

    lsp.handlers["textDocument/implementation"](err, result, ctx, config)
    vim.cmd([[normal! zz]])
  end)
end
lsp.handlers["textDocument/implementation"] = implementation
-- }}}
--------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------
-- -- NOTE: progress handler {{{
-- --------------------------------------------------------------------------------
-- local client_notifs = {}
--
-- local spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }
--
-- local function update_spinner(client_id, token)
--   local notif_data = client_notifs[client_id][token]
--   if notif_data and notif_data.spinner then
--     local new_spinner = (notif_data.spinner + 1) % #spinner_frames
--     local new_notif = vim.notify(nil, nil, {
--       hide_from_history = true,
--       icon = spinner_frames[new_spinner],
--       replace = notif_data.notification,
--     })
--     client_notifs[client_id][token] = {
--       notification = new_notif,
--       spinner = new_spinner,
--     }
--     vim.defer_fn(function()
--       update_spinner(client_id, token)
--     end, 100)
--   end
-- end
--
-- local function format_title(title, client)
--   return client.name .. (#title > 0 and ": " .. title or "")
-- end
--
-- local function format_message(message, percentage)
--   return (percentage and percentage .. "%\t" or "") .. (message or "")
-- end
--
-- lsp.handlers["$/progress"] = function(_, result, ctx)
--   local client_id = ctx.client_id
--   local val = result.value
--   if val.kind then
--     if not client_notifs[client_id] then
--       client_notifs[client_id] = {}
--     end
--     local notif_data = client_notifs[client_id][result.token]
--     if val.kind == "begin" then
--       local message = format_message(val.message or "Loading...", val.percentage)
--       local notification = vim.notify(message, "info", {
--         title = format_title(val.title, lsp.get_client_by_id(client_id)),
--         icon = spinner_frames[1],
--         timeout = false,
--         hide_from_history = true,
--       })
--       client_notifs[client_id][result.token] = {
--         notification = notification,
--         spinner = 1,
--       }
--       update_spinner(client_id, result.token)
--     elseif val.kind == "report" and notif_data then
--       local new_notif = vim.notify(
--         format_message(val.message, val.percentage),
--         "info",
--         { replace = notif_data.notification, hide_from_history = false }
--       )
--       client_notifs[client_id][result.token] = {
--         notification = new_notif,
--         spinner = notif_data.spinner,
--       }
--     elseif val.kind == "end" and notif_data then
--       local new_notif = vim.notify(
--         val.message and format_message(val.message) or "Complete",
--         "info",
--         { icon = "", replace = notif_data.notification, timeout = 2000 }
--       )
--       client_notifs[client_id][result.token] = {
--         notification = new_notif,
--       }
--     end
--   end
-- end
-- -- }}}
-- --------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- NOTE: codelens handler {{{
--------------------------------------------------------------------------------
-- lsp.codelens.display = require('gl.codelens').display
-- }}}
--------------------------------------------------------------------------------

-- vim:foldmethod=marker
