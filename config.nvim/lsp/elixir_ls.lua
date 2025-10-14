if os.getenv("name") == "nix-shell-env" then
    cmd = { "/Users/alexeystroganov/.local/share/nvim/mason/packages/elixir-ls/language_server.sh" }
else
    cmd = nil
end

---@type vim.lsp.Config
return {
    cmd = cmd,
    filetypes = { "elixir", "eelixir", "surface" }
}
