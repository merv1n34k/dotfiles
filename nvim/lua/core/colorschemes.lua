--- This module will load a random colorscheme on nvim startup process.

local utils = require("core.utils")

local M = {}

-- Colorscheme to its directory name mapping, because colorscheme repo name is not necessarily
-- the same as the colorscheme name itself.
M.colorscheme2dir = {
  onedark = "onedark.nvim",
  edge = "edge",
  sonokai = "sonokai",
  gruvbox = "gruvbox",
  gruvbox_material = "gruvbox-material",
  nord = "nord.nvim",
  everforest = "everforest",
  nightfox = "nightfox.nvim",
  kanagawa = "kanagawa.nvim",
  catppuccin = "catppuccin",
  rose_pine = "rose-pine",
  onedarkpro = "onedarkpro.nvim",
  monokai = "monokai.nvim",
  material = "material.nvim",
  neon = "neon",
  blue_moon = "blue-moon",
  aurora = "aurora",
}

M.gruvbox8 = function()
  -- Italic options should be put before colorscheme setting,
  -- see https://github.com/morhetz/gruvbox/wiki/Terminal-specific#1-italics-is-disabled
  vim.g.gruvbox_italics = 1
  vim.g.gruvbox_italicize_strings = 1
  vim.g.gruvbox_filetype_hi_groups = 1
  vim.g.gruvbox_plugin_hi_groups = 1

  vim.cmd([[colorscheme gruvbox8_hard]])
end

M.onedark = function()
  vim.cmd([[colorscheme onedark]])
end

M.edge = function()
  vim.g.edge_enable_italic = 1
  vim.g.edge_better_performance = 1

  vim.cmd([[colorscheme edge]])
end

M.sonokai = function()
  vim.g.sonokai_enable_italic = 1
  vim.g.sonokai_better_performance = 1

  vim.cmd([[colorscheme sonokai]])
end

M.gruvbox = function()
  -- foreground option can be material, mix, or original
  vim.g.gruvbox_foreground = "original"
  vim.g.gruvbox_filetype_hi_groups = 1
  --background option can be hard, medium, soft
  vim.g.gruvbox_background = "soft"
  vim.g.gruvbox_enable_italic = 1
  vim.g.gruvbox_better_performance = 1

  vim.cmd([[colorscheme gruvbox]])
end

M.gruvbox_material = function()
  -- foreground option can be material, mix, or original
  vim.g.gruvbox_material_foreground = "material"
  --background option can be hard, medium, soft
  vim.g.gruvbox_material_background = "soft"
  vim.g.gruvbox_material_enable_italic = 1
  vim.g.gruvbox_material_better_performance = 1

  vim.cmd([[colorscheme gruvbox-material]])
end


M.nord = function()
  vim.cmd([[colorscheme nord]])
end

M.doom_one = function()
  vim.cmd([[colorscheme doom-one]])
end

M.everforest = function()
  vim.g.everforest_enable_italic = 1
  vim.g.everforest_better_performance = 1

  vim.cmd([[colorscheme everforest]])
end

M.nightfox = function()
  vim.cmd([[colorscheme nordfox]])
end

M.kanagawa = function()
  vim.cmd([[colorscheme kanagawa]])
end

M.catppuccin = function()
  -- available option: latte, frappe, macchiato, mocha
  vim.g.catppuccin_flavour = "frappe"

  require("catppuccin").setup()

  vim.cmd([[colorscheme catppuccin]])
end

M.rose_pine = function()
  require('rose-pine').setup({
    --- @usage 'main' | 'moon'
    dark_variant = 'moon',
  })

  -- set colorscheme after options
  vim.cmd('colorscheme rose-pine')
end

M.neon = function ()
  vim.g.neon_style = "default"
  vim.g.neon_italic_keyword = true
  vim.g.neon_italic_function = true
  vim.g.neon_transparent = true

  -- set colorscheme after options
  vim.cmd[[colorscheme neon]]
end

M.blue_moon = function ()
    vim.cmd[[colorscheme blue-moon]]
end

M.aurora = function ()
  vim.g.aurora_italic = 1 -- italic
  vim.g.aurora_transparent = 1 -- transparent
  vim.g.aurora_bold = 1 -- bold
  vim.g.aurora_darker = 1 -- darker background

  vim.cmd[[colorscheme aurora]]
end

M.onedarkpro = function()
  -- set colorscheme after options
  vim.cmd('colorscheme onedark_vivid')
end

M.monokai = function()
  vim.cmd('colorscheme monokai_pro')
end

M.material = function ()
  vim.g.material_style = "oceanic"
  vim.cmd('colorscheme material')
end

--- Use a random colorscheme from the pre-defined list of colorschemes of put your desired colorscheme.
M.use_colorscheme = function()
  local colorscheme = utils.rand_element(vim.tbl_keys(M.colorscheme2dir))


  if not vim.tbl_contains(vim.tbl_keys(M), colorscheme) then
    local msg = "Invalid colorscheme: " .. colorscheme
    vim.notify(msg, vim.log.levels.ERROR, { title = "Logrus-nvim" })

    return
  end

  -- Load the colorscheme, because all the colorschemes are declared as opt plugins, so the colorscheme isn't loaded yet.
  local status = utils.add_pack(M.colorscheme2dir[colorscheme])

  if not status then
    local msg = string.format("Colorscheme %s is not installed. Run PackerSync to install.", colorscheme)
    vim.notify(msg, vim.log.levels.ERROR, { title = "Logrus-nvim" })

    return
  end

  -- Load the colorscheme and its settings
  M[colorscheme]()

  if vim.g.logging_level == "info" then
    local msg = "Loaded colorscheme: " .. colorscheme

    vim.notify(msg, vim.log.levels.INFO, { title = "Logrus-nvim" })
  end
end

-- Load a random colorscheme
M.use_colorscheme()
