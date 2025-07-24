local session = require("luasnip.session")

local env = session.config.snip_env
local s = env["s"]
local t = env["t"]
local i = env["i"]
local c = env["c"]
local f = env["f"]
local d = env["d"]
local sn = env["sn"]
local fmt = env["fmt"]
local rep = env["rep"]

local fn = vim.fn

return {
    -- adding a package to package.json file
    s(
        "npmp",
        fmt([["{}": "{}",]], {
            i(1, "package"),
            c(2, {
                t("1.0.0"),
                t("^1.0.0"),
                i("version", "1.0.0"),
            }),
        })
    ),
}
