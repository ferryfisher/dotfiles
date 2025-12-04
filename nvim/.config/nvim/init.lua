local fn = vim.fn
local g = vim.g

vim.loader.enable()

g.mapleader = " "
g.maplocalleader = " "

g.netrw_bufsettings = "nu noma nomod nowrap ro nobl"
g.netrw_banner = 0
g.netrw_chgwin = 1
g.netrw_keepdir = 0
g.netrw_winsize = 20

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
        lazypath
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
                "tohtml",
                "getscript",
                "getscriptPlugin",
                "gzip",
                "matchit",
                "rrhelper",
                "tarPlugin",
                "tutor",
                "zipPlugin",
            }
        }
    }
})

vim.cmd.colorscheme("kanagawa")
