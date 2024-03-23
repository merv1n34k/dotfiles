return {
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")
            dashboard.section.header.val = {
    [[         _             _            _              _      _                  _        ]],
    [[        _\ \          /\ \         /\ \           /\ \   /\_\               / /\      ]],
    [[       /\__ \        /  \ \       /  \ \         /  \ \ / / /         _    / /  \     ]],
    [[      / /_ \_\      / /\ \ \     / /\ \_\       / /\ \ \\ \ \__      /\_\ / / /\ \__  ]],
    [[     / / /\/_/     / / /\ \ \   / / /\/_/      / / /\ \_\\ \___\    / / // / /\ \___\ ]],
    [[    / / /         / / /  \ \_\ / / / ______   / / /_/ / / \__  /   / / / \ \ \ \/___/ ]],
    [[   / / /         / / /   / / // / / /\_____\ / / /__\/ /  / / /   / / /   \ \ \       ]],
    [[  / / / ____    / / /   / / // / /  \/____ // / /_____/  / / /   / / /_    \ \ \      ]],
    [[ / /_/_/ ___/\ / / /___/ / // / /_____/ / // / /\ \ \   / / /___/ / //_/\__/ / /      ]],
    [[/_______/\__\// / /____\/ // / /______\/ // / /  \ \ \ / / /____\/ / \ \/___/ /       ]],
    [[\_______\/    \/_________/ \/___________/ \/_/    \_\/ \/_________/   \_____\/        ]]
            }


            dashboard.section.buttons.val = {
                dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
                dashboard.button("f", "  Find File", ":Telescope find_files<CR>"),
                dashboard.button("w", "󰈭  Find Word", "<cmd>Telescope live_grep<CR>"),
                dashboard.button("r", "  Recent Files", "<cmd>Telescope oldfiles<CR>"),
                dashboard.button("c", "  Configuration", ":e $MYVIMRC | :cd %:p:h<CR>"),
                --dashboard.button("u", "  Update Plugins?", "<cmd>LazyUpdate<CR>"),
                dashboard.button("q", "󰅚  Quit Neovim", ":qa<CR>"),
            }

            local function footer()
                -- Number of plugins
                local total_plugins = #require("lazy").plugins()
                local datetime = os.date "%d-%m-%Y, %H:%M:%S"
                local plugins_text = "\t" .. total_plugins .. " plugins " .. datetime
                -- Quote
                local fortune = require "alpha.fortune"
                local quote = table.concat(fortune(), "\n")
                return plugins_text .. "\n" .. quote
            end

            dashboard.section.footer.val = footer()
            dashboard.section.footer.opts.hl = "Constant"
            dashboard.section.header.opts.hl = "Include"
            dashboard.section.buttons.opts.hl = "Function"
            dashboard.section.buttons.opts.hl_shortcut = "Type"
            dashboard.opts.opts.noautocmd = true
            alpha.setup(dashboard.opts)
        end
    },
}
