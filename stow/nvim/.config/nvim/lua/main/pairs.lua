local map     = vim.keymap.set
local fn      = vim.fn

local pairs   = { '()', '[]', '{}', '""', "''", '``' }
local no_skip = {}

local function prev_char()
    local c = fn.col('.') - 1
    return c > 0 and fn.getline('.'):sub(c, c) or ''
end

local function next_char()
    local c = fn.col('.')
    local l = fn.getline('.')
    return c <= #l and l:sub(c, c) or ''
end

local function in_pair()
    local p = prev_char() .. next_char()
    for _, v in next, pairs do
        if v == p then return v end
    end
end

for _, p in next, pairs do
    local o = p:sub(1, 1)
    map('i', o, function()
        if o == p:sub(2, 2) then
            return next_char() == o and (no_skip[o] and o or "<Right>")
                or p .. "<Left>"
        else
            return p .. "<Left>"
        end
    end, { expr = true })
end

for _, p in next, pairs do
    local c = p:sub(2, 2)
    if c ~= p:sub(1, 1) then
        map('i', c, function()
            return next_char() == c and (no_skip[c] and c or "<Right>") or c
        end, { expr = true })
    end
end

map('i', '<CR>', function()
    return in_pair() and "<CR><Esc>O" or '<CR>'
end, { expr = true })

map('i', '<BS>', function()
    return in_pair() and "<BS><Del>" or '<BS>'
end, { expr = true })
