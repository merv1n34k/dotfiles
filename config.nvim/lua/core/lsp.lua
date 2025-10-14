vim.lsp.enable({
    -- Elixir
    "nextls",
    "elixir_ls",
    -- Python
    "pyright",
    "ruff",
    -- Lua
    "lua_ls",
    -- go
    "gopls",
    -- R
    "r_language_server",
    -- C
    --"clangd",
    -- Other
    "cssls",
    "html",
    "cmake",
    "yamlls",
    "bashls",
})

vim.diagnostic.config({
    virtual_text = { current_line = true, severity = { min = "HINT", max = "WARN" } },
    virtual_lines = { current_line = true, severity = { min = "ERROR" } },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = false,
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
