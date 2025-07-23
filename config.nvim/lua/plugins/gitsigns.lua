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
