local fmt = string.format

local function get_server_options(name)
    return require(fmt("plugins.lsp.servers.%s", name))
end

local clangd = get_server_options("clangd")
local gopls = get_server_options("gopls")
local lua_ls = get_server_options("lua_ls")
local rust_analyzer = get_server_options("rust_analyzer")
local emmet_ls = get_server_options("emmet_ls")
-- local tsserver = get_server_options("tsserver")

return {
    bashls = true,
    clangd = clangd,
    cssls = true,
    dockerls = true,
    emmet_ls = emmet_ls,
    gopls = gopls,
    jsonls = true,
    lua_ls = lua_ls,
    marksman = true,
    pyright = true,
    rust_analyzer = rust_analyzer,
    tailwindcss = true,
    taplo = true,
    -- tsserver = tsserver,
    vimls = true,
}
