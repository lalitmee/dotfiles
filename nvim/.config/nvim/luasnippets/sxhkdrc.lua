local session = require("luasnip.session")

local env = session.config.snip_env
local s = env["s"]
local t = env["t"]
local i = env["i"]
local c = env["c"]
local f = env["f"]
local d = env["d"]
local fmt = env["fmt"]
local rep = env["rep"]

local snippets = {
    s(
        {
            trig = "com",
            name = "doc comment",
            desc = "Comment for describing the below content",
        },
        fmt([[# {} -> {}]], {
            i(1, "classification"),
            i(2, "type"),
        })
    ),
}

local autosnippets = {}

return snippets, autosnippets
