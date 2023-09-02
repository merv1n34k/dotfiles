local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local utils = require("core.utils")

--[=[ autocmd("BufEnter", {
  pattern = "*.tex",
  command = vim.cmd([[packadd! vimtex]]),
  group = augroup("LoadVimtex", { clear = true }),
}) --]=]

-- dont list quickfix buffers
autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.opt_local.buflisted = false
  end,
  group = augroup("HideQfBuffers", { clear = true }),
})

-- highlight yanked region, see `:h lua-highlight`
autocmd("TextYankPost", {
    pattern = "*",
    callback = function()
        vim.highlight.on_yank{ higroup = "YankColor", timeout = 0 }
    end,
    group = augroup("YankHighlight", { clear = true }),
})

-- Do not use smart case in command line mode, extracted from https://vi.stackexchange.com/a/16511/15292.
autocmd("CmdLineEnter", {
	pattern = ":",
	group = augroup("dynamic_smartcase", { clear = true }),
	callback = function()
        vim.opt.smartcase = false
    end,
})
autocmd("CmdLineLeave", {
	pattern = ":",
	group = augroup("dynamic_smartcase", { clear = true }),
	callback = function()
        vim.opt.smartcase = true
    end,
})

-- Do not use number and relative number for terminal inside nvim
-- Go to insert mode by default to start typing command
autocmd("TermOpen", {
	pattern = "*",
	group = augroup("term_settings", { clear = true }),
	callback = function()
        vim.opt_local.rnu = false
        vim.opt_local.nu = false
        vim.cmd("startinsert")
    end,
})

-- More accurate syntax highlighting? (see `:h syn-sync`)
autocmd("BufEnter", {
	pattern = "*",
	group = augroup("accurate_syn_highlight", { clear = true }),
	command = "syntax sync fromstart",
})

-- ref: https://vi.stackexchange.com/a/169/15292
autocmd("BufReadPre", {
	pattern = "*",
	group = augroup("LargeFile", { clear = true }),
	callback = function (args)
        local large_file = 10485760 -- 10MB
        local f = args.file

        if vim.fn.getfsize(f) > large_file or vim.fn.getfsize(f) == -2 then
            vim.o.eventignore = "all"
            vim.wo.relativenumber = false
            vim.bo.swapfile = false
            vim.bo.bufhidden = "unload"
            vim.bo.buftype = "nowrite"
            vim.bo.undolevels = -1
        else
            vim.o.eventignore = ""
            vim.wo.relativenumber = true
        end
    end
})

-- Display a message when the current file is not in utf-8 format.
-- Note that we need to use `unsilent` command here because of this issue:
-- https://github.com/vim/vim/issues/4379
--[[autocmd("BufRead", {
  pattern = "*",
  group = augroup("non_utf8_file", { clear = true }),
  callback = function()
    if vim.bo.fileencoding ~= "utf-8" then
      vim.notify("File not in UTF-8 format!", vim.log.levels.WARN, { title = "nvim-config" })
    end
  end,
}) --]]

-- Auto-create dir when saving a file, in case some intermediate directory does not exist
autocmd({ "BufWritePre" }, {
  pattern = "*",
  group = augroup("auto_create_dir", { clear = true }),
  callback = function(ctx)
    local dir = vim.fn.fnamemodify(ctx.file, ":p:h")
    utils.may_create_dir(dir)
  end,
})

--[[autocmd("BufEnter", {
	pattern = "*",
	group = augroup("AutoCloseWin", { clear = true }),
	callback = function()
        local quit_filetypes = {'qf', 'vista', 'NvimTree'}
        local should_quit = true

        local tabwins = vim.api.nvim_tabpage_list_wins(0)
        for _, w in ipairs(tabwins) do
            local buf = vim.api.nvim_win_get_buf(w)
            local bf = vim.fn.getbufvar(buf, '&filetype')

            if vim.fn.index(quit_filetypes, bf) == -1 then
                should_quit = false
            break
            end
        end

        if should_quit then
            vim.cmd('qall')
        end
    end,
})]]
