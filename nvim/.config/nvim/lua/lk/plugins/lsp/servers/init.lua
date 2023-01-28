local fmt = string.format

local function get_server_options(name)
    return require(fmt("lk.plugins.lsp.servers.%s", name))
end

local clangd = get_server_options("clangd")
local sumneko_lua = get_server_options("sumneko_lua")
local rust_analyzer = get_server_options("rust_analyzer")
local tsserver = get_server_options("tsserver")
local gopls = get_server_options("gopls")

return {
    bashls = true,
    clangd = clangd,
    cssls = true,
    dockerls = true,
    emmet_ls = true,
    gopls = gopls,
    jsonls = true,
    pyright = true,
    remark_ls = true,
    rust_analyzer = rust_analyzer,
    sumneko_lua = sumneko_lua,
    tailwindcss = true,
    taplo = true,
    tsserver = tsserver,
    vimls = true,
}
