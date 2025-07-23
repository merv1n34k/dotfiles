local g = vim.g

------------------------------------------ VimTeX -------------------------------------------------

-- probably self-explanatory
g.vimtex_view_method = 'zathura'
g.vimtex_compiler_method = 'latexmk'
g.vimtex_compiler_engine = 'lualatex'

------------------------------------------ Mandor -----------------------------------------------

--imap("<C-f>", [[<Esc><Cmd>lua vim.cmd('!mandor inkscape --create-figure "'..vim.fn.getline('.')..'" start > /dev/null 2>&1')<CR><Cmd>w<CR>]])

--nmap("<C-f>", "<cmd>!mandor inkscape start<cr><cr><cmd>redraw!<cr>")

--nmap("<S-f>", "<cmd>!mandor inkscape paste<cr><cr><cmd>redraw!<cr>")


-------------------------------------------vim-auto-save ----------------------------------------

g.auto_save = 0 -- disable AutoSave on Vim startup
