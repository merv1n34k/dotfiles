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
        highlight = highlight
    },
})

require("visual-whitespace").setup({
    enabled = false
})

require('overlength').setup({ enabled = false })

require('render-markdown').setup({
    completions = { blink = { enabled = true } },
    heading = {
        backgrounds = {
            'Changed',
            'RenderMarkdownH2Bg',
            'RenderMarkdownH3Bg',
            'RenderMarkdownH4Bg',
            'RenderMarkdownH5Bg',
            'RenderMarkdownH6Bg',
        },
    }
})

-- Red cover Maroon madness"

require('colorizer').setup({
    filetypes = { "*" }, -- Highlight all files, but customize some others.
    user_default_options = {
        names = true,
        names_opts = {            -- options for mutating/filtering names.
            lowercase = true,     -- name:lower(), highlight `blue` and `red`
            camelcase = true,     -- name, highlight `Blue` and `Red`
            uppercase = false,    -- name:upper(), highlight `BLUE` and `RED`
            strip_digits = false, -- ignore names with digits,
        },
        RRGGBBAA = true,
        css = false
    }
})
