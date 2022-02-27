local autocommands = require("lk/autocommands")

autocommands.create({
  Terminal = {
    { "TermOpen", "*", [[startinsert]] },
    { "TermEnter", "*", [[startinsert]] },
    { "TermLeave", "*", [[stopinsert]] },
    { "TermClose", "*", [[stopinsert]] },
    {
      "TermClose",
      "term://*",
      [[if (expand('<afile>') !~ "fzf") && (expand('<afile>') !~ "ranger") && (expand('<afile>') !~ "coc") | call nvim_input('<CR>')  | endif]],
    },
    -- { 'FileType', 'markdown', [[MarkdownPreview]] },
    -- for showing the highlight on yanking
    {
      "TextYankPost",
      "*",
      [[lua vim.highlight.on_yank {higroup="IncSearch", timeout=150, on_visual=true}]],
    },
  },
})
