local nonicons = require('nvim-nonicons')

require'nvim-web-devicons'.setup {
  -- override = {
  --   ['default_icon'] = { icon = '', color = '#6d8086', name = 'Default' },
  --   ['.gitignore'] = { icon = '', color = '#41535b', name = 'GitIgnore' },
  --   ['html'] = { icon = '', color = '#e34c26', name = 'Html' },
  --   ['lua'] = { icon = '', color = '#51a0cf', name = 'Lua' },
  --   ['js'] = { icon = '', color = '#cbcb41', name = 'Js' },
  --   ['json'] = { icon = '', color = '#cbcb41', name = 'Json' },
  --   ['jsx'] = { icon = '', color = '#519aba', name = 'Jsx' },
  --   ['toml'] = { icon = '', color = '#6d8086', name = 'Toml' },
  --   ['ts'] = { icon = '', color = '#519aba', name = 'Ts' },
  --   ['tsx'] = { icon = '', color = '#519aba', name = 'Tsx' },
  --   ['vim'] = { icon = '', color = '#019833', name = 'Vim' },
  --   ['markdown'] = { icon = '', color = '#519aba', name = 'Markdown' },
  --   ['md'] = { icon = '', color = '#519aba', name = 'Md' },
  --   ['yaml'] = { icon = '', color = '#6d8086', name = 'Yaml' },
  --   ['yml'] = { icon = '', color = '#6d8086', name = 'Yaml' },
  --   ['license'] = { icon = '', color = '#d0bf41', name = 'License' },
  --   ['LICENSE'] = { icon = '', color = '#d0bf41', name = 'License' },
  --   ['Dockerfile'] = { icon = '', color = '#0db7ed', name = 'Dockerfile' }
  -- },
  -- default = true
  get_icons = nonicons
}
