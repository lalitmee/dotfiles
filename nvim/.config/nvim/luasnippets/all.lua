local session = require("luasnip.session")

local env = session.config.snip_env
local s = env["s"]
local t = env["t"]
local i = env["i"]
local c = env["c"]
local f = env["f"]
local fmt = env["fmt"]

return {
    s({ trig = "td", name = "TODO" }, {
        f(function()
            return vim.bo.commentstring:gsub("%%s", "")
        end),
        c(1, {
            t("TODO: "),
            t("NOTE: "),
            t("WARN: "),
            t("FIXME: "),
            t("HACK: "),
            t("BUG: "),
        }),
        i(0),
    }),
    s(
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
    s(
        { trig = "cbox", name = "comment box" },
        fmt(
            [[
            {1}
            {2} {3}{4} {5}
            {1}
            {2}{6}
            {1}
            {7}
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
                t("NOTE: "),
                i(1, "description"),
                t("{{{"),
                t("}}}"),
                i(0),
            }
        )
    ),
    s(
        { trig = "fdm", name = "fold method marker comment" },
        fmt(
            [[
      {1}{2}
      ]],
            {
                f(function()
                    return vim.bo.commentstring:gsub("%%s", "")
                end),
                t("vim:fdm=marker"),
            }
        )
    ),
}

--   ls.parser.parse_s(
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
-- ${$RELATIVE_FILEPATH} --  RELATIVE_FILEPATH The relative (to the opened workspace or folder) file path of the current
-- document
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
