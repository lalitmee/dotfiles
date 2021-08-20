-- Find files interactively ( using Libuv )
require('fuzzy').interactive_finder {}

-- Find files recursively ( using Libuv )
require('fuzzy').file_finder {}

-- Search for text ( using Libuv )
require('fuzzy').grep {}

-- Search current buffer
require('fuzzy').buffer_lines {}

-- Search in recent files (file history)
require('fuzzy').mru {}

-- Search in commands
require('fuzzy').commands {}

-- Search in command history
require('fuzzy').history {}

-- Switch to any open buffer
require('fuzzy').buffers {}

-- Search LSP docuemnt symbols
require('fuzzy').lsp_document_symbols {}

-- Search LSP workspace symbols
require('fuzzy').lsp_workspace_symbols {}
