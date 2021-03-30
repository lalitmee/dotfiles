R('nlua')
R('snippets')

local snip_plug = require('snippets')
local indent = require('snippets.utils').match_indentation

local snips = {}

-- global
snips._global = {
  ['todo'] = 'TODO(tjdevries): ',
  ['date'] = [[${=os.date("%Y-%m-%d")}]],
  ['rs'] = [[${=RandomString(25)}]]
}

-- lua
snips.lua = vim.tbl_deep_extend(
                'error', require('nlua.snippets').get_lua_snippets(), {
      get_parsed = [[local parsed = get_parsed($1)]],

      reload = [[require('plenary.reload').reload_module('$1')$0]]
    }
            )

-- json
snips.json = {
  testEntry = [[, {"text": "$1"}]],
  i = [["$1": "$2"]],
  e = [[, {"text": "$1: ${=RandomString(25)}", "score": $1}]]
}

-- rust
snips.rust = {}

snips.rust.mod_test = indent [[
#[cfg(test)]
mod tests {
  use super::*;

  $0
}
]]

snips.rust.test = indent [[
#[test]
fn $1() {
  $0
}]]

snips.javascript = { log = [[console.log({$1})]] }

snip_plug.snippets = snips
snip_plug.use_suggested_mappings()

-- TODO: Investigate this again.
require'snippets'.set_ux(require 'snippets.inserters.floaty')

local charset = {}
do -- [0-9a-zA-Z]
  -- for c = 48, 57  do table.insert(charset, string.char(c)) end
  for c = 65, 90 do
    table.insert(charset, string.char(c))
  end
  for c = 97, 122 do
    table.insert(charset, string.char(c))
  end
  table.insert(charset, ' ')
  table.insert(charset, ' ')
  table.insert(charset, ' ')
  table.insert(charset, ' ')
  table.insert(charset, ' ')
  table.insert(charset, ' ')
end

function RandomString(length)
  if not length or length <= 0 then
    return ''
  end
  math.randomseed(os.clock() ^ 5)
  return RandomString(length - 1) .. charset[math.random(1, #charset)]
end

-- <c-j> will jump backwards to the previous field.
-- If you jump before the first field, it will cancel the snippet.
vim.cmd [[inoremap <c-k> <cmd>lua return require'snippets'.advance_snippet(-1)<CR>]]

-- <c-k> will either expand the current snippet at the word or try to jump to
-- the next position for the snippet.
vim.cmd [[inoremap <c-j> <cmd>lua return require'snippets'.expand_or_advance(1)<CR>]]

