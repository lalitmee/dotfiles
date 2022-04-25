---@diagnostic disable: undefined-global

return {

  -- console.log({name})
  snippet("clg", fmt("console.log({})", { i(1, "name") })),
}
