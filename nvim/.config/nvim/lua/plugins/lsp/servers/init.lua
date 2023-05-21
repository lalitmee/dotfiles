local fmt = string.format

local function get_server_options(name)
    return require(fmt("plugins.lsp.servers.%s", name))
end

local clangd = get_server_options("clangd")
local emmet_ls = get_server_options("emmet_ls")
local gopls = get_server_options("gopls")
local lua_ls = get_server_options("lua_ls")
local rust_analyzer = get_server_options("rust_analyzer")

-- NOTE: not using this as this may be consuming more memory
-- local tsserver = get_server_options("tsserver")

return {
    bashls = true,
    clangd = clangd,
    cssls = true,
    dockerls = true,
    emmet_ls = emmet_ls,
    gopls = gopls,
    jsonls = true,
    pyright = true,
    marksman = true,
    rust_analyzer = rust_analyzer,
    lua_ls = lua_ls,
    tailwindcss = false,
    taplo = true,
    tsserver = true,
    vimls = true,
}
