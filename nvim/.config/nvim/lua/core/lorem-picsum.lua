local command = lk.command

local function parseInt(str)
    return str:match("^%-?%d+$")
end

local function append_lorem_picsum_url()
    local width = parseInt(vim.fn.input("width: "))
    local height = parseInt(vim.fn.input("height: "))

    if width and height then
        local curl = require("plenary.curl")

        local res = curl.get("https://picsum.photos/" .. width .. "/" .. height, {})
        local url = res and res.headers[3]:sub(11)

        local cursor = vim.api.nvim_win_get_cursor(0)
        local line = vim.api.nvim_get_current_line()
        local nline = line:sub(0, cursor[2] + 1) .. url .. line:sub(cursor[2] + 2)

        vim.api.nvim_set_current_line(nline)
        vim.api.nvim_win_set_cursor(0, { cursor[1], cursor[2] + url:len() })
    end
end

command("LoremPicsumUrl", append_lorem_picsum_url, {})

local charset = {} -- [0-9a-zA-Z]
do
    for c = 48, 57 do
        table.insert(charset, string.char(c))
    end
    for c = 65, 90 do
        table.insert(charset, string.char(c))
    end
    for c = 97, 122 do
        table.insert(charset, string.char(c))
    end
end

local function randomString(length)
    local res = ""

    for _ = 1, length do
        -- math.randomseed(os.clock()^5)
        res = res .. charset[math.random(1, #charset)]
    end

    return res
end

local function append_random_string()
    local length = tonumber(vim.fn.input("length: "))

    if length and length > 0 then
        local str = randomString(length)

        local cursor = vim.api.nvim_win_get_cursor(0)
        local line = vim.api.nvim_get_current_line()
        local nline = line:sub(0, cursor[2] + 1) .. str .. line:sub(cursor[2] + 2)

        vim.api.nvim_set_current_line(nline)
        vim.api.nvim_win_set_cursor(0, { cursor[1], cursor[2] + str:len() })
    end
end

command("LoremPicsumText", function()
    append_random_string()
end)
