require('bqf').setup(
    {
      auto_enable = true,
      preview = { auto_previw = true, win_height = 20, win_vheight = 20 },
      func_map = { vsplit = '<C-v>' },
      filter = {
        fzf = {
          extra_opts = {
            '--bind',
            'ctrl-a:select-all,ctrl-d:deselect-all',
            '--prompt',
            'Filter > '
          }
        }
      }
    }
)
