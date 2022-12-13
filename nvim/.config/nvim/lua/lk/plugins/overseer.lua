local ok, overseer = lk.require("overseer")
if not ok then
    return
end

overseer.setup({
    templates = {
        { "builtin", { "user.cpp_build", "user.run_script" } },
    },
})
