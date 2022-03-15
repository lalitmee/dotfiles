local ls = require("luasnip")
local s = ls.s
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node
local rep = require("luasnip.extras").rep

ls.snippets = {
  all = {
    -- ls.parser.parse_snippet("expand", "-- this is just expanded thing"),
  },
  lua = {
    -- require
    s("req", fmt("local {} = require('{}')", { i(1, "name"), rep(1) })),

    -- note
    s("note", fmt("-- NOTE: {}", { i(1, "description") })),

    -- todo
    s("todo", fmt("-- TODO: {}", { i(1, "description") })),
  },
}
