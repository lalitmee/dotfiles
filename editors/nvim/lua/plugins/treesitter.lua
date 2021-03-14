require'nvim-treesitter.configs'.setup(
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
      indent = { enable = true },
      rainbow = { enable = true },
      refactor = {
        highlight_definitions = { enable = true },
        highlight_current_scope = { enable = false },
        navigation = {
          enable = true,
          keymaps = {
            goto_definition = 'gnd',
            list_definitions = 'gnD',
            list_definitions_toc = 'gO',
            goto_next_usage = '<a-*>',
            goto_previous_usage = '<a-#>'
          }
        },
        smart_rename = { enable = true, keymaps = { smart_rename = 'grs' } }
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
            [']]'] = '@class.outer'
          },
          goto_next_end = { [']M'] = '@function.outer', [']['] = '@class.outer' },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer'
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer'
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
      playground = { enable = true, updatetime = 25, persist_queries = false },
      query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { 'BufWrite', 'CursorHold' }
      }

    }
)
