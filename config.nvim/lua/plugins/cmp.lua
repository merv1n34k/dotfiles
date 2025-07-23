require('luasnip').setup({})
require('luasnip.loaders.from_vscode').lazy_load()

require('blink.cmp').setup({
    snippets = { preset = 'luasnip' },

    cmdline = {
        keymap = {
            ['Tab'] = { 'select_and_accept', 'fallback' },
        },
        enabled = true,
        completion = { menu = { auto_show = true } },
    },

    term = { enabled = true, keymap = { preset = 'none' } },

    completion = {
        keyword = { range = 'full' },
        accept = { auto_brackets = { enabled = false } },
        list = { selection = { preselect = true, auto_insert = false } },

        menu = {
            auto_show = false,
            draw = {
                columns = {
                    { 'label',     'label_description', gap = 1 },
                    { 'kind_icon', 'kind' },
                },
            },
            border = "rounded",
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
        },

        documentation = {
            auto_show = true,
            window = {
                border = "rounded",
                winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
            },
        },
        ghost_text = { enabled = true },
    },

    keymap = {
        -- set to 'none' to disable the 'default' preset
        preset = 'none',

        ['<Tab>'] = { 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'show', 'select_prev', 'fallback' },

        ['<C-e>'] = { 'hide', 'show', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },

        -- snippets
        ['<C-q>'] = { 'snippet_backward' },
        ['<C-a>'] = { 'snippet_forward' },

        -- documentation
        ['<A-Tab>'] = { 'show_documentation', 'hide_documentation', 'fallback' },
        ['<Up>'] = { 'scroll_documentation_up', 'fallback' },
        ['<Down>'] = { 'scroll_documentation_down', 'fallback' },
    },

    sources = {
        default = { 'omni', 'cmdline', 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
            thesaurus = {
                name = 'blink-cmp-words',
                module = 'blink-cmp-words.thesaurus',
                -- All available options
                opts = {
                    -- A score offset applied to returned items.
                    -- By default the highest score is 0 (item 1 has a score of -1, item 2 of -2 etc..).
                    score_offset = 0,

                    -- Default pointers define the lexical relations listed under each definition,
                    -- see Pointer Symbols below.
                    -- Default is as below ('antonyms', 'similar to' and 'also see').
                    pointer_symbols = { '!', '&', '^' },
                },
            },

            -- Use the dictionary source
            dictionary = {
                name = 'blink-cmp-words',
                module = 'blink-cmp-words.dictionary',
                -- All available options
                opts = {
                    -- The number of characters required to trigger completion.
                    -- Set this higher if completion is slow, 3 is default.
                    dictionary_search_threshold = 3,

                    -- See above
                    score_offset = 0,

                    -- See above
                    pointer_symbols = { '!', '&', '^' },
                },
            },
        },
        per_filetype = {
            text = { 'dictionary', 'thesaurus' },
            markdown = { 'dictionary', 'thesaurus' },
        },
    },
    appearance = { nerd_font_variant = 'normal' },
    signature = { enabled = false }, -- Until they implement permanent toggling
})
