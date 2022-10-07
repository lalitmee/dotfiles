local ok, auto_pairs = lk.require("nvim-autopairs")
if not ok then
    return
end

auto_pairs.setup({
  disable_filetype = { "TelescopePrompt", "vim" },
})
