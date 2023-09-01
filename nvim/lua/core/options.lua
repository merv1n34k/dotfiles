local api = vim.api
local g = vim.g
local opt = vim.opt

-- Setting for vimtex

opt.filetype:append('on')
opt.filetype:append('plugin')
opt.filetype:append('indent')

-- Nvim colorscheme
vim.o.background = "dark" -- or "light" for light mode

opt.encoding = "utf-8"
opt.laststatus = 3 -- global statusline
opt.showmode = false
opt.showcmd = true

opt.clipboard = "unnamedplus" -- Access system clipboard
opt.cursorline = false

-- Indenting
opt.expandtab = true
opt.breakindent = true
opt.shiftwidth = 4
opt.smartindent = true
opt.tabstop = 4
opt.softtabstop = 4

-- opt.fillchars = { eob = " " }
opt.ignorecase = true
opt.hlsearch = true --Set highlight on search
opt.smartcase = true
opt.mouse = "a"

-- Numbers
opt.number = true
opt.numberwidth = 2
opt.relativenumber = true --Make relative number default
opt.ruler = false

-- disable nvim intro
-- opt.shortmess:append "sI"

opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.timeoutlen = 400
opt.undofile = true
opt.conceallevel = 2

opt.foldmethod = "indent"
opt.foldlevel = 80

-- Spell
opt.spell = true
opt.spelllang = {'uk','en_us'}
opt.syntax = 'enable'

-- vim.hi clear SpellBad
-- hi SpellBad cterm=underline


-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime = 250

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"

-- add binaries installed by mason.nvim to path ??
vim.env.PATH = vim.fn.stdpath "data" .. "/mason/bin" .. ":" .. vim.env.PATH
