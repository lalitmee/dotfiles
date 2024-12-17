local session = require("luasnip.session")

local env = session.config.snip_env
local s = env["s"]
local t = env["t"]
local i = env["i"]
local c = env["c"]
local f = env["f"]
local fmt = env["fmt"]

return {
    s({
        trig = "sp",
        name = "add spell words commit message",
    }, t("chore(spell): add more words to spell file")),
}
