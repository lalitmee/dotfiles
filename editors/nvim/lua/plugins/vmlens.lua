M = {}
local hlslens = require('hlslens')
local hlslens_started = false
local line_lens_bak

local override_line_lens = function(lnum, loc, idx, r_idx, count, hls_ns)
  local text, chunks
  if loc ~= 'c' then
    text = string.format('[%d]', idx)
    chunks = { { ' ', 'Ignore' }, { text, 'HlSearchLens' } }
  else
    text = string.format('[%d/%d]', idx, count)
    chunks = { { ' ', 'Ignore' }, { text, 'HlSearchLensCur' } }
    vim.api.nvim_buf_clear_namespace(0, hls_ns, lnum - 1, lnum)
  end
  vim.api.nvim_buf_set_virtual_text(0, hls_ns, lnum - 1, chunks, {})
end

function M.vmlens_start()
  if not hlslens then
    return
  end
  local config = hlslens.get_config()
  line_lens_bak = config.override_line_lens
  config.override_line_lens = override_line_lens
  hlslens_started = config.started
  if hlslens_started then
    hlslens.disable()
  end
  hlslens.start()
end

function M.vmlens_exit()
  if not hlslens then
    return
  end
  local config = hlslens.get_config()
  config.override_line_lens = line_lens_bak
  hlslens.disable()
  if hlslens_started then
    hlslens.start()
  end
end

return M
