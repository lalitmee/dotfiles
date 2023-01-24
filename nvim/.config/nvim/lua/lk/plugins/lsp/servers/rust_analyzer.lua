return {
    -- assist = {
    --     importEnforceGranularity = true,
    --     importPrefix = "crate",
    -- },
    -- cargo = {
    --     allFeatures = true,
    -- },
    -- checkOnSave = {
    --     command = "clippy",
    -- },
    inlayHints = { locationLinks = true },
    diagnostics = { enable = true, experimental = { enable = true } },
    hover = { actions = { enable = true } },
}
