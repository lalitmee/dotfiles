require("which-key").add({
    { "<localleader>a", group = "sidekick", mode = { "n", "v" } },
})

require("sidekick").setup({
    cli = {
        mux = { backend = "tmux", enabled = true },
        win = { split = { width = 100 } },
    },
})

local cli = require("sidekick.cli")
local maps = {
    { "<leader>.", function() cli.toggle() end, "Sidekick Toggle", { "n", "x" } },
    { "<localleader>aa", function() cli.toggle({ focus = true }) end, "Sidekick CLI Toggle", { "n", "v" } },
    { "<localleader>as", function() cli.select({ filter = { installed = true } }) end, "Select CLI" },
    { "<localleader>ad", function() cli.close() end, "Detach a CLI Session" },
    { "<localleader>ac", function() cli.toggle({ name = "claude", focus = true }) end, "Sidekick Claude Toggle", { "n", "v" } },
    { "<localleader>ag", function() cli.toggle({ name = "gemini", focus = true }) end, "Sidekick Gemini Toggle", { "n", "v" } },
    { "<localleader>ao", function() cli.toggle({ name = "opencode", focus = true }) end, "Sidekick Opencode Toggle", { "n", "v" } },
    { "<localleader>ax", function() cli.toggle({ name = "codex", focus = true }) end, "Sidekick Codex Toggle", { "n", "v" } },
    { "<localleader>ah", function() cli.toggle({ name = "copilot", focus = true }) end, "Sidekick Copilot Toggle", { "n", "v" } },
    { "<localleader>ak", function() cli.toggle({ name = "grok", focus = true }) end, "Sidekick Grok Toggle", { "n", "v" } },
    { "<localleader>ap", function() cli.prompt() end, "Sidekick Ask Prompt", { "n", "x" } },
    { "<localleader>at", function() cli.send({ msg = "{this}" }) end, "Send This", { "n", "x" } },
    { "<localleader>af", function() cli.send({ msg = "{file}" }) end, "Send File", { "n", "x" } },
    { "<localleader>av", function() cli.send({ msg = "{selection}" }) end, "Send Visual Selection", { "x" } },
}

for _, map in ipairs(maps) do
    vim.keymap.set(map[4] or "n", map[1], map[2], { desc = map[3] })
end
