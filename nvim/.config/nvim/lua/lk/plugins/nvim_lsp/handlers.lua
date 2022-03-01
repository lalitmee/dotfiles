-- Jump directly to the first available definition every time.
vim.lsp.handlers["textDocument/definition"] = function(_, result)
  if not result or vim.tbl_isempty(result) then
    print("[LSP] Could not find definition")
    return
  end

  if vim.tbl_islist(result) then
    vim.lsp.util.jump_to_location(result[1], "utf-8")
  else
    vim.lsp.util.jump_to_location(result, "utf-8")
  end
end

vim.lsp.handlers["textDocument/publishDiagnostics"] =
  vim.lsp.with(vim.lsp.handlers["textDocument/publishDiagnostics"], {
    signs = { severity_limit = "Error" },
    underline = { severity_limit = "Warning" },
    virtual_text = true,
  })

vim.lsp.handlers["window/showMessage"] = function(_, result, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
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

-- -- LSP Rename symbol
-- local ns_rename = vim.api.nvim_create_namespace("lk_rename")
--
-- local saga_config = require("lspsaga").config_values
-- saga_config.rename_prompt_prefix = ">"
--
-- function MyLspRename()
--   local bufnr = vim.api.nvim_get_current_buf()
--   vim.api.nvim_buf_clear_namespace(bufnr, ns_rename, 0, -1)
--
--   local current_word = vim.fn.expand("<cword>")
--
--   local has_saga, saga = pcall(require, "lspsaga.rename")
--   if has_saga then
--     local line, col = vim.fn.line("."), vim.fn.col(".")
--     local contents = vim.api.nvim_buf_get_lines(bufnr, line - 1, line, false)[1]
--
--     local has_found_highlights, start, finish = false, 0, -1
--     while not has_found_highlights do
--       start, finish = contents:find(current_word, start + 1, true)
--
--       if not start or not finish then
--         break
--       end
--
--       if start <= col and finish >= col then
--         has_found_highlights = true
--       end
--     end
--
--     if has_found_highlights then
--       vim.api.nvim_buf_add_highlight(bufnr, ns_rename, "Visual", line - 1, start - 1, finish)
--       vim.cmd(
--         string.format(
--           "autocmd BufEnter <buffer=%s> ++once :call nvim_buf_clear_namespace(%s, %s, 0, -1)",
--           bufnr,
--           bufnr,
--           ns_rename
--         )
--       )
--     end
--
--     saga.rename()
--
--     -- Just make escape quit the window as well.
--     vim.api.nvim_buf_set_keymap(
--       0,
--       "n",
--       "<esc>",
--       '<cmd>lua require("lspsaga.rename").close_rename_win()<CR>',
--       { noremap = true, silent = true }
--     )
--
--     return
--   end
--
--   local plenary_window = require("plenary.window.float").percentage_range_window(0.5, 0.2)
--   vim.api.nvim_buf_set_option(plenary_window.bufnr, "buftype", "prompt")
--   vim.fn.prompt_setprompt(plenary_window.bufnr, string.format('Rename "%s" to > ', current_word))
--   vim.fn.prompt_setcallback(plenary_window.bufnr, function(text)
--     vim.api.nvim_win_close(plenary_window.win_id, true)
--
--     if text ~= "" then
--       vim.schedule(function()
--         vim.api.nvim_buf_delete(plenary_window.bufnr, { force = true })
--
--         vim.lsp.buf.rename(text)
--       end)
--     else
--       print("Nothing to rename!")
--     end
--   end)
--
--   vim.cmd([[startinsert]])
-- end

-- populate qf list with changes (if multiple files modified)
-- NOTE: now using nvim-notify
local function qf_rename()
  local position_params = vim.lsp.util.make_position_params()
  position_params.oldName = vim.fn.expand("<cword>")
  position_params.newName = vim.fn.input("Rename To> ", position_params.oldName)

  vim.lsp.buf_request(0, "textDocument/rename", position_params, function(err, result, ...)
    if not result or not result.changes then
      vim.notify(string.format("could not perform rename"), "error", {
        title = string.format("[LSP] rename: %s -> %s", position_params.oldName, position_params.newName),
        timeout = 500,
      })

      return
    end

    vim.lsp.handlers["textDocument/rename"](err, result, ...)

    local notification, entries = "", {}
    local num_files, num_updates = 0, 0
    for uri, edits in pairs(result.changes) do
      num_files = num_files + 1
      local bufnr = vim.uri_to_bufnr(uri)

      for _, edit in ipairs(edits) do
        local start_line = edit.range.start.line + 1
        local line = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, start_line, false)[1]

        num_updates = num_updates + 1
        table.insert(entries, {
          bufnr = bufnr,
          lnum = start_line,
          col = edit.range.start.character + 1,
          text = line,
        })
      end

      local short_uri = string.sub(vim.uri_to_fname(uri), #vim.fn.getcwd() + 2)
      notification = notification .. string.format("made %d change(s) in %s", #edits, short_uri)
    end

    -- print(string.format("updated %d instance(s) in %d file(s)", num_updates, num_files))
    vim.notify(notification, "info", {
      title = string.format("[LSP] rename: %s -> %s", position_params.oldName, position_params.newName),
      timeout = 2500,
    })

    if num_files > 1 then
      lk.qf_populate(entries, "r")
    end
  end)
end
vim.lsp.buf.rename = qf_rename

local M = {}

M.implementation = function()
  local params = vim.lsp.util.make_position_params()

  vim.lsp.buf_request(0, "textDocument/implementation", params, function(err, result, ctx, config)
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

    vim.lsp.handlers["textDocument/implementation"](err, result, ctx, config)
    vim.cmd([[normal! zz]])
  end)
end

local client_notifs = {}

local spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }

local function update_spinner(client_id, token)
  local notif_data = client_notifs[client_id][token]
  if notif_data and notif_data.spinner then
    local new_spinner = (notif_data.spinner + 1) % #spinner_frames
    local new_notif = vim.notify(nil, nil, {
      hide_from_history = true,
      icon = spinner_frames[new_spinner],
      replace = notif_data.notification,
    })
    client_notifs[client_id][token] = {
      notification = new_notif,
      spinner = new_spinner,
    }
    vim.defer_fn(function()
      update_spinner(client_id, token)
    end, 100)
  end
end

local function format_title(title, client)
  return client.name .. (#title > 0 and ": " .. title or "")
end

local function format_message(message, percentage)
  return (percentage and percentage .. "%\t" or "") .. (message or "")
end

vim.lsp.handlers["$/progress"] = function(_, result, ctx)
  local client_id = ctx.client_id
  local val = result.value
  if val.kind then
    if not client_notifs[client_id] then
      client_notifs[client_id] = {}
    end
    local notif_data = client_notifs[client_id][result.token]
    if val.kind == "begin" then
      local message = format_message(val.message or "Loading...", val.percentage)
      local notification = vim.notify(message, "info", {
        title = format_title(val.title, vim.lsp.get_client_by_id(client_id)),
        icon = spinner_frames[1],
        timeout = false,
        hide_from_history = true,
      })
      client_notifs[client_id][result.token] = {
        notification = notification,
        spinner = 1,
      }
      update_spinner(client_id, result.token)
    elseif val.kind == "report" and notif_data then
      local new_notif = vim.notify(
        format_message(val.message, val.percentage),
        "info",
        { replace = notif_data.notification, hide_from_history = false }
      )
      client_notifs[client_id][result.token] = {
        notification = new_notif,
        spinner = notif_data.spinner,
      }
    elseif val.kind == "end" and notif_data then
      local new_notif = vim.notify(
        val.message and format_message(val.message) or "Complete",
        "info",
        { icon = "", replace = notif_data.notification, timeout = 2000 }
      )
      client_notifs[client_id][result.token] = {
        notification = new_notif,
      }
    end
  end
end

-- vim.lsp.codelens.display = require('gl.codelens').display

function RenameWithQuickfix()
  local position_params = vim.lsp.util.make_position_params()
  local new_name = vim.fn.input("New Name > ")

  position_params.newName = new_name

  vim.lsp.buf_request(0, "textDocument/rename", position_params, function(err, method, result, ...)
    -- You can uncomment this to see what the result looks like.
    if false then
      print(vim.inspect(result))
    end
    vim.lsp.handlers["textDocument/rename"](err, method, result, ...)

    local entries = {}
    if result.changes then
      for uri, edits in pairs(result.changes) do
        local bufnr = vim.uri_to_bufnr(uri)

        for _, edit in ipairs(edits) do
          local start_line = edit.range.start.line + 1
          local line = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, start_line, false)[1]

          table.insert(entries, {
            bufnr = bufnr,
            lnum = start_line,
            col = edit.range.start.character + 1,
            text = line,
          })
        end
      end
    end

    vim.fn.setqflist(entries, "r")
  end)
end

return M
