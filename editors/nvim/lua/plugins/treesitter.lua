require('nvim-treesitter.configs').setup(
    {
      ensure_installed = {
        'bash',
        'c',
        'c_sharp',
        'cpp',
        'css',
        'fennel',
        'gdscript',
        'go',
        'graphql',
        'html',
        'java',
        'javascript',
        'json',
        'kotlin',
        'lua',
        'python',
        'ql',
        'query',
        'regex',
        'ruby',
        'rust',
        'teal',
        'toml',
        'typescript',
        'yaml'
      },
      highlight = { enable = true },
      autotag = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = ',v',
          node_incremental = ',v',
          scope_incremental = ']v',
          node_decremental = '[v'
        }
      },
      indent = { enable = true },
      rainbow = { enable = true },
      refactor = {
        highlight_definitions = { enable = true },
        highlight_current_scope = { enable = false },
        navigation = {
          enable = true,
          keymaps = {
            goto_definition = 'gtd',
            list_definitions = 'gtl',
            list_definitions_toc = 'gO',
            goto_next_usage = 'gtn',
            goto_previous_usage = 'gtp'
          }
        },
        smart_rename = { enable = true, keymaps = { smart_rename = 'gtr' } }
      },
      textobjects = {
        enable = true,
        swap = {
          enable = true,
          swap_next = { ['<leader>pn'] = '@parameter.inner' },
          swap_previous = { ['<leader>pN'] = '@parameter.inner' }
        },
        move = {
          enable = true,
          goto_next_start = {
            [']m'] = '@function.outer',
            [']c'] = '@class.outer'
          },
          goto_next_end = { [']M'] = '@function.outer', [']C'] = '@class.outer' },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[c'] = '@class.outer'
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[C'] = '@class.outer'
          }
        },
        tree_docs = { enable = true },
        lsp_interop = {
          enable = true,
          peek_definition_code = {
            ['df'] = '@function.outer',
            ['dF'] = '@class.outer'
          }
        }
      },
      playground = { enable = true, updatetime = 25, persist_queries = true },
      query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { 'BufWrite', 'CursorHold' }
      }
    }
)

local parsers = require 'nvim-treesitter.parsers'
local configs = parsers.get_parser_configs()
local ft_str = table.concat(
                   vim.tbl_map(
                       function(ft)
          return configs[ft].filetype or ft
        end, parsers.available_parsers()
                   ), ','
               )

vim.cmd(
    'autocmd! Filetype ' .. ft_str ..
        ' setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()'
)
