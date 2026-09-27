local fn = vim.fn
local g = vim.g

vim.loader.enable()

g.editorconfig = false

g.mapleader = " "
g.maplocalleader = " "

require("main")

local stdpath = fn.stdpath
local lazypath = stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.api.nvim_set_option_value("runtimepath", lazypath, {
  operation = "prepend",
})

require("lazy").setup("plugins", {
  change_detection = { enabled = false, notify = false },
  defaults = { lazy = true },
  rocks = { enabled = false },

  performance = {
    reset_packpath = true,

    cache = {
      enabled = true,
    },

    rtp = {
      disabled_plugins = {
        "dir",
        "editorconfig",
        "gzip",
        "matchit",
        "netrw",
        "netrwPlugin",
        "rplugin",
        "tarPlugin",
        "tutor",
        "zip",
      },
    },
  },
})

vim.cmd.colorscheme("kanagawa")
