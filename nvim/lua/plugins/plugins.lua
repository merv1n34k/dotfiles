local api = vim.api
local fn = vim.fn

--vim.cmd([[autocmd! ColorScheme * highlight NormalFloat guibg=none]])
--vim.cmd([[autocmd! ColorScheme * highlight FloatBorder guifg=#d3c6aa guibg=none]])

-- The root dir to install all plugins. Plugins are under opt/ or start/ sub-directory.
vim.g.plugin_home = fn.stdpath("data") .. "/site/pack/packer"

--- Install packer if it has not been installed.
--- Return:
--- true: if this is a fresh install of packer
--- false: if packer has been installed
local function packer_ensure_install()
  -- Where to install packer.nvim -- the package manager (we make it opt)
  local packer_dir = vim.g.plugin_home .. "/opt/packer.nvim"

  if fn.glob(packer_dir) ~= "" then
    return false
  end


  -- Auto-install packer in case it hasn't been installed.
  vim.api.nvim_echo({ { "Installing packer.nvim", "Type" } }, true, {})

  local packer_repo = "https://github.com/wbthomason/packer.nvim"
  local install_cmd = string.format("!git clone --depth=1 %s %s", packer_repo, packer_dir)
  vim.cmd(install_cmd)

  return true
end

local fresh_install = packer_ensure_install()

-- Load packer.nvim
vim.cmd("packadd packer.nvim")

local packer = require("packer")
local packer_util = require("packer.util")

packer.startup {
  function(use)
    use { "wbthomason/packer.nvim", opt = true }

----------------------------------------- LSP + CMP ----------------------------------------------------

    use { "onsails/lspkind-nvim", event = "VimEnter" }
    -- auto-completion engine
    use { "hrsh7th/nvim-cmp", after = "lspkind-nvim", config = [[require('plugins.config.nvim-cmp')]] }

    -- nvim-cmp completion sources
    use { "saadparwaiz1/cmp_luasnip", after="nvim-cmp"}
    use { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" }
    use { "hrsh7th/cmp-path", after = "nvim-cmp" }
    use { "hrsh7th/cmp-buffer", after = "nvim-cmp" }
    use { "hrsh7th/cmp-omni", after = "nvim-cmp" }
    use { "hrsh7th/cmp-emoji", after = "nvim-cmp" }
    -- Great snippet engine
    use {"L3MON4D3/LuaSnip",
        requires = { "rafamadriz/friendly-snippets",},
        event = { "TextChanged, TextChangedI" },
        config = function()
            vim.defer_fn(function()
            require("plugins.config.luasnip")
            end, 2000)
        end,
        after = "nvim-cmp"}

    -- nvim-lsp configuration (it relies on cmp-nvim-lsp, so it should be loaded after cmp-nvim-lsp).
    use { "neovim/nvim-lspconfig", after = "cmp-nvim-lsp", config = [[require('plugins.config.lsp')]] }

    -- lsp manager
    use { "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    config = [[require('plugins.config.mason')]]
    }

    use { "ii14/emmylua-nvim", ft = "lua" }

    use { "j-hui/fidget.nvim", after = "nvim-lspconfig", tag = "legacy", config = [[require('plugins.config.fidget-nvim')]] }

---------------------------------------------- colorschemes -------------------------------------------------

    -- A list of colorscheme plugin you may want to try. Find what suits you.
    use { "navarasu/onedark.nvim", opt = true }
    use { "sainnhe/edge", opt = true }
    use { "sainnhe/sonokai", opt = true }
    use { "gruvbox-community/gruvbox", opt = true }
    use { "sainnhe/gruvbox-material", opt = true }
    use { "shaunsingh/nord.nvim", opt = true }
    use { "sainnhe/everforest", opt = true }
    use { "EdenEast/nightfox.nvim", opt = true }
    use { "rebelot/kanagawa.nvim", opt = true }
    use { "catppuccin/nvim", as = "catppuccin", opt = true }
    use { "rose-pine/neovim", as = 'rose-pine', opt = true }
    use { "olimorris/onedarkpro.nvim", opt = true }
    use { "tanvirtin/monokai.nvim", opt = true }
    use { "marko-cerovac/material.nvim", opt = true }
    use { "rafamadriz/neon", opt = true }
    use { "kyazdani42/blue-moon", opt = true }
    use { 'ray-x/aurora', opt = true }


-------------------------------------------- Important ---------------------------------------------------


    -- File search, tag search and more
    use {
      "nvim-telescope/telescope.nvim",
      cmd = "Telescope",
      module = "telescope",
      config = function()
        vim.defer_fn(function()
          require("plugins.config.telescope")
        end, 2000)
      end,
      requires = { { "nvim-lua/plenary.nvim" } },
    }

    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

    -- Setup later
    --[=[use {
        "nvim-telescope/telescope-frecency.nvim",
        config = function()
            require("telescope").load_extension "frecency"
        end,
        requires = { "kkharji/sqlite.lua" },
    }--]=]

    use {
      "nvim-lualine/lualine.nvim",
      event = "VimEnter",
      config = [[require('plugins.config.statusline')]],
    }

    use { "akinsho/bufferline.nvim", event = "VimEnter",
      config = [[require('plugins.config.bufferline')]] }

    use {
    'goolord/alpha-nvim',
    requires = { 'ryanoasis/vim-devicons' },
    config = function()
        require("plugins.config.alpha").setup()
    end

    }

    use {
      "lukas-reineke/indent-blankline.nvim",
      event = "VimEnter",
      config = [[require('plugins.config.indent-blankline')]],
    }

    use { "lervag/vimtex", ft = { "tex" } }

    use {
        "nvim-treesitter/nvim-treesitter",
        event = "BufEnter",
        run = ":TSUpdate",
        config = [[require('plugins.config.treesitter')]],
    }

    -- file explorer
    use {
      "nvim-tree/nvim-tree.lua",
      after = "nvim-web-devicons",
      requires = "nvim-tree/nvim-web-devicons",
      module = "nvim-tree",
      config = [[require('plugins.config.nvim-tree')]],
    }
    use { "nvim-tree/nvim-web-devicons"}

    -- REPL for nvim
    use {
      'Vigemus/iron.nvim',
      config = [[require('plugins.config.iron')]],
    }

------------------------------------------ Git ------------------------------------------------------

    use {
    'NeogitOrg/neogit',
    requires = {
        "nvim-lua/plenary.nvim",         -- required
        "nvim-telescope/telescope.nvim", -- optional
        "sindrets/diffview.nvim",        -- optional
        },
    config = [[require('plugins.config.neogit')]]
    }

    -- Show git change (change, delete, add) signs in vim sign column
    use { "lewis6991/gitsigns.nvim", config = [[require('plugins.config.gitsigns')]] }

------------------------------------------ useful ---------------------------------------------------

    -- Python indent (follows the PEP8 style)
    use { "Vimjas/vim-python-pep8-indent", ft = { "python" } }

    -- Python-related text object
    use { "jeetsukumaran/vim-pythonsense", ft = { "python" } }

    use { "machakann/vim-swap", event = "VimEnter" }

    -- Super fast buffer jump
    use {
      "phaazon/hop.nvim",
      event = "VimEnter",
      config = function()
        vim.defer_fn(function()
          require("plugins.config.nvim-hop")
        end, 2000)
      end,
    }

    -- Automatic insertion and deletion of a pair of characters
    use { "Raimondi/delimitMate", event = "InsertEnter" }

    -- Comment plugin
    use { "tpope/vim-commentary", event = "VimEnter" }

    -- Autosave files on certain events
    use { "907th/vim-auto-save", event = "InsertEnter" }

    -- Show undo history visually
    --use { "simnalamburt/vim-mundo", cmd = { "MundoToggle", "MundoShow" } }

    -- Handy unix command inside Vim (Rename, Move etc.)
    --use { "tpope/vim-eunuch", cmd = { "Rename", "Delete" } }

    -- Repeat vim motions
    use { "tpope/vim-repeat", event = "VimEnter" }

    -- show and trim trailing whitespaces
    use { "jdhao/whitespace.nvim", event = "VimEnter" }

    -- Plugin to manipulate character pairs quickly
    use { "machakann/vim-sandwich", event = "VimEnter" }

    -- notification plugin
    use {
      "rcarriga/nvim-notify",
      --event = "VimEnter",
      config = function()
        vim.defer_fn(function()
          require("plugins.config.nvim-notify")
        end, 2000)
      end,
    }

    -- Show match number and index for searching
    use {
      "kevinhwang91/nvim-hlslens",
      branch = "main",
      keys = { { "n", "*" }, { "n", "#" }, { "n", "n" }, { "n", "N" } },
      config = [[require('plugins.config.hlslens')]],
    }

    -- better UI for some nvim actions
    use {'stevearc/dressing.nvim'}

    -- Manage your yank history
    use({
      "gbprod/yanky.nvim",
      config = [[require('plugins.config.yanky')]]
    })

    use { "kevinhwang91/nvim-bqf", ft = "qf", config = [[require('plugins.config.bqf')]] }

    use { "chrisbra/unicode.vim", event = "VimEnter" }

    use { "nvim-zh/better-escape.vim", event = { "InsertEnter" } }

    -- Add indent object for vim (useful for languages like Python)
    --use { "michaeljsmith/vim-indent-object", event = "VimEnter" }

    -- Modern matchit implementation
    --use { "andymass/vim-matchup", event = "VimEnter" }

    --use { "tpope/vim-scriptease", cmd = { "Scriptnames", "Message", "Verbose" } }

    -- Asynchronous command execution
    use { "skywind3000/asyncrun.vim", opt = true, cmd = { "AsyncRun" } }

    use { "cespare/vim-toml", ft = { "toml" }, branch = "main" }

    -- Session management plugin
    --use { "tpope/vim-obsession", cmd = "Obsession" }

------------------------------------------ unused plugins -------------------------------------------
--
    -- Another markdown plugin
    -- use { "preservim/vim-markdown", ft = { "markdown" } }

    -- Faster footnote generation
    -- use { "vim-pandoc/vim-markdownfootnotes", ft = { "markdown" } }

    -- Vim tabular plugin for manipulate tabular, required by markdown plugins
    -- use { "godlygeek/tabular", cmd = { "Tabularize" } }


    -- Auto format tools
    --use { "sbdchd/neoformat", cmd = { "Neoformat" } }


    -- The missing auto-completion for cmdline!
    --use { "gelguy/wilder.nvim", opt = true, setup = [[vim.cmd('packadd wilder.nvim')]] }

    -- showing keybindings
    --[[use {
      "folke/which-key.nvim",
      event = "VimEnter",
      config = function()
        vim.defer_fn(function()
          require("config.which-key")
        end, 2000)
      end,
    }]]



    end,
  config = {
    max_jobs = 16,
    compile_path = packer_util.join_paths(fn.stdpath("data"), "site", "lua", "packer_compiled.lua"),
  },
}

-- For fresh install, we need to install plugins. Otherwise, we just need to require `packer_compiled.lua`.
if fresh_install then
  -- We run packer.sync() here, because only after packer.startup, can we know which plugins to install.
  -- So plugin installation should be done after the startup process.
  packer.sync()
else
  local status, _ = pcall(require, "packer_compiled")
  if not status then
    local msg = "File packer_compiled.lua not found: run PackerSync to fix!"
    vim.notify(msg, vim.log.levels.ERROR, { title = "Logrus-nvim" })
  end
end

-- Auto-generate packer_compiled.lua file
api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = "*/nvim/lua/plugins/plugins.lua",
  group = api.nvim_create_augroup("packer_auto_compile", { clear = true }),
  callback = function(ctx)
    local cmd = "source " .. ctx.file
    vim.cmd(cmd)
    vim.cmd("PackerCompile")
    vim.notify("PackerCompile done!", vim.log.levels.INFO, { title = "Logrus-nvim" })
  end,
})
