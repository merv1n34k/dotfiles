return {
    { "folke/tokyonight.nvim", lazy = true },
    { "navarasu/onedark.nvim", lazy = true },
    { "sainnhe/edge", lazy = true },
    { "sainnhe/sonokai", lazy = true },
    { "sainnhe/gruvbox-material", lazy = true },
    { "shaunsingh/nord.nvim", lazy = true },
    { "sainnhe/everforest", lazy = true },
    { "EdenEast/nightfox.nvim", lazy = true },
    { "rebelot/kanagawa.nvim", lazy = true },
    { "rose-pine/neovim", name = "rose-pine", lazy = true },
    { "catppuccin/nvim", name = "catppuccin", lazy = true },
    { "olimorris/onedarkpro.nvim", lazy = true },
    { "tanvirtin/monokai.nvim", lazy = true },
    { "marko-cerovac/material.nvim", lazy = true },
    { "rafamadriz/neon", lazy = true },
    { "kyazdani42/blue-moon", lazy = true },
    { 'ray-x/aurora', lazy = true },

	-- color html colors
	{
		"NvChad/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({
				filetypes = { "*" },
				RGB = true, -- #RGB hex codes
				RRGGBB = true, -- #RRGGBB hex codes
				names = true, -- "Name" codes like Blue or blue
				RRGGBBAA = true, -- #RRGGBBAA hex codes
				AARRGGBB = false, -- 0xAARRGGBB hex codes
				rgb_fn = false, -- CSS rgb() and rgba() functions
				hsl_fn = false, -- CSS hsl() and hsla() functions
				css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
				css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
				-- Available modes for `mode`: foreground, background,  virtualtext
				mode = "background", -- Set the display mode.
				-- Available methods are false / true / "normal" / "lsp" / "both"
				-- True is same as normal
				tailwind = false, -- Enable tailwind colors
				-- parsers can contain values d in |r_default_options|
				sass = { enable = false, parsers = { "css" } }, -- Enable sass colors
				virtualtext = "■",
				-- update color values even if buffer is not focd
				-- example : cmp_menu, cmp_docs
				always_update = false,
				-- all the sub-options of filetypes apply to buftypes
				buftypes = {},
			})
		end,
	},
}
