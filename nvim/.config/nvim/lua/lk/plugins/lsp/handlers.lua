local lsp = vim.lsp

--------------------------------------------------------------------------------
-- NOTE: definition handler {{{
-- Jump directly to the first available definition every time.
--------------------------------------------------------------------------------
lsp.handlers["textDocument/definition"] = function(_, result)
  if not result or vim.tbl_isempty(result) then
    vim.notify("[LSP] Could not find definition", "info", { title = "[LSP] definition" })
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
  signs = true,
  underline = true,
  update_in_insert = false,
  virtual_text = {
    severity = nil,
    source = "if_many",
    prefix = "■", -- Could be '●', '▎', 'x'
  },
  float = { source = "always" },
})

vim.diagnostic.config({
  underline = true,
  virtual_text = {
    severity = nil,
    source = "if_many",
    format = nil,
  },
  signs = true,

  -- options for floating windows:
  float = {
    show_header = true,
    border = "rounded",
    source = "always",
    format = function(d)
      local t = vim.deepcopy(d)
      local code = d.code or d.user_data.lsp.code
      if code then
        t.message = string.format("%s [%s]", t.message, code):gsub("1. ", "")
      end
      return t.message
    end,
  },
  severity_sort = true,
  update_in_insert = false,
})

--- Restricts nvim's diagnostic signs to only the single most severe one per line
--- @see `:help vim.diagnostic`
local ns = vim.api.nvim_create_namespace("severe-diagnostics")
--- Get a reference to the original signs handler
local signs_handler = vim.diagnostic.handlers.signs
--- Override the built-in signs handler
vim.diagnostic.handlers.signs = {
  show = function(_, bufnr, _, opts)
    -- Get all diagnostics from the whole buffer rather than just the
    -- diagnostics passed to the handler
    local diagnostics = vim.diagnostic.get(bufnr)
    -- Find the "worst" diagnostic per line
    local max_severity_per_line = {}
    for _, d in pairs(diagnostics) do
      local m = max_severity_per_line[d.lnum]
      if not m or d.severity < m.severity then
        max_severity_per_line[d.lnum] = d
      end
    end
    -- Pass the filtered diagnostics (with our custom namespace) to
    -- the original handler
    signs_handler.show(ns, bufnr, vim.tbl_values(max_severity_per_line), opts)
  end,
  hide = function(_, bufnr)
    signs_handler.hide(ns, bufnr)
  end,
}

vim.diagnostic.config({})
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
    title = "[LSP] | " .. client.name,
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

-- -----------------------------------------------------------------------------
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
-- -----------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- NOTE: codelens handler {{{
--------------------------------------------------------------------------------
-- lsp.codelens.display = require('gl.codelens').display
-- }}}
--------------------------------------------------------------------------------

-- vim:foldmethod=marker
