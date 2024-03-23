local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
--local utils = require("core.utils")

local exclude_ft = { "help", "git", "markdown", "snippets", "text", "gitconfig", "alpha" }

local function set_terminal_keymaps()
	local opts = { buffer = 0 }
	vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
	vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
	vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
	vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
	vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
end

autocmd({ "FocusGained", "BufEnter" }, {
	pattern = { "*" },
	command = "checktime",
})

autocmd("TermOpen", {
	pattern = "*",
	group = augroup("term_settings", { clear = true }),
	callback = function()
        vim.cmd.setlocal("nonumber")
        set_terminal_keymaps()
        vim.cmd("startinsert")
    end,
})

-- Indent blackline stuff
local gid = augroup("indent_blankline", { clear = true })

autocmd("InsertEnter", {
  pattern = "*",
  group = gid,
  command = "IBLDisable",
})
autocmd("InsertLeave", {
  pattern = "*",
  group = gid,
  callback = function()
    if not vim.tbl_contains(exclude_ft,vim.bo.filetype) then
      vim.cmd([[IBLEnable]])
    end
  end,
})

