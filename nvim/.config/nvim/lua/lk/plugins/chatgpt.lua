local M = {
    "jackMort/ChatGPT.nvim",
    cmd = {
        "ChatGPT",
        "ChatGPTRun",
        "ChatGPTActAs",
        "ChatGPTEditWithInstructions",
    },
}

M.init = function()
    lk.command("ChatGPTRun", function(opts)
        require("chatgpt").run_action(opts)
    end, {
        nargs = "*",
        range = true,
        complete = function()
            local match = {
                "add_tests",
                "docstring",
                "fix_bugs",
                "grammar_correction",
                "optimize_code",
                "summarize",
                "translate",
            }
            return match
        end,
    })
end

M.config = function()
    require("chatgpt").setup()
end

return M
