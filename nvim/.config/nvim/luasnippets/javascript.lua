---@diagnostic disable: undefined-global

return {
    --------------------------------------------------------------------------------
    --  NOTE: html tags {{{
    --------------------------------------------------------------------------------
    s({ trig = "body", name = "body tag" }, fmt("<body>{}</body>", { i(1) })),
    s({ trig = "head", name = "head tag" }, fmt("<head>{}</head>", { i(1) })),
    s({ trig = "article", name = "article tag" }, fmt("<article>{}</article>", { i(1) })),
    s({ trig = "section", name = "section tag" }, fmt("<section>{}</section>", { i(1) })),
    s({ trig = "nav", name = "nav tag" }, fmt("<nav>{}</nav>", { i(1) })),
    s({ trig = "h1", name = "h1 tag" }, fmt("<h1>{}</h1>", { i(1) })),
    s({ trig = "h2", name = "h2 tag" }, fmt("<h2>{}</h2>", { i(1) })),
    s({ trig = "h3", name = "h3 tag" }, fmt("<h3>{}</h3>", { i(1) })),
    s({ trig = "h4", name = "h4 tag" }, fmt("<h4>{}</h4>", { i(1) })),
    s({ trig = "h5", name = "h5 tag" }, fmt("<h5>{}</h5>", { i(1) })),
    s({ trig = "h6", name = "h6 tag" }, fmt("<h6>{}</h6>", { i(1) })),
    s({ trig = "div", name = "div tag" }, fmt("<div>{}</div>", { i(1) })),
    s({ trig = "p", name = "p tag" }, fmt("<p>{}</p>", { i(1) })),
    s({ trig = "b", name = "b tag" }, fmt("<b>{}</b>", { i(1) })),
    s({ trig = "strong", name = "strong tag" }, fmt("<strong>{}</strong>", { i(1) })),
    s({ trig = "img", name = "img tag" }, fmt([[<img src="{}" alt="{}" />]], { i(1, "image"), i(2, "alt-value") })),
    s({ trig = "br", name = "br tag" }, t("<br />")),
    s({ trig = "hr", name = "br tag" }, t("<hr />")),
    -- }}}
    --------------------------------------------------------------------------------

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

    --------------------------------------------------------------------------------
    --  NOTE: React {{{
    --------------------------------------------------------------------------------
    --------------------------------------------------------------------------------
    --  NOTE: prop-type {{{
    --------------------------------------------------------------------------------
    -- with choices
    s({ trig = "ptd", name = "PropTypes" }, {
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
    }),
    -- }}}
    --------------------------------------------------------------------------------
    --------------------------------------------------------------------------------
    --  NOTE: components {{{
    --------------------------------------------------------------------------------
    s(
        { trig = "rfc", name = "react functional component" },
        fmt(
            [[
      function {} ({}) {{
        return (
          {}
        )
      }}

      export default {}
      ]],
            {
                i(1, "Component"),
                i(2, "props"),
                i(3, "<div></div>"),
                same(1),
            }
        )
    ),
    -- }}}
    --------------------------------------------------------------------------------

    --------------------------------------------------------------------------------
    --  NOTE: useSelector {{{
    --------------------------------------------------------------------------------
    s(
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
    -- }}}
    --------------------------------------------------------------------------------

    --------------------------------------------------------------------------------
    --  NOTE: useEffect {{{
    --------------------------------------------------------------------------------
    s(
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
    -- }}}
    --------------------------------------------------------------------------------

    --------------------------------------------------------------------------------
    --  NOTE: useState {{{
    --------------------------------------------------------------------------------
    s(
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
    -- }}}
    --------------------------------------------------------------------------------

    -- }}}
    --------------------------------------------------------------------------------
}
