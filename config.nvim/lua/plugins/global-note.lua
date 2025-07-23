require("global-note").setup({
    filename = "global.md",
    directory = vim.fn.stdpath("data") .. "/global-note/",

    additional_presets = {
        projects = {
            filename = "projects-to-do.md",
            title = "List of projects",
            command_name = "ProjectsNote",
        },
        nvim = {
            filename = "vim-stuff.md",
            title = "Nvim config stuff",
            command_name = "VimNote"
        }
    }
})
