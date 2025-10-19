---@type vim.lsp.Config
return {
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            signatureHelp = { enabled = true },
            format = { enable = true },
            diagnostics = {
                globals = {
                    "vim",
                    "require",
                },
            },
            ["completion.enable"] = true
        },
    },
}
