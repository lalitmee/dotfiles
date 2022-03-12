local function input_search()
  vim.ui.input({ prompt = "Search String: " }, function(input)
    if input == nil then
      return
    end
    vim.fn.jobstart(string.format("xdg-open 'https://www.google.com/search?q=%s'", input))
  end)
end

function Browse(args)
  if args["args"] == "" then
    input_search()
    return
  end
  local search_string = args["args"]
  vim.fn.jobstart(string.format("xdg-open 'https://www.google.com/search?q=%s'", search_string))
end

vim.api.nvim_add_user_command("Browse", Browse, { nargs = "*" })
