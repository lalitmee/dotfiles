local synIDattr = vim.fn.synIDattr
local hlID = vim.fn.hlID

local M = {}

--- Check if the current window has a winhighlight
--- which includes the specific target highlight
--- @param win_id integer
--- @vararg string
function M.has_win_highlight(win_id, ...)
  local win_hl = vim.wo[win_id].winhighlight
  local has_match = false
  for _, target in ipairs({ ... }) do
    if win_hl:match(target) ~= nil then
      has_match = true
      break
    end
  end
  return (win_hl ~= nil and has_match), win_hl
end

local function find(haystack, matcher)
  local found
  for _, needle in ipairs(haystack) do
    if matcher(needle) then
      found = needle
      break
    end
  end
  return found
end

---A mechanism to allow inheritance of the winhighlight of a specific
---group in a window
---@param win_id number
---@param target string
---@param name string
---@param default string
function M.adopt_winhighlight(win_id, target, name, default)
  name = name .. win_id
  local _, win_hl = M.has_win_highlight(win_id, target)
  local hl_exists = vim.fn.hlexists(name) > 0
  if not hl_exists then
    local parts = vim.split(win_hl, ',')
    local found = find(
                      parts, function(part)
          return part:match(target)
        end
                  )
    if found then
      local hl_group = vim.split(found, ':')[2]
      local bg = M.hl_value(hl_group, 'bg')
      local fg = M.hl_value(default, 'fg')
      local gui = M.hl_value(default, 'gui')
      M.highlight(name, { guibg = bg, guifg = fg, gui = gui })
    end
  end
  return name
end

--- TODO eventually move to using `nvim_set_hl`
--- however for the time being that expects colors
--- to be specified as rgb not hex
---@param name string
---@param opts table
function M.highlight(name, opts)
  local force = opts.force or false
  if name and vim.tbl_count(opts) > 0 then
    if opts.link and opts.link ~= '' then
      vim.cmd(
          'highlight' .. (force and '!' or '') .. ' link ' .. name .. ' ' ..
              opts.link
      )
    else
      local cmd = { 'highlight', name }
      if opts.guifg and opts.guifg ~= '' then
        table.insert(cmd, 'guifg=' .. opts.guifg)
      end
      if opts.guibg and opts.guibg ~= '' then
        table.insert(cmd, 'guibg=' .. opts.guibg)
      end
      if opts.gui and opts.gui ~= '' then
        table.insert(cmd, 'gui=' .. opts.gui)
      end
      if opts.guisp and opts.guisp ~= '' then
        table.insert(cmd, 'guisp=' .. opts.guisp)
      end
      if opts.cterm and opts.cterm ~= '' then
        table.insert(cmd, 'cterm=' .. opts.cterm)
      end
      vim.cmd(table.concat(cmd, ' '))
    end
  end
end

function M.hl_value(grp, attr)
  if attr == 'gui' then
    return M.gui_attr(grp)
  end
  return synIDattr(hlID(grp), attr)
end

function M.gui_attr(hl_group)
  local bold = M.hl_value(hl_group, 'bold')
  local italic = M.hl_value(hl_group, 'italic')
  local underline = M.hl_value(hl_group, 'underline')
  local gui = {}
  if bold ~= '' and tonumber(bold) > 0 then
    table.insert(gui, 'bold')
  end
  if italic ~= '' and tonumber(italic) > 0 then
    table.insert(gui, 'italic')
  end
  if underline ~= '' and tonumber(underline) > 0 then
    table.insert(gui, 'underline')
  end
  return table.concat(gui, ',')
end

function M.all(hls)
  for _, hl in ipairs(hls) do
    M.highlight(unpack(hl))
  end
end

return M
