---@diagnostic disable: undefined-global

return {

  -- console.log({name})
  snippet("clg", fmt("console.log({})", { i(1, "name") })),

  ------------------------------------------------------------------------------------------------------------------------
  -- prop-types
  ------------------------------------------------------------------------------------------------------------------------
  -- simple

  snippet({ trig = "ptd", name = "PropTypes" }, {
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
}
