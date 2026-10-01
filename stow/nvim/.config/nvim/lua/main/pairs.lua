local api = vim.api
local map = vim.keymap.set
local expr = { expr = true }

local pair = {
  ['"'] = '"',
  ["'"] = "'",
  ["("] = ")",
  ["["] = "]",
  ["`"] = "`",
  ["{"] = "}",
}

local function in_pair()
  local col = api.nvim_win_get_cursor(0)[2]
  local line = api.nvim_get_current_line()

  return pair[line:sub(col, col)] == line:sub(col + 1, col + 1)
end

local function next_char()
  local col = api.nvim_win_get_cursor(0)[2]
  return api.nvim_get_current_line():sub(col + 1, col + 1)
end

for open, close in next, pair do
  if open == close then
    map("i", open, function()
      if next_char() == open then
        return "<Right>"
      end

      return open .. open .. "<Left>"
    end, expr)
  else
    map("i", open, function()
      return open .. close .. "<Left>"
    end, expr)

    map("i", close, function()
      return next_char() == close and "<Right>" or close
    end, expr)
  end
end

map("i", "<BS>", function()
  return in_pair() and "<BS><Del>" or "<BS>"
end, expr)

map("i", "<CR>", function()
  return in_pair() and "<CR><Esc>O" or "<CR>"
end, expr)
