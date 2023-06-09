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

local fn = vim.fn

return {
    -- local var
    s("loc", fmt("local {} = {}", { i(1, "name"), i(2, "module/package") })),

    -- require
    s("locr", fmt("local {} = require('{}')", { i(1, "name"), rep(1) })),

    -- note
    s("note", fmt("-- NOTE: {}", { i(1, "description") })),

    -- todo
    s("todo", fmt("-- TODO: {}", { i(1, "description") })),

    -- stylua ignore
    s("stn", t("-- stylua: ignore")),

    -- require
    s(
        {
            trig = "req",
            name = "require module",
            dscr = "Require a module and set the import to the last word",
        },
        fmt([[local {} = require("{}")]], {
            f(function(import_name)
                local parts = vim.split(import_name[1][1], ".")
                return parts[#parts] or ""
            end, { 1 }),
            i(1),
        })
    ),
    s(
        {
            trig = "use",
            name = "packer use",
            dscr = {
                "packer use plugin block",
                "e.g.",
                "use {'author/plugin'}",
            },
        },
        fmt([[use {{"{}"{}}}]], {
            d(1, function()
                -- Get the author and URL in the clipboard and auto populate the author and project
                local default = s("", { i(1, "author"), t("/"), i(2, "plugin") })
                local clip = fn.getreg("*")
                if not vim.startswith(clip, "https://github.com/") then
                    return default
                end
                local parts = vim.split(clip, "/")
                if #parts < 2 then
                    return default
                end
                local author, project = parts[#parts - 1], parts[#parts]
                return s("", { t(author .. "/" .. project) })
            end),
            c(2, {
                fmt(
                    [[
              , config = function()
                require("{}").setup()
              end
          ]],
                    { i(1, "module") }
                ),
                t(""),
            }),
        })
    ),
    s("re", fmt('local {}, {} = lk.require("{}")', { i(1, "ok"), i(2, "package"), rep(2, "pacakge") })),

    s(
        "wk",
        fmt(
            [[
                local wk = require("which-key")
                wk.register({{
                    {3}
                }}, {{ mode = "{1}", prefix = "{2}" }})
            ]],
            {
                c(1, {
                    t("n"),
                    t("v"),
                }),
                c(2, {
                    t("<leader>"),
                    t("<localleader>"),
                }),
                c(3, {
                    fmt(
                        [[
                    [{1}] = {{{2}}}
                    ]],
                        {
                            i(1, "key"),
                            i(2, "value"),
                        }
                    ),
                    t(""),
                }),
            }
        )
    ),
    s("no", fmt("vim.notify(P({}))", { i(1, "var") })),
}
