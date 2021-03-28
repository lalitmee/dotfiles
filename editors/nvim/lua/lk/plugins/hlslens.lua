require('hlslens').setup(
    {
      -- enable hlslens after searching
      -- type: boolean
      auto_enable = true,
      -- if calm_down is true, stop hlslens when cursor is out of position range
      -- type: boolean
      calm_down = false,
      -- hackable function for customizing the virtual text
      -- type: function(lnum, loc, idx, r_idx, count, hls_ns)
      override_line_lens = nil
      -- override_line_lens = function(lnum, loc, idx, r_idx, count, hls_ns)
      --   local sfw = vim.v.searchforward == 1
      --   local indicator, text, chunks
      --   local a_r_idx = math.abs(r_idx)
      --   if a_r_idx > 1 then
      --     indicator = string.format(
      --                     '%d%s', a_r_idx, sfw ~= (r_idx > 1) and '▲' or '▼'
      --                 )
      --   elseif a_r_idx == 1 then
      --     indicator = sfw ~= (r_idx == 1) and '▲' or '▼'
      --   else
      --     indicator = ''
      --   end

      --   if loc ~= 'c' then
      --     text = string.format('[%s %d]', indicator, idx)
      --     chunks = { { ' ', 'Ignore' }, { text, 'HlSearchLens' } }
      --   else
      --     if indicator ~= '' then
      --       text = string.format('[%s %d/%d]', indicator, idx, count)
      --     else
      --       text = string.format('[%d/%d]', idx, count)
      --     end
      --     chunks = { { ' ', 'Ignore' }, { text, 'HlSearchLensCur' } }
      --     vim.api.nvim_buf_clear_namespace(0, hls_ns, lnum - 1, lnum)
      --   end
      --   vim.api.nvim_buf_set_virtual_text(0, hls_ns, lnum - 1, chunks, {})
      -- end
    }
)
