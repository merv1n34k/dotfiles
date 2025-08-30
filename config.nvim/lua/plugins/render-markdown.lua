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
