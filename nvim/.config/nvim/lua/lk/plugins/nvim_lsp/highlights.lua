-- highlights {{{
local highlight = require("lk/highlights")
local cursor_line_bg = highlight.hl_value("CursorLine", "bg")
highlight.all({
  { "LspReferenceText", { guibg = cursor_line_bg, gui = "none" } },
  { "LspReferenceRead", { guibg = cursor_line_bg, gui = "none" } },
  { "LspDiagnosticsSignHint", { guifg = "#fab005" } },
  { "LspDiagnosticsDefaultHint", { guifg = "#fab005" } },
  { "LspDiagnosticsDefaultError", { guifg = "#E06C75" } },
  { "LspDiagnosticsDefaultWarning", { guifg = "#ff922b" } },
  { "LspDiagnosticsDefaultInformation", { guifg = "#15aabf" } },
  {
    "LspDiagnosticsUnderlineError",
    { gui = "undercurl", guisp = "#E06C75", guifg = "none" },
  },
  {
    "LspDiagnosticsUnderlineHint",
    { gui = "undercurl", guisp = "#fab005", guifg = "none" },
  },
  {
    "LspDiagnosticsUnderlineWarning",
    { gui = "undercurl", guisp = "orange", guifg = "none" },
  },
  {
    "LspDiagnosticsUnderlineInformation",
    { gui = "undercurl", guisp = "#15aabf", guifg = "none" },
  },
  { "LspDiagnosticsFloatingWarning", { guibg = "NONE" } },
  { "LspDiagnosticsFloatingError", { guibg = "NONE" } },
  { "LspDiagnosticsFloatingHint", { guibg = "NONE" } },
  { "LspDiagnosticsFloatingInformation", { guibg = "NONE" } },
})
