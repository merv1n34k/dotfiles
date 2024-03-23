return {
	{
		"LunarVim/bigfile.nvim",
		init = function()
			-- default config
			require("bigfile").setup({
				filesize = 2, -- size of the file in MiB, the plugin round file sizes to the closest MiB
				pattern = { "*" }, -- autocmd pattern
				features = { -- features to disable
					"indent_blankline",
					"illuminate",
					"lsp",
					"treesitter",
					"syntax",
					"matchparen",
					"vimopts",
					"filetype",
				},
			})
		end,
	},
	{ "tpope/vim-repeat" },
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup()
		end,
	},
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
			require("nvim-autopairs").remove_rule("`")
		end,
	},
	-- commenting with e.g. `gcc` or `gcip`
	-- respects TS, so it works in quarto documents
	{
		"numToStr/Comment.nvim",
		version = nil,
		branch = "master",
		config = true, -- default settings
	},
	{
		"danymat/neogen",
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = true,
	},
	{
		"chrishrb/gx.nvim",
		event = { "BufEnter" },
		dependencies = { "nvim-lua/plenary.nvim" },
		config = true, -- default settings
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {
			modes = {
				search = {
					enabled = false,
				},
			},
		},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
			},
			{
				"S",
				mode = { "o", "x" },
				function()
					require("flash").treesitter()
				end,
			},
		},
	},

	-- interactive global search and replace
	{
		"nvim-pack/nvim-spectre",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
    {
        "lervag/vimtex",
        ft = { "tex" }
    },
    {
        "jdhao/whitespace.nvim",
        event = "VimEnter"
    },
    {
        "907th/vim-auto-save",
        event = "InsertEnter"
    },

    {
        "backdround/global-note.nvim",
        config = function ()
            require("global-note").setup({
                filename = "global.md",
                directory = vim.fn.stdpath("data") .. "/global-note/",

                additional_presets = {
                    projects = {
                        filename = "projects-to-do.md",
                        title = "List of projects",
                        command_name = "ProjectsNote",
                    }
                }
            })
        end,
        keys = {
            {
                "<leader>n",
                mode = { "n"},
                function ()
                    require("global-note").toggle_note()
                end
            },
            {
                "<leader>np",
                mode = { "n"},
                function ()
                    require("global-note").toggle_note("projects")
                end

            }
        }
    }
}
