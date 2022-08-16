---@diagnostic disable: undefined-global

return {

  -- NOTE: debugger
  s("de", "debugger"),

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

  ------------------------------------------------------------------------------------------------------------------------
  -- prop-types
  ------------------------------------------------------------------------------------------------------------------------
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

  -- ------------------------------------------------------------------------------------------------------------------------
  -- -- functional component
  -- ------------------------------------------------------------------------------------------------------------------------
  -- s({ trig = "rfce", name = "react functional component" }, {
  --   i(1, "function "),
  --   i(2, "Component"),
  --   i(0),
  -- }),
}
