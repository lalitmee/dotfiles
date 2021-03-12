require('bqf').setup(
    {
      auto_enable = true,
      preview = {
        auto_previw = true,
        win_height = 20,
        win_vheight = 20,
        delay_syntax = 80,
        border_chars = {
          '┃',
          '┃',
          '━',
          '━',
          '┏',
          '┓',
          '┗',
          '┛',
          '█'
        }
      },
      func_map = { vsplit = '', ptogglemode = 'z,', stoggleup = '' },
      filter = {
        fzf = { extra_opts = { '--bind', 'ctrl-o:toggle-all', '--prompt', '> ' } }
      }
    }
)
