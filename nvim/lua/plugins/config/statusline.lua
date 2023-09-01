
local function spell()
  if vim.o.spell then
    return string.format("[SPELL]")
  end

  return ""
end

local diff = function()
  local git_status = vim.b.gitsigns_status_dict
  if git_status == nil then
    return
  end

  local modify_num = git_status.changed
  local remove_num = git_status.removed
  local add_num = git_status.added

  local info = { added = add_num, modified = modify_num, removed = remove_num }
  -- vim.print(info)
  return info
end

require("lualine").setup {
  options = {
    icons_enabled = true,
    theme = "auto",
    component_separators = {left = '|', right = '|'},
    section_separators = "",
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = {
      "branch",
      {
        "diff",
        source = diff,
      },
    },
    lualine_c = {
      "filename",
    },
    lualine_x = {
      "encoding",
      {
        "fileformat",
        symbols = {
          unix = "unix",
          dos = "win",
          mac = "mac",
        },
      },
      "filetype",
    },
    lualine_y = {
      "progress",
    },
    lualine_z = {
      "location",
    }
  },
  -- ]]
  extensions = { "quickfix", "nvim-tree" },
}
