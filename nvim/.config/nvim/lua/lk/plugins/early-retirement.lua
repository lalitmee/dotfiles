return {
    "chrisgrieser/nvim-early-retirement",
    event = { "VeryLazy" },
    opts = {
        -- if a buffer has been inactive for this many minutes, close it
        retirementAgeMins = 20,

        -- filetypes to ignore
        ignoredFiletypes = {},

        -- will not close the alternate file
        ignoreAltFile = true,

        -- will ignore buffers with unsaved changes. If false, the buffers will
        -- automatically be written and then closed.
        ignoreUnsavedChangesBufs = true,

        -- ignore non-empty buftypes, e.g. terminal buffers
        ignoreSpecialBuftypes = true,

        -- uses vim.notify for plugins like nvim-notify
        notificationOnAutoClose = false,
    },
}
