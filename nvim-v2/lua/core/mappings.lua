local wk = require("which-key")

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

-- Insert a blank line below or above current line (do not move the cursor),
-- see https://stackoverflow.com/a/16136133/6064933
nmap("<space>o", "printf('m`%so<ESC>``', v:count1)", true)

nmap("<space>O", "printf('m`%sO<ESC>``', v:count1)", true)

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

-- Paste non-linewise text above or below current line, see https://stackoverflow.com/a/1346777/6064933
nmap("<leader>p", "m`o<ESC>p``")
nmap("<leader>P", "m`O<ESC>p``")

-- Shortcut for faster save and quit
nmap("<leader>w", "<cmd>update<cr>")

-- Saves the file if modified and quit
nmap("<leader>q", "<cmd>x<cr>")

-- Quit all opened buffers
nmap("<leader>Q", "<cmd>qa!<cr>")

-- Edit and reload nvim config file quickly
nmap("<leader>ev", "<cmd>tabnew $MYVIMRC <bar> tcd %:h<cr>")

nmap("<leader>sv", function()
  vim.cmd([[
      update $MYVIMRC
      source $MYVIMRC
    ]])
  vim.notify("Nvim config successfully reloaded!", vim.log.levels.INFO, { title = "nvim-config" })
end
)

-- Reselect the text that has just been pasted, see also https://stackoverflow.com/a/4317090/6064933.
nmap("<leader>v", "printf('`[%s`]', getregtype()[0])", true)

-- Copy entire buffer.
nmap("<leader>y", "<cmd>%yank<cr>")

-- Switch windows
nmap("<leader><left>", "<c-w>h")
nmap("<leader><Right>", "<C-W>l")
nmap("<leader><Up>", "<C-W>k")
nmap("<leader><Down>", "<C-W>j")

-------------------------------------- custom -------------------------------------------

-- Use map Ukrainian layout for most actions (<leader>, <cmd>, won't though)
-- but still it is super useful for quick editing

local function setup_ukrainian_to_english_lmap()
  -- Define a table to map Ukrainian keys to English keys
  local ukr_to_eng_keys = {
  -- Lowercase letters
  -- ж, Ж  are removed so THey would not trigger the command-line
  ['й'] = 'q', ['ц'] = 'w', ['у'] = 'e', ['к'] = 'r', ['е'] = 't',
  ['н'] = 'y', ['г'] = 'u', ['ш'] = 'i', ['щ'] = 'o', ['з'] = 'p',
  ['х'] = '[', ['ї'] = ']', ['ф'] = 'a', ['і'] = 's', ['в'] = 'd',
  ['а'] = 'f', ['п'] = 'g', ['р'] = 'h', ['о'] = 'j', ['л'] = 'k',
  ['д'] = 'l', ['є'] = "'", ['я'] = 'z', ['ч'] = 'x',
  ['с'] = 'c', ['м'] = 'v', ['и'] = 'b', ['т'] = 'n', ['ь'] = 'm',
  ['б'] = ',', ['ю'] = '.', ['.'] = [[/\v]],

  -- Uppercase letters
  ['Й'] = 'Q', ['Ц'] = 'W', ['У'] = 'E', ['К'] = 'R', ['Е'] = 'T',
  ['Н'] = 'Y', ['Г'] = 'U', ['Ш'] = 'I', ['Щ'] = 'O', ['З'] = 'P',
  ['Х'] = '{', ['Ї'] = '}', ['Ф'] = 'A', ['І'] = 'S', ['В'] = 'D',
  ['А'] = 'F', ['П'] = 'G', ['Р'] = 'H', ['О'] = 'J', ['Л'] = 'K',
  ['Д'] = 'L', ['Є'] = '"', ['Я'] = 'Z', ['Ч'] = 'X',
  ['С'] = 'C', ['М'] = 'V', ['И'] = 'B', ['Т'] = 'N', ['Ь'] = 'M',
  ['Б'] = '<', ['Ю'] = '>', ['Ґ'] = '?'
}

  -- Iterate through the table and set up the lmap for each key pair
  for ukr_key, eng_key in pairs(ukr_to_eng_keys) do
    anymap({"n","x"}, ukr_key, eng_key)
  end
end

-- Call the function to set up the mappings
setup_ukrainian_to_english_lmap()

--show kepbindings with whichkey
--add your own here if you want them to
--show up in the popup as well
wk.register({
	c = {
		name = "code",
		n = { ":vsplit term://$SHELL<cr>", "new terminal" },
		r = { ":vsplit term://R<cr>", "new R terminal" },
		p = { ":vsplit term://python<cr>", "new python terminal" },
		i = { ":vsplit term://ipython<cr>", "new ipython terminal" },
		j = { ":vsplit term://julia<cr>", "new julia terminal" },
	},
	v = {
		name = "vim",
		--t = { toggle_light_dark_theme, "switch theme" },
		c = { ":Telescope colorscheme<cr>", "colortheme" },
		l = { ":Lazy<cr>", "Lazy" },
		m = { ":Mason<cr>", "Mason" },
		s = { ":e $MYVIMRC | :cd %:p:h | split . | wincmd k<cr>", "Settings" },
		h = { ':execute "h " . expand("<cword>")<cr>', "help" },
	},
	l = {
		name = "language/lsp",
		r = { "<cmd>Telescope lsp_references<cr>", "references" },
		R = { "rename" },
		D = { vim.lsp.buf.type_definition, "type definition" },
		a = { vim.lsp.buf.code_action, "coda action" },
		e = { vim.diagnostic.open_float, "diagnostics" },
		d = {
			name = "diagnostics",
			d = { vim.diagnostic.disable, "disable" },
			e = { vim.diagnostic.enable, "enable" },
		},
		g = { ":Neogen<cr>", "neogen docstring" },
		s = { ":ls!<cr>", "list all buffers" },
        k = { vim.lsp.buf.hover, "Jump to definition"}
	},
	f = {
		name = "find (telescope)",
		f = { "<cmd>Telescope find_files<cr>", "files" },
		h = { "<cmd>Telescope help_tags<cr>", "help" },
		k = { "<cmd>Telescope keymaps<cr>", "keymaps" },
		r = { "<cmd>Telescope lsp_references<cr>", "references" },
		g = { "<cmd>Telescope live_grep<cr>", "grep" },
		b = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "fuzzy" },
		m = { "<cmd>Telescope marks<cr>", "marks" },
		M = { "<cmd>Telescope man_pages<cr>", "man pages" },
		c = { "<cmd>Telescope git_commits<cr>", "git commits" },
		s = { "<cmd>Telescope lsp_document_symbols<cr>", "symbols" },
		d = { "<cmd>Telescope buffers<cr>", "buffers" },
		q = { "<cmd>Telescope quickfix<cr>", "quickfix" },
		l = { "<cmd>Telescope loclist<cr>", "loclist" },
		j = { "<cmd>Telescope jumplist<cr>", "marks" },
		p = { "project" },
	},
	h = {
		name = "help/debug/conceal",
		c = {
			name = "conceal",
			h = { ":set conceallevel=1<cr>", "hide/conceal" },
			s = { ":set conceallevel=0<cr>", "show/unconceal" },
		},
		t = {
			name = "treesitter",
			t = { vim.treesitter.inspect_tree, "show tree" },
			c = { ":=vim.treesitter.get_captures_at_cursor()<cr>", "show capture" },
			n = { ":=vim.treesitter.get_node():type()<cr>", "show node" },
		},
	},
	s = {
		name = "spellcheck",
		s = { "<cmd>Telescope spell_suggest<cr>", "spelling" },
		["/"] = { "<cmd>setlocal spell!<cr>", "spellcheck" },
		n = { "]s", "next" },
		p = { "[s", "previous" },
		g = { "zg", "good" },
		r = { "zg", "rigth" },
		w = { "zw", "wrong" },
		b = { "zw", "bad" },
		["?"] = { "<cmd>Telescope spell_suggest<cr>", "suggest" },
	},
	g = {
		name = "git",
		c = { ":GitConflictRefresh<cr>", "conflict" },
		g = { ":Neogit<cr>", "neogit" },
		s = { ":Gitsigns<cr>", "gitsigns" },
		wc = { ":lua require('telescope').extensions.git_worktree.create_git_worktree()<cr>", "worktree create" },
		ws = { ":lua require('telescope').extensions.git_worktree.git_worktrees()<cr>", "worktree switch" },
		d = {
			name = "diff",
			o = { ":DiffviewOpen<cr>", "open" },
			c = { ":DiffviewClose<cr>", "close" },
		},
		b = {
			name = "blame",
			b = { ":GitBlameToggle<cr>", "toggle" },
			o = { ":GitBlameOpenCommitURL<cr>", "open" },
			c = { ":GitBlameCopyCommitURL<cr>", "copy" },
		},
	},
	w = {
		name = "write",
		w = { ":w<cr>", "write" },
	},
	x = {
		name = "execute",
		x = { ":w<cr>:source %<cr>", "file" },
	},
}, { mode = "n", prefix = "<leader>" })
