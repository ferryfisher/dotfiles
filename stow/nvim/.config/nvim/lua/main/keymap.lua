local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local keymap = vim.keymap.set

local diagnostic = vim.diagnostic
local lsp = vim.lsp
local buf = lsp.buf

local nmap
do
    -- Create a buffer to reuse for options.
    local nbuffer = { noremap = true, silent = true, desc = nil }

    --- Maps `key` to `mapped` with `desc` as the description.
    --- @param key string
    --- @param mapped string|function
    --- @param desc? string
    nmap = function(key, mapped, desc)
        nbuffer.desc = desc

        keymap("n", key, mapped, nbuffer)
    end
end

--- Removes boilerplate for command mappings.
--- @param command string
local function cmd(command)
    return "<cmd>" .. command .. "<cr>"
end

-- LSP mappings
autocmd("LspAttach", {
    group = augroup("LspMap", { clear = true }),
    once = true,

    callback = function()
        nmap("<leader>ld", buf.definition, "Find definition of symbol at point")

        nmap("<leader>lr", buf.references, "List all references to symbol at point")

        nmap("<leader>ln", buf.rename, "Rename symbol at point")

        nmap("<leader>la", buf.code_action, "Perform code action at point")

        nmap("<leader>ls", buf.signature_help, "Show signature help for function at point")

        nmap("<leader>li", buf.implementation, "Go to implementation of symbol at point")

        nmap("<leader>lt", buf.type_definition, "Find type definition of symbol at point")

        nmap("<leader>le", diagnostic.open_float, "Show diagnostics for line at point")
    end,
})
-- General
nmap("<C-q>", cmd("q"))
nmap("<C-s>", cmd("write"))
nmap("<C-n>", cmd("set number!"))

-- Move lines
nmap("<A-j>", ":m .+1<CR>==")
nmap("<A-k>", ":m .-2<CR>==")

-- Windows
nmap("<C-h>", "<C-w>h")
nmap("<C-j>", "<C-w>j")
nmap("<C-k>", "<C-w>k")
nmap("<C-l>", "<C-w>l")
nmap("<A-]>", cmd("vertical resize -5"))
nmap("<A-[>", cmd("vertical resize +5"))

-- Hybrid mode
do
    local modes = { "i", "c" }

    keymap(modes, "<C-d>", "<Del>")
    keymap(modes, "<C-e>", "<End>")
    keymap(modes, "<C-b>", "<Left>")
    keymap(modes, "<C-f>", "<Right>")
    keymap(modes, "<C-n>", "<Down>")
    keymap(modes, "<C-p>", "<Up>")
end

keymap("c", "<C-a>", "<Home>")
keymap("i", "<C-a>", "<C-o>^")
