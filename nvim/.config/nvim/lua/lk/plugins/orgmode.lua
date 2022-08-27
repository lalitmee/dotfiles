local ok, orgmode = lk.safe_require("orgmode")
if not ok then
  return
end

----------------------------------------------------------------------
-- NOTE: setup {{{
----------------------------------------------------------------------
orgmode.setup_ts_grammar()
orgmode.setup({
  org_default_notes_file = "~/Desktop/Github/dNotes/notes/index.org",
})
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: extra plugins setup {{{
----------------------------------------------------------------------
-- NOTE: org-bullets
local bullets_ok, bullets = lk.safe_require("org-bullets")
if bullets_ok then
  bullets.setup({
    concealcursor = true,
    symbols = {
      headlines = { "◉", "○", "✸", "✿" },
      checkboxes = {
        cancelled = { "", "OrgCancelled" },
        done = { "✓", "OrgDone" },
        todo = { "˟", "OrgTODO" },
      },
    },
  })
end

-- NOTE: headlines
require("headlines").setup()
-- }}}
----------------------------------------------------------------------
