return {
    cmd = {
        "clangd",
        "--background-index",
        "--suggest-missing-includes",
        "--clang-tidy",
        "--header-insertion=iwyu",
    },
    -- Required for lsp-status
    init_options = {
        clangdFileStatus = true,
    },
}
