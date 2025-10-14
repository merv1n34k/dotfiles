require("nvim-treesitter.configs").setup({
    ensure_installed = { "python", "c", "lua", "vim", "vimdoc",
        "query", "erlang", "heex", "eex", "elixir", "javascript", "html" },
    sync_install = false,
    highlight = { enable = true },
    indent = { enable = true },
})
