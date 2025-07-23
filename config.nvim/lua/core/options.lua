local opt = vim.opt

-- Setting for vimtex
opt.filetype:append('on')
opt.filetype:append('plugin')
opt.filetype:append('indent')


-- Nvim colorscheme
vim.o.background = "dark" -- or "light" for light mode


-- General
opt.encoding = "utf-8"
opt.laststatus = 3 -- global statusline
opt.showmode = false
opt.showcmd = true
opt.showtabline = 2
opt.clipboard = "unnamedplus" -- Access system clipboard
opt.undofile = true
opt.conceallevel = 2
opt.textwidth = 80


-- Indenting and folding
local tabwidth = 4
opt.expandtab = true
opt.breakindent = true
opt.shiftwidth = tabwidth
opt.smartindent = true
opt.tabstop = tabwidth
opt.softtabstop = tabwidth
opt.foldclose = "all"
opt.foldopen = "all"
opt.foldmethod = "expr"
opt.foldlevel = 4
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- Search
opt.ignorecase = true
opt.hlsearch = true --Set highlight on search
opt.smartcase = true


-- Mouse and cursor
opt.mouse = "a"
opt.mousefocus = true
opt.ruler = false
opt.cursorline = false


-- Numbers
opt.number = true
opt.numberwidth = 2
opt.relativenumber = true --Make relative number default


-- Window
opt.signcolumn = "yes:1"
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.timeoutlen = 400
opt.scrolloff = 5


-- Spell
opt.spell = true
opt.spelllang = { 'en_us' }
opt.syntax = 'enable'

-- Misc
opt.completeopt = "menuone,noinsert"
-- opt.fillchars = { eob = " " }
-- opt.shortmess:append "sI" -- disable nvim intro


-- Comments (don't continue automatically)
-- https://neovim.io/doc/user/options.html#'formatoptions'
opt.formatoptions:remove 'c'
opt.formatoptions:remove 'r'
opt.formatoptions:remove 'o'

-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime = 250

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"

-- add new filetypes
vim.filetype.add {
    extension = {
        ojs = 'javascript',
    },
}

-- additional builtin vim packages
-- filter quickfix list with Cfilter
vim.cmd.packadd 'cfilter'

-- Setup status line
vim.cmd([[
let g:currentmode={
       \ 'n'  : '%#String# NORMAL ',
       \ 'v'  : '%#Search# VISUAL ',
       \ "\<C-V>" : '%#Title# V·Block ',
       \ 'V'  : '%#IncSearch# V·Line ',
       \ 'Rv' : '%#String# V·Replace ',
       \ 'i'  : '%#ModeMsg# INSERT ',
       \ 'R'  : '%#Substitute# R ',
       \ 'c'  : '%#CurSearch# Command ',
       \ 't'  : '%#ModeMsg# TERM ',
       \}
]])
vim.opt.statusline = "%{%g:currentmode[mode()]%} %* %t | %y | %* %= c:%c l:%l/%L %p%%"
