---@diagnostic disable: undefined-global

return {
  snippet({ trig = "td", name = "TODO" }, {
    c(1, {
      t("TODO: "),
      t("FIXME: "),
      t("HACK: "),
      t("BUG: "),
    }),
    i(0),
  }),
  snippet(
    { trig = "hr", name = "Header" },
    fmt(
      [[
            {1}
            {2} {3}
            {1}
            {4}
          ]],
      {
        f(function()
          local comment = string.format(vim.bo.commentstring:gsub(" ", "") or "#%s", "-")
          local col = vim.bo.textwidth or 80
          return comment .. string.rep("-", col - #comment)
        end),
        f(function()
          return vim.bo.commentstring:gsub("%%s", "")
        end),
        i(1, "HEADER"),
        i(0),
      }
    )
  ),
  snippet({ trig = "tt", wordTrig = true }, {
    t({ "╔" }),
    f(function()
      return "0"
    end, {}),
    t({ "1", "2" }),
    i(0),
  }),
  snippet({ trig = "bbox" }, {
    t({ "╔" }),
    f(replace_each("═"), { 1 }),
    t({ "╗", "║" }),
    i(1, { "content" }),
    t({ "║", "╚" }),
    f(replace_each("═"), { 1 }),
    t({ "╝" }),
    i(0),
  }),
  snippet({ trig = "sbox", wordTrig = true }, {
    t({ "*" }),
    f(replace_each("-"), { 1 }),
    t({ "*", "|" }),
    i(1, { "content" }),
    t({ "|", "*" }),
    f(replace_each("-"), { 1 }),
    t({ "*" }),
    i(0),
  }),
}

--   ls.parser.parse_snippet(
--     { trig = "foo" },
--     [[
-- ${$TM_SELECTED_TEXT} --  TM_SELECTED_TEXT The currently selected text or the empty string
-- ${$TM_CURRENT_LINE} --  TM_CURRENT_LINE The contents of the current line
-- ${$TM_CURRENT_WORD} --  TM_CURRENT_WORD The contents of the word under cursor or the empty string
-- ${$TM_LINE_INDEX} --  TM_LINE_INDEX The zero-index based line number
-- ${$TM_LINE_NUMBER} --  TM_LINE_NUMBER The one-index based line number
-- ${$TM_FILENAME} --  TM_FILENAME The filename of the current document
-- ${$TM_FILENAME_BASE} --  TM_FILENAME_BASE The filename of the current document without its extensions
-- ${$TM_DIRECTORY} --  TM_DIRECTORY The directory of the current document
-- ${$TM_FILEPATH} --  TM_FILEPATH The full file path of the current document
-- ${$RELATIVE_FILEPATH} --  RELATIVE_FILEPATH The relative (to the opened workspace or folder) file path of the current document
-- ${$CLIPBOARD} --  CLIPBOARD The contents of your clipboard
-- ${$WORKSPACE_NAME} --  WORKSPACE_NAME The name of the opened workspace or folder
-- ${$WORKSPACE_FOLDER} --  WORKSPACE_FOLDER The path of the opened workspace or folder
-- ${$CURRENT_YEAR} --  CURRENT_YEAR The current year
-- ${$CURRENT_YEAR_SHORT} --  CURRENT_YEAR_SHORT The current year's last two digits
-- ${$CURRENT_MONTH} --  CURRENT_MONTH The month as two digits (example '02')
-- ${$CURRENT_MONTH_NAME} --  CURRENT_MONTH_NAME The full name of the month (example 'July')
-- ${$CURRENT_MONTH_NAME_SHORT} --  CURRENT_MONTH_NAME_SHORT The short name of the month (example 'Jul')
-- ${$CURRENT_DATE} --  CURRENT_DATE The day of the month
-- ${$CURRENT_DAY_NAME} --  CURRENT_DAY_NAME The name of day (example 'Monday')
-- ${$CURRENT_DAY_NAME_SHORT} --  CURRENT_DAY_NAME_SHORT The short name of the day (example 'Mon')
-- ${$CURRENT_HOUR} --  CURRENT_HOUR The current hour in 24-hour clock format
-- ${$CURRENT_MINUTE} --  CURRENT_MINUTE The current minute
-- ${$CURRENT_SECOND} --  CURRENT_SECOND The current second
-- ${$CURRENT_SECONDS_UNIX} --  CURRENT_SECONDS_UNIX The number of seconds since the Unix epoch
-- ${$RANDOM} --  RANDOM 6 random Base-10 digits
-- ${$RANDOM_HEX} --  RANDOM_HEX 6 random Base-16 digits
-- ${$UUID} --  UUID A Version 4 UUID
-- ${$BLOCK_COMMENT_START} --  BLOCK_COMMENT_START Example output: in PHP /* or in HTML <!--
-- ${$BLOCK_COMMENT_END} --  BLOCK_COMMENT_END Example output: in PHP */ or in HTML -->
-- ${$LINE_COMMENT} --  LINE_COMMENT Example output: in PHP //
--   ]]
--
-- ),
