local fmt = string.format

local function get_server_options(name)
    return require(fmt("plugins.lsp.servers.%s", name))
end

local clangd = get_server_options("clangd")
local gopls = get_server_options("gopls")
local lua_ls = get_server_options("lua_ls")
local rust_analyzer = get_server_options("rust_analyzer")
local emmet_ls = get_server_options("emmet_ls")
local tailwindcss = get_server_options("tailwindcss")

return {
    bashls = false,
    clangd = clangd,
    copilot = false,
    cssls = false,
    dockerls = false,
    emmet_ls = emmet_ls,
    gopls = gopls,
    jsonls = false,
    lua_ls = lua_ls,
    marksman = false,
    pyright = false,
    rust_analyzer = rust_analyzer,
    tailwindcss = tailwindcss,
    taplo = false,
    theme_check = false,
    ts_ls = false,
    tsgo = false,
    vimls = false,
}
