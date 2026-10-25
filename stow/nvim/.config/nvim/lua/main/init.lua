local api = vim.api
local autocmd = api.nvim_create_autocmd
local group = api.nvim_create_augroup("ferry", {})

do
  local filetypes = {
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

  local auxillary_parsers = { "comment", "luadoc" }
  local has_auxillary = false

  autocmd("FileType", {
    desc = "Treesitter",
    pattern = filetypes,
    group = group,
    callback = function(opts)
      local ts = vim.treesitter
      local lang = ts.language.get_lang(vim.bo[opts.buf].filetype)

      if not lang then
        return
      end

      local nvim_ts = require("nvim-treesitter")

      if not has_auxillary then
        has_auxillary = true
        nvim_ts.install(auxillary_parsers)
      end

      local wo = vim.wo[opts.win][0]
      wo.foldexpr = vim.treesitter.foldexpr
      wo.foldmethod = "expr"

      vim.bo.indentexpr = nvim_ts.indentexpr

      if vim.list_contains(nvim_ts.get_installed("parsers"), lang) then
        ts.start(opts.buf, lang)
      else
        nvim_ts.install(lang):await(function()
          ts.start(opts.buf, lang)
        end)
      end
    end,
  })
end

do
  local match = string.match
  local mode = api.nvim_get_mode
  local wo = vim.wo

  local function is_visual_mode(m)
    return match(m, "^[vV\x16]") ~= nil
  end

  autocmd("ModeChanged", {
    desc = "Relative lines in visual mode",
    group = group,
    pattern = { "*:[vV\x16]*", "[vV\x16]*:*" },
    callback = function()
      wo.relativenumber = is_visual_mode(mode().mode)
    end,
  })

  autocmd({ "WinEnter", "WinLeave" }, {
    desc = "Sync visual-mode numbering",
    group = group,
    callback = function()
      wo.relativenumber = is_visual_mode(mode().mode)
    end,
  })
end

autocmd({ "TextPutPost", "TextYankPost" }, {
  desc = "Highlight yank",
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
      require("vim._core.ui2").enable({})

      local packadd = vim.cmd.packadd
      packadd("nohlsearch")
      packadd("nvim.undotree")
    end)
  end,
})

require("main.options")
