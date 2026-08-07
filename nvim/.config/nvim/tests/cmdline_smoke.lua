local m = require("plugins.snacks.picker.cmdline")
assert(type(m.get_items) == "function")
assert(type(m.run_cmd) == "function")
assert(type(m.cmdline) == "function")
local items = m.get_items()
assert(type(items) == "table")
assert(#items > 0, "expected at least one command")
local has = false
for _, it in ipairs(items) do
    if it.kind == "command" then
        has = true
        break
    end
end
assert(has, "expected at least one kind == 'command' item")
m.run_cmd("version")
assert(select(1, pcall(vim.cmd, "definitely_not_a_command_xyz")) == false, "vim.cmd must raise on a bad command")
print("OK cmdline_smoke")
