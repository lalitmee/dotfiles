local neogit = require('neogit')

neogit.setup {
  disable_commit_confirmation = true,
  integrations = { diffview = true }
}
