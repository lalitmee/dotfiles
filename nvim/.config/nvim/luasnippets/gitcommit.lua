local session = require("luasnip.session")

local env = session.config.snip_env
local s = env["s"]
local t = env["t"]
local i = env["i"]
local c = env["c"]
local f = env["f"]
local fmt = env["fmt"]
local fmta = env["fmta"]

return {
    s({
        trig = "sp",
        name = "add spell words commit message",
    }, t("chore(spell): add more words to spell file")),

    s({
        trig = "pk",
        name = "update package lock file",
    }, t("chore(lockfile): update packages")),

    s({
        trig = "sl",
        name = "update second brain backup logs",
    }, t("chore(second-brain): update second brain backup logs")),

    s({
        trig = "gtodo",
        name = "git commit for todo",
    }, c(1, { t("feat(todo): add work todo"), t("feat(todo): add personal todo") })),

    s(
        {
            trig = "nes",
            name = "initial commit for fe-core package",
        },
        fmta(
            [[
            feat(<package>): initial commit

            copy of nykaa's package
        ]],
            {
                package = i(1, "package"),
            }
        )
    ),
}
