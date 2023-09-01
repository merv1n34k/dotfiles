-- set autocommand to correctly read .snippets
vim.api.nvim_create_autocmd({"BufRead","BufNewFile"}, {
    pattern = "*.snippets",
    callback = function() vim.bo.filetype = 'snippets' end,
})
