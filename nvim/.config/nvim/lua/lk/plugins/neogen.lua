local ok, neogen = lk.require("neogen")
if not ok then
  return
end

----------------------------------------------------------------------
-- NOTE: setup {{{
----------------------------------------------------------------------
neogen.setup({
  snippet_engine = "luasnip",
})
-- }}}
----------------------------------------------------------------------
