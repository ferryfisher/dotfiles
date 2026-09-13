local autocmd = vim.api.nvim_create_autocmd
local group = vim.api.nvim_create_augroup("ferry", {})

local parsers = {
  "asm",
  "c",
  "cpp",
  "diff",
  "gitconfig",
  "gitattributes",
  "gitcommit",
  "gitignore",
  "go",
  "json",
  "jsonc",
  "latex",
  "llvm",
  "lua",
  "markdown",
  "markdown_inline",
  "nasm",
  "nix",
  "ocaml",
  "proto",
  "python",
  "query",
  "rust",
  "sh",
  "sshconfig",
  "sql",
  "toml",
  "typst",
  "vim",
  "vimdoc",
  "yaml",
  "zig",
}

autocmd("CmdlineEnter", {
  group = group,
  once = true,
  callback = function()
    require("vim._core.ui2").enable({})
  end,
})

autocmd("FileType", {
  desc = "Treesitter",
  pattern = parsers,
  group = group,
  callback = function(opts)
    local ts = vim.treesitter
    local lang = ts.language.get_lang(vim.bo[opts.buf].filetype)

    if not lang then
      return
    end

    local wo = vim.wo[opts.win]
    wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    wo.foldmethod = "expr"
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

    if ts.language.add(lang) then
      ts.start(opts.buf, lang)
    else
      require("nvim-treesitter").install(lang, { summary = true }):await(function()
        ts.start(opts.buf, lang)
      end)
    end
  end,
})

autocmd({ "TextPutPost", "TextYankPost" }, {
  group = group,
  callback = function()
    vim.hl.hl_op({ higroup = "IncSearch" })
  end,
})

autocmd("InsertEnter", {
  desc = "Autopairs",
  group = group,
  once = true,
  callback = function()
    require("main.pairs")
  end,
})

autocmd("UIEnter", {
  desc = "Entry point",
  group = group,
  once = true,
  callback = function()
    vim.schedule(function()
      require("main.keymap")
      require("main.statusline")
      require("main.lsp")

      local packadd = vim.cmd.packadd
      packadd("nohlsearch")
      packadd("nvim.undotree")
    end)
  end,
})

require("main.options")
