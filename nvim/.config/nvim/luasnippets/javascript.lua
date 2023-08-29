local session = require("luasnip.session")

local env = session.config.snip_env
local s = env["s"]
local d = env["d"]
local t = env["t"]
local i = env["i"]
local c = env["c"]
local f = env["f"]
local fmt = env["fmt"]
local sn = env["sn"]
local same = env["same"]
local rep = env["rep"]

local snippets = {

    -- NOTE: debugger
    s("de", t("debugger")),

    -- NOTE: console.log({name})
    s("clg", fmt("console.log({})", { i(1, "name") })),

    -- NOTE: console log with choices
    -- 1. console.log(object)
    -- 2. console.log('object', object)
    -- 3. console.log({object})
    s(
        "log",
        fmt("console.log({});", {
            c(1, {
                i(1, "basic"),
                sn(1, { t("'"), i(1, "labelled"), t("',"), same(1) }),
                sn(1, { t("{ "), i(1, "object"), t(" }") }),
            }),
        })
    ),

    s( -- prop-types
        { trig = "ptd", name = "PropTypes" },
        {
            i(1, "PropTypes."),
            c(1, {
                t("array"),
                t("bool"),
                t("element"),
                t("func"),
                t("node"),
                t("number"),
                t("object"),
                t("string"),
            }),
            c(2, {
                t(","),
                t(""),
            }),
            i(0),
        }
    ),

    s({ trig = "imr", name = "import react" }, t("import React from 'react'")),

    s( -- react functional component
        { trig = "rfc", name = "react functional component" },
        fmt(
            [[
                import React from 'react'

                function {} ({}) {{
                    return (
                        <div>
                            {}
                        </div>
                    )
                }}

                export default {}
            ]],
            {
                i(1, "Component"),
                i(2, "props"),
                i(3, "children"),
                same(1),
            }
        )
    ),

    s( -- useSelector with getResourceDataSelector
        { trig = "useS", name = "useSelector with getResourceDataSelector" },
        fmt(
            [[
        const {{ data: {}Data, isFetching: is{}DataFetching, error: is{}DataError }} =
            useSelector(state => getResourceDataSelector(state, {}, {}))
        ]],
            {
                i(1, "state"),
                same(1, { first = true }),
                same(1, { first = true }),
                i(2, "resource"),
                i(3, "type"),
            }
        )
    ),

    s( -- useEffect
        { trig = "useE", name = "useEffect with dependency" },
        fmt(
            [[
            useEffect(() => {{
                {}
            }}, [{}])
            ]],
            {
                i(1, "// content goes here"),
                i(2, "dependencies"),
            }
        )
    ),

    s( -- usestate
        { trig = "usest", name = "useState with repeat" },
        fmt(
            [[
            const [{}, set{}] = useState({})
            ]],
            {
                i(1, "state"),
                same(1, { first = true }),
                i(2, "initalState"),
            }
        )
    ),

    -- test cases snippets
    s(
        { trig = "mocks", name = "create mocks for the test case" },
        fmt(
            [[
        const {} = [
            {{
                request: {{
                    query: {}
                    variables: {{{}}},
                }},
                result: {{
                    data: {{{}}}
                }}
            }},
        ]
        ]],
            {
                i(1, "mocks"),
                i(2, "query"),
                i(3, "variables"),
                i(4, "data"),
            }
        )
    ),
}

local autosnippets = {
    -- s( -- for loop with dynamic variables
    --     { trig = "for([%w_]+)", regTrig = true },
    --     fmt(
    --         [[
    --             for (let {} = 1; {} <= {}; {}++) {{
    --                 {}
    --             }}
    --         ]],
    --         {
    --             d(1, function(_, snip)
    --                 return sn(1, i(1, snip.captures[1]))
    --             end),
    --             rep(1),
    --             i(2, "num"),
    --             rep(1),
    --             i(3, "// TODO"),
    --         }
    --     )
    -- ),

    s(
        { trig = "ff(%d%d%d%d)", regTrig = true, name = "todo for removing FF" },
        fmt([[// TODO: {} while removing QPD_{}]], {
            c(1, {
                t("remove this"),
                t("remove this block"),
                t("rename this without `New`"),
            }),
            f(function(_, snip)
                return snip.captures[1]
            end),
        })
    ),
}

return snippets, autosnippets
