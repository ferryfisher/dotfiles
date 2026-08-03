local fn = vim.fn
local g = vim.g

vim.loader.enable()

g.editorconfig = false

g.mapleader = " "
g.maplocalleader = " "

require("main")

local stdpath = fn.stdpath
local lazypath = stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

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
                "editorconfig",
                "gzip",
                "matchit",
                "netrw",
                "netrwPlugin",
                "tarPlugin",
                "tutor",
                "zip",
            },
        },
    },
})

vim.cmd.colorscheme("kanagawa")
