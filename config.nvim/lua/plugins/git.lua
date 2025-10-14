-- GitSigns
require("git-conflict").setup({
    default_mappings = false,
    disable_diagnostics = true,
})

-- GitSigns
require('gitsigns').setup {
    signs = {
        add          = { text = '+' },
        change       = { text = '~' },
        delete       = { text = '-' },
        topdelete    = { text = '^' },
        changedelete = { text = '0' },
        untracked    = { text = '?' },
    },
}

-- Neogit
require("neogit").setup({
    disable_commit_confirmation = true,
    integrations = {
        diffview = true,
    },
})

-- GitBlame
require('gitblame').setup {
    enabled = false,
}
