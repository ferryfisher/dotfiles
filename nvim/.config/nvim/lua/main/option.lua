local o = vim.o
-- Editing {{{{

-- Buffers {{{
o.hidden = true
o.splitright = true
o.splitbelow = true
-- }}}

-- Defaults {{{
o.clipboard = "unnamed,unnamedplus"
o.omnifunc = "syntaxcomplete#Complete"
o.virtualedit = "block"
o.autoread = true
o.modeline = false
o.swapfile = false
o.undofile = true
o.writebackup = false
-- }}}

-- File format {{{
o.encoding = "utf-8"
o.fileencodings = "ucs-bom,utf-8,default,latin1"
o.fileformats = "unix,dos"
o.foldmethod = "marker"
-- }}}

-- Frequency {{{
o.updatetime = 1000
o.timeoutlen = 250
o.ttimeoutlen = 5
-- }}}

-- Indent {{{
o.softtabstop = -1
o.shiftwidth = 4
o.autoindent = true
o.expandtab = true
o.smarttab = true
o.shiftround = true
-- }}}

-- Interface {{{
o.completeitemalign = "kind,abbr,menu"
o.completeopt = "menu,menuone,preview,noinsert,nosort,fuzzy,popup"

o.shortmess = "acCoOstTF"
o.pumheight = 15
o.pummaxwidth = 30
o.scrolloff = 3
o.showtabline = 0
o.sidescrolloff = 5
o.showcmd = false
o.showmode = false
o.ruler = false

o.colorcolumn = "80"
o.signcolumn = "yes"
o.winborder = "bold"
o.textwidth = 80
o.cursorline = true
o.lazyredraw = true
o.linebreak = true
o.number = true
o.smoothscroll = true
o.spell = true
o.wrap = false
-- }}}

-- List {{{
o.listchars = "tab:» ,nbsp:+,trail:·,extends:→,precedes:←"
o.fillchars = "eob: ,fold: "
o.foldtext = ""
o.foldlevelstart = 255
o.list = true
-- }}}

-- Search {{{
o.hlsearch = true
o.smartcase = true
o.ignorecase = true
o.incsearch = true
o.wildignorecase = true
-- }}}

-- }}}}

-- Turn off blinking cursor in terminal mode
vim.opt.guicursor:remove({ "t:block-blinkon500-blinkoff500-TermCursor" })
