return {
    "Bryley/neoai.nvim",
    dependencies = {
        "MunifTanjim/nui.nvim",
    },
    cmd = {
        "NeoAI",
        "NeoAIOpen",
        "NeoAIClose",
        "NeoAIToggle",
        "NeoAIContext",
        "NeoAIContextOpen",
        "NeoAIContextClose",
        "NeoAIInject",
        "NeoAIInjectCode",
        "NeoAIInjectContext",
        "NeoAIInjectContextCode",
        "NeoAIShortcut",
    },
    keys = {
        { "<leader>as", desc = "Summarize Text" },
        { "<leader>ag", desc = "Generate Git Message" },
    },
    opts = {
        open_api_key_env = vim.env.OPEN_API_KEY,
    },
}
