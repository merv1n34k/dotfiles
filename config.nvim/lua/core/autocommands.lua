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
        if not vim.tbl_contains(exclude_ft, vim.bo.filetype) then
            vim.cmd([[IBLEnable]])
        end
    end,
})


-- Native autocompletion
-- vim.api.nvim_create_autocmd("LspAttach", {
-- 	callback = function(ev)
-- 		local client = vim.lsp.get_client_by_id(ev.data.client_id)
-- 		if client:supports_method("textDocument/completion") then
-- 			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
-- 		end
-- 	end,
-- })

autocmd("LspAttach", {
    group = augroup("my.lsp", {}),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        if client:supports_method("textDocument/implementation") then
            -- Create a keymap for vim.lsp.buf.implementation ...
        end
        -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
        if client:supports_method("textDocument/completion") then
            -- Optional: trigger autocompletion on EVERY keypress. May be slow!
            --local chars = {}
            --for i = 32, 126 do
            --table.insert(chars, string.char(i))
            --end
            --client.server_capabilities.completionProvider.triggerCharacters = chars
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
        end
        -- Auto-format ("lint") on save.
        -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
        if
            not client:supports_method("textDocument/willSaveWaitUntil")
            and client:supports_method("textDocument/formatting")
        then
            autocmd("BufWritePre", {
                group = augroup("my.lsp", { clear = false }),
                buffer = args.buf,
                callback = function()
                    vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
                end,
            })
        end
    end,
})


--[=[autocmd("CursorHold", {
    pattern = "*",
    group = augroup("delay_diagnostics", {}),
    callback = function(args)
        local buf = args.buf or 0
        local line = vim.api.nvim_win_get_cursor(0)[1] - 1
        local opts = args.data or { ['lnum'] = line }
        -- set weird function
        local function get_delayed_line(callbackd)
            vim.defer_fn(function()
                local lined = vim.api.nvim_win_get_cursor(0)[1] - 1
                callbackd(lined)
            end, 2500)
        end

        get_delayed_line(function(line_delay)
            -- Do whatever you need with the line value here
            if line_delay ~= line then
                return
            end
            local line_diagnostics = vim.diagnostic.get(buf, opts)
            if vim.tbl_isempty(line_diagnostics) then return end

            local diagnostic_message = ""
            for i, diagnostic in ipairs(line_diagnostics) do
                diagnostic_message = diagnostic_message .. string.format("%d: %s", i, diagnostic.message or "")
                --print(diagnostic_message)
                if i ~= #line_diagnostics then
                    diagnostic_message = diagnostic_message .. "\n"
                end
            end
            vim.notify(diagnostic_message, vim.log.levels.INFO, { title = "Logrus-nvim" })
        end)
    end
}) --]=]
