local neofs = require('neofs')

neofs.setup {
  devicons = true,
  mappings = {
    ['<c-e>n'] = function(fm)
      fm.path = vim.fn.expand('~/.config/nvim/')
      fm.refresh()
    end
  }
}
