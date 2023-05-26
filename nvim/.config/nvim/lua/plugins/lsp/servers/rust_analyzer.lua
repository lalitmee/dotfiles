return {
    inlayHints = { locationLinks = true },
    diagnostics = { enable = true, experimental = { enable = true } },
    hover = { actions = { enable = true } },
    procMacro = { enable = true },
    cargo = { allFeatures = true },
    checkOnSave = {
        command = "clippy",
        extraArgs = { "--no-deps" },
    },
}
