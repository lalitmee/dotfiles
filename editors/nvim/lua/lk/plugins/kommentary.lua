local config = require('kommentary.config')

config.use_extended_mappings()

config.configure_language(
    'default', {
      prefer_single_line_comments = true,
      use_consistent_indentation = true,
      ignore_whitespace = true
    }
)
