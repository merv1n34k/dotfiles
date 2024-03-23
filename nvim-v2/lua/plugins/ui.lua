return {
  -- telescope
  -- a nice seletion UI also to find and open files
  {
    "nvim-telescope/telescope.nvim",
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local previewers = require("telescope.previewers")
      local new_maker = function(filepath, bufnr, opts)
        opts = opts or {}
        filepath = vim.fn.expand(filepath)
        vim.loop.fs_stat(filepath, function(_, stat)
          if not stat then
            return
          end
          if stat.size > 100000 then
            return
          else
            previewers.buffer_previewer_maker(filepath, bufnr, opts)
          end
        end)
      end
      telescope.setup({
        defaults = {
          buffer_previewer_maker = new_maker,
          file_ignore_patterns = {
            "node_modules",
            "%_files/*.html",
            "%_cache",
            ".git/",
            "site_libs",
            ".venv",
          },
          layout_strategy = "flex",
          sorting_strategy = "ascending",
          layout_config = {
            prompt_position = "top",
          },
          mappings = {
            i = {
              ["<C-u>"] = false,
              ["<C-d>"] = false,
              ["<esc>"] = actions.close,
              ["<c-j>"] = actions.move_selection_next,
              ["<c-k>"] = actions.move_selection_previous,
            },
          },
        },
        pickers = {
          find_files = {
            hidden = false,
            find_command = {
              "rg",
              "--files",
              "--hidden",
              "--glob",
              "!.git/*",
              "--glob",
              "!**/.Rproj.user/*",
              "--glob",
              "!_site/*",
              "--glob",
              "!docs/**/*.html",
              "-L",
            },
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
          fzf = {
            fuzzy = true,             -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
          },
        },
      })
      -- telescope.load_extension('fzf')
      telescope.load_extension("ui-select")
      telescope.load_extension("file_browser")
      telescope.load_extension("dap")
    end,
  },
  { "nvim-telescope/telescope-ui-select.nvim" },
  { "nvim-telescope/telescope-fzf-native.nvim",  build = "make" },
  { "nvim-telescope/telescope-dap.nvim" },
  { "nvim-telescope/telescope-file-browser.nvim" },

  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          section_separators = "",
          component_separators = "",
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "searchcount" },
          lualine_x = { "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        extensions = { "nvim-tree" },
      })
    end,
  },
  {
    "rcarriga/nvim-notify",
    config = function()
        require("notify").setup {
            -- Animation style
            stages = "fade_in_slide_out",
            -- Default timeout for notifications
            timeout = 1000,
            background_colour = "#2E3440",
        }
        vim.notify = require("notify")
    end,
  },
  {
    "akinsho/bufferline.nvim",
    config = function()
      require("bufferline").setup {
        options = {
          numbers = "buffer_id",
          close_command = "bdelete! %d",
          right_mouse_command = nil,
          left_mouse_command = "buffer %d",
          middle_mouse_command = nil,
          indicator = {
            icon = "▎", -- this should be omitted if indicator style is not 'icon'
            style = "icon",
          },
          buffer_close_icon = "",
          modified_icon = "●",
          close_icon = "",
          left_trunc_marker = "",
          right_trunc_marker = "",
          max_name_length = 18,
          max_prefix_length = 15,
          tab_size = 10,
          diagnostics = false,
          custom_filter = function(bufnr)
          -- if the result is false, this buffer will be shown, otherwise, this
          -- buffer will be hidden.

          -- filter out filetypes you don't want to see
          local exclude_ft = { "qf", "fugitive", "git" }
          local cur_ft = vim.bo[bufnr].filetype
          local should_filter = vim.tbl_contains(exclude_ft, cur_ft)

          if should_filter then
              return false
          end

          return true
          end,
          show_buffer_icons = true,
          show_buffer_close_icons = true,
          show_close_icon = true,
          show_tab_indicators = true,
          persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
          separator_style = "bar",
          enforce_regular_tabs = false,
          always_show_bufferline = true,
          sort_by = "id",
        },
      }
    end,
  },


  --[=[ {
    'dstein64/nvim-scrollview',
    config = function()
      require('scrollview').setup({
        current_only = true,
      })
    end
  },

  { 'RRethy/vim-illuminate' }, -- highlight current word

  --]=]

  -- filetree
  {
    "nvim-tree/nvim-tree.lua",
    keys = {
      { "<c-b>", ":NvimTreeToggle<cr>", desc = "toggle nvim-tree" },
    },
    config = function()
      require("nvim-tree").setup({
        disable_netrw = true,
        update_focused_file = {
          enable = true,
        },
        git = {
          enable = true,
          ignore = false,
          timeout = 500,
        },
        diagnostics = {
          enable = true,
        },
      })
    end,
  },
  -- show keybinding help window
  { "folke/which-key.nvim" },

  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = {
      { "<leader>lo", ":SymbolsOutline<cr>", desc = "symbols outline" },
    },
    config = function()
      require("symbols-outline").setup()
    end,
  },

  -- terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<c-\>]],
        direction = "float",
      })
    end,
  },
  -- show diagnostics list
  {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup({})
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
      }
      local hooks = require "ibl.hooks"
    -- create the highlight groups in the highlight setup hook, so they are reset
    -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      end)

      require("ibl").setup({
        indent = {
          char = "▏",
          highlight = highlight},
      })
    end,
  },
  {
    "lukas-reineke/headlines.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
        require("headlines").setup {
            markdown = {
                fat_headline_upper_string = "-",
                fat_headline_lower_string = "-",
            }
        }
    end,
  },
}
