-- TODO:
-- * instead of comments add mapping descriptions
-- clean mappings
-- add new handy mappings

local anymap = function(mode, key, effect, expr, desc)
    expr = expr or false
    desc = desc or nil
    vim.keymap.set(mode, key, effect, {
        silent = true,
        noremap = true,
        expr = expr,
        desc = desc
    })
end

local nmap = function(key, effect, expr, desc)
    anymap("n", key, effect, expr, desc)
end

local imap = function(key, effect, expr, desc)
    anymap("i", key, effect, expr, desc)
end

local xmap = function(key, effect, expr, desc)
    anymap("x", key, effect, expr, desc)
end

-------------------------------------- normal mode --------------------------------------

-- Navigation in the location and quickfix list
nmap("[l", "<cmd>lprevious<cr>zv")
nmap("]l", "<cmd>lnext<cr>zv")

nmap("[L", "<cmd>lfirst<cr>zv")
nmap("]L", "<cmd>llast<cr>zv")

nmap("[q", "<cmd>cprevious<cr>zv")
nmap("]q", "<cmd>cnext<cr>zv")

nmap("[Q", "<cmd>cfirst<cr>zv")
nmap("]Q", "<cmd>clast<cr>zv")

-- Close location list or quickfix list if they are present, see https://superuser.com/q/355325/736190
nmap([[\x]], "<cmd>windo lclose <bar> cclose <cr>")

-- Delete a buffer, without closing the window, see https://stackoverflow.com/q/4465095/6064933
nmap([[\d]], "<cmd>bprevious <bar> bdelete #<cr>")

-- Move the cursor based on physical lines, not the actual lines.
--nmap("j", "v:count == 0 ? 'gj' : 'j'")
--nmap("k", "v:count == 0 ? 'gk' : 'k'")
nmap("^", "g^")
nmap("0", "g0")

-- Always use very magic mode for searching
nmap("/", [[/\v]])

-- Do not move my cursor when joining lines.
nmap("J", function()
    vim.cmd([[
      normal! mzJ`z
      delmarks z
    ]])
end
)

nmap("gJ", function()
    -- we must use `normal!`, otherwise it will trigger recursive mapping
    vim.cmd([[
      normal! zmgJ`z
      delmarks z
    ]])
end
)

-- Keep cursor position after yanking
-- nmap("y", "myy")

-- Toggle spell checking
nmap("<F11>", "<cmd>set spell!<cr>")

-- Change text without putting it into the vim register,
-- see https://stackoverflow.com/q/54255/6064933
nmap("c", '"_c')
nmap("C", '"_C')
nmap("cc", '"_cc')

-- Go to start or end of line easier
anymap({ "n", "x" }, "H", "^")
anymap({ "n", "x" }, "L", "g_")

-- Save key strokes (now we do not need to press shift to enter command mode).
anymap({ "n", "x" }, ";", ":")

-------------------------------------- insert mode --------------------------------------

-- Turn the word under cursor to upper case
imap("<c-u>", "<Esc>viwUea")

-- Turn the current word into title case
imap("<c-t>", "<Esc>b~lea")

-- Break inserted text into smaller undo units when we insert some punctuation chars.
local undo_ch = { ",", ".", "!", "?", ";", ":" }
for _, ch in ipairs(undo_ch) do
    imap(ch, ch .. "<c-g>u")
end

-- insert semicolon in the end
imap("<A-;>", "<Esc>miA;<Esc>`ii")

-- Go to the beginning and end of current line in insert mode quickly
imap("<C-A>", "<HOME>")
imap("<C-E>", "<END>")

-- Delete the character to the right of the cursor
imap("<C-D>", "<DEL>")

-- Toggle spell checking
imap("<F11>", "<c-o><cmd>set spell!<cr>")

-------------------------------------- visual mode --------------------------------------

-- Replace visual selection with text in register, but not contaminate the register,
-- see also https://stackoverflow.com/q/10723700/6064933.
-- anymap("x", "p", '"_c<Esc>p')
--

-- Do not include white space characters when using $ in visual mode,
-- see https://vi.stackexchange.com/q/12607/15292
xmap("$", "g_")

-- Continuous visual shifting (does not exit Visual mode), `gv` means
-- to reselect previous visual area, see https://superuser.com/q/310417/736190
xmap("<", "<gv")
xmap(">", ">gv")

-- Change text without putting it into the vim register,
-- see https://stackoverflow.com/q/54255/6064933
xmap("c", '"_c')

-------------------------------------- command-line mode --------------------------------

-- Go to beginning of command in command-line mode
anymap("c", "<C-A>", "<HOME>")


-------------------------------------- terminal mode ------------------------------------

-- Use Esc to quit builtin terminal
anymap("t", "<Esc>", [[<c-\><c-n>]])

-------------------------------------- with <leader> ------------------------------------

--[=[
-- Edit and reload nvim config file quickly
nmap("<leader>ev", "<cmd>tabnew $MYVIMRC <bar> tcd %:h<cr>")
nmap("<leader>sv", function()
    vim.cmd([[
      update $MYVIMRC
      source $MYVIMRC
    ]])
    --vim.notify("Nvim config successfully reloaded!", vim.log.levels.INFO, { title = "Logrus-nvim" })
end
) --]=]

-- Switch windows
nmap("<leader><left>", "<c-w>h", false, "[window] switch left")
nmap("<leader><Right>", "<C-W>l", false, "[window] switch right")
nmap("<leader><Up>", "<C-W>k", false, "[window] switch top")
nmap("<leader><Down>", "<C-W>j", false, "[window] switch down")

-- common (do not use c, f, l, v, g, n, t and m)
nmap("<leader>w", "<cmd>w<cr>", false, "[common] write buffer")
nmap("<leader>x", "<cmd>w<cr>:source %<cr>", false, "[common] execute file")
-- see https://stackoverflow.com/a/16136133/6064933
nmap("<leader>o", "printf('m`%so<ESC>``', v:count1)", true, "[common] insert blank below current line")
nmap("<leader>O", "printf('m`%sO<ESC>``', v:count1)", true, "[common] insert blank below current line")
nmap("<leader>p", "m`o<ESC>p``", false, "[common] paste below current line")
nmap("<leader>P", "m`O<ESC>p``", false, "[common] paste above current line")
nmap("<leader>q", "<cmd>x<cr>", false, "[common] save and quit file(s)")
nmap("<leader>Q", "<cmd>qa!<cr>", false, "[common] quit all buffers without saving")
nmap("<leader>yy", "<cmd>%yank<cr>", false, "[common] copy whole buffer")
-- see https://stackoverflow.com/a/4317090/6064933.
nmap("<leader>r", "printf('`[%s`]', getregtype()[0])", true, "[common] reselect the pasted text")

-- automatic folding
nmap("<leader>m", "")
nmap("<leader>me", "<cmd>set foldclose=all foldopen=all<cr>", false, "[fold] enable auto")
nmap("<leader>md", "<cmd>set foldclose& foldopen&<cr>", false, "[fold] disable auto")

-- lsp
nmap("<leader>lr", "<cmd>Telescope lsp_references<cr>", false, "[lsp] reference")
nmap("<leader>lD", "vim.lsp.buf.type_definition", false, "[lsp] type definition")
nmap("<leader>la", "vim.lsp.buf.code_action", false, "[lsp] code action")
nmap("<leader>le", "vim.diagnostic.open_float", false, "[lsp] diagnostics")
nmap("<leader>ldd", "vim.diagnostic.disable", false, "[lsp.diagnostics] disable")
nmap("<leader>lde", "vim.diagnostic.enable", false, "[lsp.diagnostics] enable")
nmap("<leader>ls", "<cmd>ls!<cr>", false, "[lsp] list all buffers")
nmap("<leader>lk", "vim.lsp.buf.hover", false, "[lsp] jump to definition")

-- vim
nmap("<leader>vc", "<cmd>Telescope colorscheme<cr>", false, "[vim] colortheme")
nmap("<leader>vm", "<cmd>Mason<cr>", false, "[vim] Mason")
nmap("<leader>vs", ":e $MYVIMRC | :cd %:p:h | split . | wincmd k<cr>", false, "[vim] settings")
nmap("<leader>vh", ':execute "h " . expand("<cword>")<cr>', false, "[vim] help")

-- git
nmap("<leader>gc", '<cmd>GitConflictRefresh<cr>")<cr>', false, "[git] conflict")
nmap("<leader>gg", '<cmd>Neogit<cr>', false, "[git] neogit")
nmap("<leader>gs", '<cmd>Gitsigns<cr>', false, "[git] gitsigns")
nmap("<leader>gdo", '<cmd>DiffviewOpen<cr>', false, "[git.diff] open")
nmap("<leader>gdc", '<cmd>DiffviewClose<cr>', false, "[git.diff] close")
nmap("<leader>gbb", '<cmd>GitBlameToggle<cr>', false, "[git.blame] toggle")
nmap("<leader>gbo", '<cmd>GitBlameOpenCommitURL<cr>', false, "[git.blame] open")
nmap("<leader>gbc", '<cmd>GitBlameCopyCommitURL<cr>', false, "[git.blame] copy")

-- spellcheck
nmap("<leader>ss", '<cmd>Telescope spell_suggest<cr>")<cr>', false, "[spell] suggest")
nmap("<leader>sn", ']s', false, "[spell] next")
nmap("<leader>sp", '[s', false, "[spell] previous")
nmap("<leader>sg", 'zg', false, "[spell] good")
nmap("<leader>sw", 'zw', false, "[spell] wrong")

-- terminal
nmap("<leader>tt", '<cmd>vsplit term://$SHELL"<cr>', false, "[term] $SHELL")
nmap("<leader>tr", '<cmd>vsplit term://R"<cr>', false, "[term] R")
nmap("<leader>tp", '<cmd>vsplit term://python"<cr>', false, "[term] python")
nmap("<leader>ti", '<cmd>vsplit term://ipython"<cr>', false, "[term] ipython")
nmap("<leader>tj", '<cmd>vsplit term://julia"<cr>', false, "[term] julia")
nmap("<leader>tl", '<cmd>vsplit term://lua"<cr>', false, "[term] lua")
nmap("<leader>tc", '<cmd>vsplit term://bc -q -l"<cr>', false, "[term] bc")

-- find
nmap("<leader>ff", "<cmd>Telescope find_files<cr>", false, "[find] files")
nmap("<leader>fh", "<cmd>Telescope help_tags<cr>", false, "[find] help")
nmap("<leader>fk", "<cmd>Telescope keymaps<cr>", false, "[find] keymaps")
nmap("<leader>fr", "<cmd>Telescope lsp_references<cr>", false, "[find] references")
nmap("<leader>fg", "<cmd>Telescope live_grep<cr>", false, "[find] grep")
nmap("<leader>fb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", false, "[find] fuzzy")
nmap("<leader>fw", "<cmd>Telescope file_browser<cr>", false, "[find] file browser")
nmap("<leader>fm", "<cmd>Telescope marks<cr>", false, "[find] marks")
nmap("<leader>fM", "<cmd>Telescope man_pages<cr>", false, "[find] man pages")
nmap("<leader>fc", "<cmd>Telescope git_commits<cr>", false, "[find] git commits")
nmap("<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", false, "[find] symbols")
nmap("<leader>fd", "<cmd>Telescope buffers<cr>", false, "[find] buffers")
nmap("<leader>fq", "<cmd>Telescope quickfix<cr>", false, "[find] quickfix")
nmap("<leader>fl", "<cmd>Telescope loclist<cr>", false, "[find] loclist")
nmap("<leader>fj", "<cmd>Telescope jumplist<cr>", false, "[find] marks")

-- conceal
nmap("<leader>cd", "<cmd>set conceallevel=0<cr>", false, "[conceal] disable")
nmap("<leader>ce", "<cmd>set conceallevel=2<cr>", false, "[conceal] enable")

-- plugins mappings
---------------------------------------- Bufferline.nvim ----------------------------------

nmap('<left>', '<cmd>BufferLineCyclePrev<cr>', false, "[bufferline] cycle tab left")
nmap('<right>', '<cmd>BufferLineCycleNext<cr>', false, "[bufferline] cycle tab right")
nmap('<up>', '<cmd>BufferLineMovePrev<cr>', false, "[bufferline] move tab left")
nmap('<down>', '<cmd>BufferLineMoveNext<cr>', false, "[bufferline] move tab right")

---------------------------------------- whitespace.nvim ----------------------------------

nmap("<space><space>", "<cmd>StripTrailingWhitespace<cr>", false, "[whitespace] strip trailing whitespaces")

---------------------------------------- global-note.nvim ---------------------------------

nmap("<leader>n", "<cmd>GlobalNote<cr>", false, "[plugin.global-note] open global note")
nmap("<leader>np", "<cmd>ProjectsNote<cr>", false, "[plugin.global-note] open projects todo")
nmap("<leader>nv", "<cmd>VimNote<cr>", false, "[plugin.global-note] open vim note")

---------------------------------------- git-conflict.nvim --------------------------------

nmap("<leader>gco", ":GitConflictChooseOurs<cr>", false, "[git.conflict] choose ours")
nmap("<leader>gct", ":GitConflictChooseTheirs<cr>", false, "[git.conflict] choose theirs")
nmap("<leader>gcb", ":GitConflictChooseBoth<cr>", false, "[git.conflict] choose both")
nmap("<leader>gc0", ":GitConflictChooseNone<cr>", false, "[git.conflict] choose none")
nmap("]x", ":GitConflictNextConflict<cr>")
nmap("[x", ":GitConflictPrevConflict<cr>")

---------------------------------------- focus.nvim ---------------------------------------

nmap("<leader>F", "<cmd>Focus<cr>", false, "[plugin.focus] enter zen mode")

---------------------------------------- CUSTOM -------------------------------------------

-- Use map Ukrainian layout for most actions (<leader>, <cmd>, won't though)
-- but still it is super useful for quick editing

local function setup_translation()
    -- Define a table to map Ukrainian keys to English keys
    local translation = {
        -- Lowercase letters
        -- ж, Ж  are removed so they would not trigger the command-line
        ['й'] = 'q',
        ['ц'] = 'w',
        ['у'] = 'e',
        ['к'] = 'r',
        ['е'] = 't',
        ['н'] = 'y',
        ['г'] = 'u',
        ['ш'] = 'i',
        ['щ'] = 'o',
        ['з'] = 'p',
        ['х'] = '[',
        ['ї'] = ']',
        ['ф'] = 'a',
        ['і'] = 's',
        ['в'] = 'd',
        ['а'] = 'f',
        ['п'] = 'g',
        ['р'] = 'h',
        ['о'] = 'j',
        ['л'] = 'k',
        ['д'] = 'l',
        ['є'] = "'",
        ['я'] = 'z',
        ['ч'] = 'x',
        ['с'] = 'c',
        ['м'] = 'v',
        ['и'] = 'b',
        ['т'] = 'n',
        ['ь'] = 'm',
        ['б'] = ',',
        ['ю'] = '.',
        ['.'] = [[/\v]],

        -- Uppercase letters
        ['Й'] = 'Q',
        ['Ц'] = 'W',
        ['У'] = 'E',
        ['К'] = 'R',
        ['Е'] = 'T',
        ['Н'] = 'Y',
        ['Г'] = 'U',
        ['Ш'] = 'I',
        ['Щ'] = 'O',
        ['З'] = 'P',
        ['Х'] = '{',
        ['Ї'] = '}',
        ['Ф'] = 'A',
        ['І'] = 'S',
        ['В'] = 'D',
        ['А'] = 'F',
        ['П'] = 'G',
        ['Р'] = 'H',
        ['О'] = 'J',
        ['Л'] = 'K',
        ['Д'] = 'L',
        ['Є'] = '"',
        ['Я'] = 'Z',
        ['Ч'] = 'X',
        ['С'] = 'C',
        ['М'] = 'V',
        ['И'] = 'B',
        ['Т'] = 'N',
        ['Ь'] = 'M',
        ['Б'] = '<',
        ['Ю'] = '>',
        ['Ґ'] = '?'
    }

    -- Iterate through the table and set up the lmap for each key pair
    for new_key, eng_key in pairs(translation) do
        anymap({ "n", "x" }, new_key, eng_key)
    end
end

-- Call the function to set up the mappings
setup_translation()
