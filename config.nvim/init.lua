vim.pack.add({
    { src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
    { src = "https://github.com/NeogitOrg/neogit" },
    { src = "https://github.com/sindrets/diffview.nvim" },
    { src = "https://github.com/goolord/alpha-nvim" },
    { src = "https://github.com/windwp/nvim-autopairs" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
    { src = "https://github.com/nvim-telescope/telescope.nvim" },
    { src = "https://github.com/L3MON4D3/LuaSnip" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/nvim-telescope/telescope-file-browser.nvim" },
    { src = "https://github.com/natecraddock/telescope-zf-native.nvim" },
    { src = "https://github.com/Eandrju/cellular-automaton.nvim" },
    { src = "https://github.com/f-person/git-blame.nvim" },
    { src = "https://github.com/stevearc/dressing.nvim" },
    { src = "https://github.com/meanderingprogrammer/render-markdown.nvim" },
    { src = "https://github.com/cdmill/focus.nvim" },
    { src = "https://github.com/backdround/global-note.nvim" },
    { src = "https://github.com/jdhao/whitespace.nvim" },
    { src = "https://github.com/907th/vim-auto-save" },
    { src = "https://github.com/lervag/vimtex" },
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    { src = "https://github.com/akinsho/git-conflict.nvim" },
    { src = "https://github.com/rafamadriz/friendly-snippets" },
    { src = "https://github.com/let-def/texpresso.vim" },
    { src = "https://github.com/saghen/blink.cmp" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/archie-judd/blink-cmp-words" },
    { src = "https://github.com/cassin01/wf.nvim" },
    { src = "https://github.com/lcheylus/overlength.nvim" },
    { src = "https://github.com/mcauley-penney/techbase.nvim" },
    { src = "https://github.com/echasnovski/mini.icons" },
    { src = "https://github.com/mcauley-penney/visual-whitespace.nvim" },
    { src = "https://github.com/xzbdmw/colorful-menu.nvim" },
})

-- improve startup time
vim.loader.enable()

require("core") --[[ Init following settings:

  globals -- global settings
  options -- set default options for nvim
  lazy -- lazy.nvim package manager
  autocommands -- various autocommands
  mappings -- all user-defined mappings
  plugins_settings -- mappings for various plugins
  colorschemes -- colorscheme settings
  lsp -- native lsp support! Finally!
  utils -- useful utils :)

--]]

require("ui")
-- requrie plugins configs
require("plugins")
