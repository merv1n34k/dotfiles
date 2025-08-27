local _border = require('misc.style')

vim.lsp.enable({
    "lua_ls",
    "gopls",
    "ltex",
    "r_language_server",
    "clangd",
    "cssls",
    "html",
    "cmake",
    "yamlls",
    "bashls",
    "pyright"
})

vim.diagnostic.config({
    virtual_text = { current_line = true, severity = { min = "HINT", max = "WARN" } },
    virtual_lines = { current_line = true, severity = { min = "ERROR" } },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "x ",
            [vim.diagnostic.severity.WARN] = "! ",
            [vim.diagnostic.severity.INFO] = "i ",
            [vim.diagnostic.severity.HINT] = "h ",
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "ErrorMsg",
            [vim.diagnostic.severity.WARN] = "WarningMsg",
        },
    },
})
