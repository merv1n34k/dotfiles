----------------------------- builtin variables -------------------------------------------
--vim.g.loaded_python3_provider = 0  -- Disable python3 provider
vim.g.loaded_perl_provider = 0  -- Disable perl provider
vim.g.loaded_ruby_provider = 0  -- Disable ruby provider
vim.g.loaded_node_provider = 0  -- Disable node provider
vim.g.did_install_default_menus = 1  -- do not load menu

-- Custom mapping <leader> (see `:h mapleader` for more info)
vim.g.mapleader = ','

-- Enable highlighting for lua HERE doc inside vim script
vim.g.vimsyn_embed = 'l'

-- Use English as main language
-- vim.cmd [[language en_US.UTF-8]]

vim.g.logging_level = "info"
