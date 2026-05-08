local config = require("orgmode.config")
local todo_keywords = config:get_todo_keywords():keys()
local valid_priorities = config:get_priorities()

vim.treesitter.query.add_predicate("org-is-todo-keyword?", function(match, _, source, predicate)
  local nodes = match[predicate[2]]
  if not nodes or #nodes == 0 then
    return false
  end
  local node = nodes[1]
  local text = vim.treesitter.get_node_text(node, source)
  return todo_keywords[text] and todo_keywords[text].type == predicate[3] or false
end, { force = true })

vim.treesitter.query.add_predicate("org-is-valid-priority?", function(match, _, source, predicate)
  local nodes = match[predicate[2]]
  if not nodes or #nodes == 0 then
    return false
  end
  local node = nodes[1]
  local type = predicate[3]
  local text = vim.treesitter.get_node_text(node, source)
  local is_valid = valid_priorities[text] and valid_priorities[text].type == type
  if not is_valid then
    return false
  end
  local priority_text = "[#" .. text .. "]"
  local full_node_text = vim.treesitter.get_node_text(node:parent(), source)
  if priority_text ~= full_node_text then
    return false
  end
  local prev_sibling = node:parent():prev_sibling()
  if not prev_sibling then
    return true
  end
  if prev_sibling:prev_sibling() then
    return false
  end
  local todo_text = vim.treesitter.get_node_text(prev_sibling, source)
  return todo_keywords[todo_text] and true or false
end, { force = true })

vim.treesitter.query.add_directive("org-set-block-language!", function(match, _, bufnr, pred, metadata)
  local nodes = match[pred[2]]
  if not nodes or #nodes == 0 then
    return
  end
  local lang_node = nodes[1]
  local text = vim.treesitter.get_node_text(lang_node, bufnr)
  if not text or vim.trim(text) == "" then
    return
  end
  metadata["injection.language"] = require("orgmode.utils").detect_filetype(text, true)
end, { force = true })

vim.treesitter.query.add_predicate("org-is-headline-level?", function(match, _, _, predicate)
  local nodes = match[predicate[2]]
  if not nodes or #nodes == 0 then
    return false
  end
  local node = nodes[1]
  local level = tonumber(predicate[3])
  local _, _, _, node_end_col = node:range()
  return ((node_end_col - 1) % 8) + 1 == level
end, { force = true })
