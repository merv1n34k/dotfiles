--- This module will load a random colorscheme on nvim startup process.

local utils = require("core.utils")

local g = vim.g
local cmd = vim.cmd

local M = {}

-- Colorscheme to its directory name mapping, because colorscheme repo name is not necessarily
-- the same as the colorscheme name itself.
M.colorscheme2dir = {
    --onedark = "onedark.nvim",
    --edge = "edge",
    --sonokai = "sonokai",
    --gruvbox = "gruvbox",
    gruvbox_material = "gruvbox-material",
    nord = "nord.nvim",
    everforest = "everforest",
    nightfox = "nightfox.nvim",
    --kanagawa = "kanagawa.nvim",
    catppuccin = "catppuccin",
    rose_pine = "rose-pine",
    onedarkpro = "onedarkpro.nvim",
    --monokai = "monokai.nvim",
    --material = "material.nvim",
    --neon = "neon",
    --blue_moon = "blue-moon",
    --aurora = "aurora",
}

M.gruvbox8 = function()
    -- Italic options should be put before colorscheme setting,
    -- see https://github.com/morhetz/gruvbox/wiki/Terminal-specific#1-italics-is-disabled
    g.gruvbox_italics = 1
    g.gruvbox_italicize_strings = 1
    g.gruvbox_filetype_hi_groups = 1
    g.gruvbox_plugin_hi_groups = 1

    cmd([[colorscheme gruvbox8_hard]])
end

M.onedark = function()
    cmd([[colorscheme onedark]])
end

M.edge = function()
    g.edge_enable_italic = 1
    g.edge_better_performance = 1

    cmd([[colorscheme edge]])
end

M.sonokai = function()
    g.sonokai_enable_italic = 1
    g.sonokai_better_performance = 1

    cmd([[colorscheme sonokai]])
end

M.gruvbox = function()
    -- foreground option can be material, mix, or original
    g.gruvbox_foreground = "original"
    g.gruvbox_filetype_hi_groups = 1
    --background option can be hard, medium, soft
    g.gruvbox_background = "soft"
    g.gruvbox_enable_italic = 1
    g.gruvbox_better_performance = 1

    cmd([[colorscheme gruvbox]])
end

M.gruvbox_material = function()
    -- foreground option can be material, mix, or original
    g.gruvbox_material_foreground = "material"
    --background option can be hard, medium, soft
    g.gruvbox_material_background = "soft"
    g.gruvbox_material_enable_italic = 1
    g.gruvbox_material_better_performance = 1

    cmd([[colorscheme gruvbox-material]])
end


M.nord = function()
    cmd([[colorscheme nord]])
end

M.doom_one = function()
    cmd([[colorscheme doom-one]])
end

M.everforest = function()
    g.everforest_enable_italic = 1
    g.everforest_better_performance = 1

    cmd([[colorscheme everforest]])
end

M.nightfox = function()
    cmd([[colorscheme nordfox]])
end

M.kanagawa = function()
    cmd([[colorscheme kanagawa]])
end

M.catppuccin = function()
    -- available option: latte, frappe, macchiato, mocha
    g.catppuccin_flavour = "mocha"

    require("catppuccin").setup()

    cmd([[colorscheme catppuccin]])
end

M.rose_pine = function()
    require('rose-pine').setup({
        --- @usage 'main' | 'moon'
        dark_variant = 'moon',
    })

    -- set colorscheme after options
    cmd('colorscheme rose-pine')
end

M.neon = function()
    g.neon_style = "default"
    g.neon_italic_keyword = true
    g.neon_italic_function = true
    g.neon_transparent = true

    -- set colorscheme after options
    cmd [[colorscheme neon]]
end

M.blue_moon = function()
    cmd [[colorscheme blue-moon]]
end

M.aurora = function()
    g.aurora_italic = 1      -- italic
    g.aurora_transparent = 1 -- transparent
    g.aurora_bold = 1        -- bold
    g.aurora_darker = 1      -- darker background

    cmd [[colorscheme aurora]]
end

M.onedarkpro = function()
    -- set colorscheme after options
    cmd('colorscheme onedark_vivid')
end

M.monokai = function()
    cmd('colorscheme monokai_pro')
end

M.material = function()
    g.material_style = "oceanic"
    cmd('colorscheme material')
end

--- Use a random colorscheme from the pre-defined list of colorschemes or put your desired colorscheme.
M.use_colorscheme = function()
    local colorscheme = utils.rand_element(vim.tbl_keys(M.colorscheme2dir))

    if not vim.tbl_contains(vim.tbl_keys(M), colorscheme) then
        local msg = "Invalid colorscheme: " .. colorscheme
        vim.notify(msg, vim.log.levels.ERROR)

        return
    end

    -- Load the colorscheme and its settings
    M[colorscheme]()

    if g.logging_level == "info" then
        local msg = "Loaded colorscheme: " .. colorscheme

        vim.notify(msg, vim.log.levels.INFO)
    end
end

-- Load a random colorscheme
M.use_colorscheme()
