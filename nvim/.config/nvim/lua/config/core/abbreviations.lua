local function iabbrev(lhs, rhs)
    vim.keymap.set("ia", lhs, rhs)
end

local function cabbrev(lhs, rhs)
    vim.keymap.set("ca", lhs, rhs)
end

----------------------------------------------------------------------
--                    command line abbreviations                    --
----------------------------------------------------------------------
cabbrev("wq", [[execute "Format sync" <bar> wq]])

----------------------------------------------------------------------
--                       normal abbreviations                       --
----------------------------------------------------------------------
iabbrev("teh", "the")
iabbrev("tihs", "this")
iabbrev("funciton", "function")
