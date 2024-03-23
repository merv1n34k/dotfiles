local g = vim.g

local anymap = function(mode, key, effect, expr)
    expr = expr or false
    vim.keymap.set(mode, key, effect, {
            silent = true, noremap = true,
            expr = expr
        })
end

local nmap = function(key, effect, expr)
    anymap("n", key, effect, expr)
end

local imap = function(key, effect, expr)
    anymap("i", key, effect, expr)
end

local xmap = function(key, effect, expr)
    anymap("x", key, effect, expr)
end

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

g.auto_save = 0  -- disable AutoSave on Vim startup

---------------------------------------- Bufferline ---------------------------------------------

-- Cycle through tabs using <left> and <right>
nmap('<left>', '<cmd>BufferLineCyclePrev<cr>')
nmap('<right>', '<cmd>BufferLineCycleNext<cr>')

-- Move tab using <up> and <down>
nmap('<up>', '<cmd>BufferLineMovePrev<cr>')
nmap('<down>', '<cmd>BufferLineMoveNext<cr>')

---------------------------------------- whitespace.nvim ----------------------------------------

-- Remove trailing whitespace characters
nmap("<space><space>", "<cmd>StripTrailingWhitespace<cr>")


