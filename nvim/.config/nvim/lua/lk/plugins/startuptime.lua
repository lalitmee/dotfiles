local tweek = true

local function get_plugin()
    if tweek then
        return "tweekmonster/startuptime.vim"
    end
    return "dstein64/vim-startuptime"
end

local M = {
    get_plugin(),
    cmd = "StartupTime",
}

return M
