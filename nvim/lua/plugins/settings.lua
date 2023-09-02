local g = vim.g
local opt = vim.opt
local keymap = vim.keymap

-------------------------------------- LuaSnip -------------------------------------

--[[
-- Trigger configuration. Do not use <tab> if you use YouCompleteMe
g.UltiSnipsExpandTrigger='<tab>'

-- Do not look for SnipMate snippets
g.UltiSnipsEnableSnipMate = 0

-- Shortcut to jump forward and backward in tabstop positions
g.UltiSnipsJumpForwardTrigger='<tab>'
g.UltiSnipsJumpBackwardTrigger='<S-tab>'

-- Configuration for custom snippets directory, see
-- https://jdhao.github.io/2019/04/17/neovim_snippet_s1/ for details.
g.UltiSnipsSnippetDirectories={'UltiSnips', 'my_snippets'}
--]]

------------------------------------- vim-mundo  ----------------------------------------------
--g.mundo_verbose_graph = 0
--g.mundo_width = 80

--keymap.set('n', '<Space>u', ':MundoToggle<CR>', { noremap = true, silent = true })

------------------------------------- better-escape.vim --------------------------------------------------
g.better_escape_interval = 200
------------------------------------- neoformat  ----------------------------------------------

--g.neoformat_enabled_python = {'black', 'yapf'}

--[[g.neoformat_cpp_clangformat = {
      \ 'exe': 'clang-format',
      \ 'args': ['--style=--{IndentWidth: 4}--']
      \ }
g.neoformat_c_clangformat = {
      \ 'exe': 'clang-format',
      \ 'args': ['--style=--{IndentWidth: 4}--']
      \ }

g.neoformat_enabled_cpp = ['clangformat']
g.neoformat_enabled_c = ['clangformat']

]]

--------------------------------------- vim-markdown --------------------------------------

--[[

-- Disable header folding
g.vim_markdown_folding_disabled = 1

-- Whether to use conceal feature in markdown
g.vim_markdown_conceal = 1

-- Disable math tex conceal and syntax highlight
g.tex_conceal = ''
g.vim_markdown_math = 0

-- Support front matter of various format
g.vim_markdown_frontmatter = 1  -- for YAML format
g.vim_markdown_toml_frontmatter = 1  -- for TOML format
g.vim_markdown_json_frontmatter = 1  -- for JSON format

-- Let the TOC window autofit so that it doesn't take too much space
g.vim_markdown_toc_autofit = 1 ]]

--------------------------------------- Neogit ----------------------------------

keymap.set('n','<leader>ng', [[<cmd>Neogit<cr>]], { desc = "open Neogit window" })

--------------------------------------- unicode.vim -----------------------------

--nmap ga <Plug>(UnicodeGA)

--------------------------------------- vim-sandwich ----------------------------
-- Map s to nop since s in used by vim-sandwich. Use cl instead of s.
keymap.set('n', 's', '<Nop>')
keymap.set('o', 's', '<Nop>')

--------------------------------------- vimtex ----------------------------

--[[g.vimtex_compiler_latexmk = {
    'aux_dir'='',
    'out_dir'='',
}]]
g.vimtex_view_method = 'zathura'
g.vimtex_compiler_method = 'latexmk'
g.vimtex_compiler_engine = 'lualatex'

-- Add custom mapping for Mandor project

keymap.set('i', "<C-f>", [[<Esc><Cmd>lua vim.cmd('!mandor inkscape --create-figure "'..vim.fn.getline('.')..'" start > /dev/null 2>&1')<CR><Cmd>w<CR>]],
    { noremap = true,
      silent = true,
      desc = "Create a figure using Mandor",
})

keymap.set('n', "<C-f>", "<cmd>!mandor inkscape start<cr><cr><cmd>redraw!<cr>",
    { noremap = true,
      silent = true,
      desc = "Edit a figure using Mandor",
})

keymap.set('n', "<S-f>", "<cmd>!mandor inkscape paste<cr><cr><cmd>redraw!<cr>",
    { noremap = true,
      silent = true,
      desc = "Add a figure using Mandor",
})

-------------------------------- whitespace.nvim --------------------------

-- Remove trailing whitespace characters
keymap.set("n", "<space><space>", "<cmd>StripTrailingWhitespace<cr>", { desc = "remove trailing space" })

---------------------------------------------wilder.nvim ------------------------------------------

--[[
call timer_start(250, { -> s:wilder_init() })

function! s:wilder_init() abort
  try
    call wilder#setup({
          \ 'modes': [':', '/', '?'],
          \ 'next_key': '<Tab>',
          \ 'previous_key': '<S-Tab>',
          \ 'accept_key': '<C-y>',
          \ 'reject_key': '<C-e>'
          \ })

    call wilder#set_option('pipeline', [
          \   wilder#branch(
          \     wilder#cmdline_pipeline({
          \       'language': 'python',
          \       'fuzzy': 1,
          \       'sorter': wilder#python_difflib_sorter(),
          \       'debounce': 30,
          \     }),
          \     wilder#python_search_pipeline({
          \       'pattern': wilder#python_fuzzy_pattern(),
          \       'sorter': wilder#python_difflib_sorter(),
          \       'engine': 're',
          \       'debounce': 30,
          \     }),
          \   ),
          \ ])

    let l:hl = wilder#make_hl('WilderAccent', 'Pmenu', [{}, {}, {'foreground': '#f4468f'}])
    call wilder#set_option('renderer', wilder#popupmenu_renderer({
          \ 'highlighter': wilder#basic_highlighter(),
          \ 'max_height': 15,
          \ 'highlights': {
          \   'accent': l:hl,
          \ },
          \ 'left': [' ', wilder#popupmenu_devicons(),],
          \ 'right': [' ', wilder#popupmenu_scrollbar(),],
          \ 'apply_incsearch_fix': 0,
          \ }))
  catch /^Vim\%((\a\+)\)\=:E117/
    echohl Error |echomsg "Wilder.nvim missing: run :PackerSync to fix."|echohl None
  endtry
endfunction

--]]
-------------------------------------------vim-auto-save -----------------------------

g.auto_save = 0  -- disable AutoSave on Vim startup

----------------------------------------- Telescope + Extensions ---------------------------------

local builtin = require('telescope.builtin')
keymap.set('n', '<leader>ff', builtin.find_files, {})
keymap.set('n', '<leader>fg', builtin.live_grep, {})
keymap.set('n', '<leader>fb', builtin.buffers, {})
keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- frecency ext
--keymap.set("n", "<leader>fr", "<Cmd>Telescope frecency<CR>")

----------------------------------------- Bufferline ------------------------------------------

-- Cycle through tabs using <left> and <right>
keymap.set('n', '<left>', '<cmd>BufferLineCyclePrev<cr>')
keymap.set('n', '<right>', '<cmd>BufferLineCycleNext<cr>')

-- Move tab using <up> and <down>
keymap.set('n', '<up>', '<cmd>BufferLineMovePrev<cr>')
keymap.set('n', '<down>', '<cmd>BufferLineMoveNext<cr>')

----------------------------------------- NvimTree --------------------------------------------

keymap.set("n", "<space>s", require("nvim-tree.api").tree.toggle, {
  silent = true,
  desc = "toggle nvim-tree",
})
