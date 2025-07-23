require("focus").setup({
    window = {
        backdrop = 1, -- shade the backdrop of the focus window. Set to 1 to keep the same as Normal
        -- height and width can be:
        -- * an absolute number of cells when > 1
        -- * a percentage of the width / height of the editor when <= 1
        width = 80,  -- width of the focus window
        height = 25, -- height of the focus window
        -- by default, no options are changed in for the focus window
        -- add any vim.wo options you want to apply
        options = {},
    },
    auto_zen = true,
    plugins = {
        options = {
            ruler = false
        },
        gitsigns = { enabled = false },    -- disables git signs
        -- tmux = { enabled = false }, -- disables the tmux statusline
        diagnostics = { enabled = false }, -- disables diagnostics
    },
})
