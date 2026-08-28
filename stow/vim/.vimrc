let mapleader = " "
let maplocalleader = " "

set updatetime=1000
set timeoutlen=250
set ttimeoutlen=10
set ttimeout
set timeout

set clipboard=unnamed
set directory=~/.vim/swap//
set omnifunc=syntaxcomplete#Complete
set hidden
set nomodeline

set undodir=~/.vim/undo//
set undofile

set hlsearch
set ignorecase
set incsearch
set smartcase
set wildignorecase

set softtabstop=-1
set shiftwidth=4
set autoindent
set expandtab
set smarttab
set shiftround

set signcolumn=auto
set colorcolumn=80
set cursorline
set lazyredraw
set linebreak
set number
set smoothscroll

set scrolloff=2
set sidescrolloff=5
set noshowcmd
set noshowmode
set noruler

set list
set listchars=tab:»\ ,nbsp:+,trail:·,extends:→,precedes:←
set fillchars=lastline:…
set foldtext=''
set foldlevelstart=99

set splitright
set splitbelow

set encoding=utf-8
set fileencodings=ucs-bom,utf-8,default,latin1
set fileformats=unix,dos

set pumheight=15

nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

if executable("rg")
   set grepprg=rg\ --vimgrep
endif
