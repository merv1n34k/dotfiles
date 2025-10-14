require('luasnip').setup({})
require('luasnip.loaders.from_vscode').lazy_load()

require("colorful-menu").setup({})

require('blink.cmp').setup({
    snippets = { preset = 'luasnip' },

    cmdline = {
        keymap = {
            ['Tab'] = { 'select_and_accept', 'fallback' },
        },
    },

    term = { enabled = true, keymap = { preset = 'none' } },

    completion = {
        keyword = { range = 'full' },
        accept = { auto_brackets = { enabled = false } },
        list = {
            selection = {
                preselect = true,
                auto_insert = false
            }
        },
        menu = {
            auto_show = false,
            min_width = 34,
            max_height = 10,
            draw = {
                treesitter = { "lsp" },
                align_to = "cursor",
                columns = { { "kind_icon" }, { "label", gap = 1 } },
                components = {
                    label = {
                        text = function(ctx)
                            return require("colorful-menu").blink_components_text(ctx)
                        end,
                        highlight = function(ctx)
                            return require("colorful-menu").blink_components_highlight(ctx)
                        end,
                    },
                },
            },
        },
        documentation = {
            auto_show = true,
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
            cmdline = {
                enabled = function()
                    return vim.fn.getcmdtype() ~= "/" or not "?"
                end,
            },
            path = {
                opts = {
                    get_cwd = function(_)
                        return vim.fn.getcwd()
                    end,
                },
            },
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
})
