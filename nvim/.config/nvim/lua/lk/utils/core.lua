-- apply f to all elements in table
local function foreach(tbl, f)
  local t = {}

  for key, value in ipairs(tbl) do
    t[key] = f(value)
  end

  return t
end

-- strip filename from full path
local function strip_fname(path)
  return vim.fn.fnamemodify(path, ":t:r")
end

-- filter using predicate f
local function filter(tbl, f)
  if not tbl or tbl == {} then
    return {}
  end

  local t = {}
  for key, value in ipairs(tbl) do
    if f(key, value) then
      table.insert(t, value)
    end
  end

  return t
end

return {
  foreach = foreach,
  strip_fname = strip_fname,
  filter = filter,
}
