local M = {}

-- TODO: add distinct parent for identical filenames
-- TODO: fix tabs overflow (show only n next tabs aside the selected tab)

local api, fn, bo = vim.api, vim.fn, vim.bo
local utils = require("core.utils")
local mini_icons = require("mini.icons")

-- Setup tabline
vim.o.tabline = "%!v:lua.require('ui.tabline').render()"

-- Highlight groups and icons setup
local icons = utils.data.ui.icons
local HL = {
    modified = { "DiagnosticError", icons.bullet },
    readonly = { "DiagnosticWarn", icons.lock },
    nomodifiable = { "DiagnosticWarn", icons.bullet },
    file = { "NonText", icons.node },
    number = { "Comment", "" },
    number_current = { "Number", "" },
}

-- Generate icon strings with highlighting
local ICON = {}
for k, v in pairs(HL) do
    if v[2] and v[2] ~= "" then
        ICON[k] = utils.hl_str(v[1], v[2])
    end
end

-- Buffer order storage
local buffer_order = {}

-- Check if buffer should be shown
local function is_valid_buffer(bufnr)
    local buftype = bo[bufnr].buftype
    if buftype ~= "" and buftype ~= "help" then
        return false
    end
    return bo[bufnr].buflisted
end

-- Get buffer order
local function get_buffer_order()
    local buffers = {}

    for _, bufnr in ipairs(api.nvim_list_bufs()) do
        if is_valid_buffer(bufnr) then
            table.insert(buffers, bufnr)
        end
    end

    -- Initialize or clean buffer_order
    if #buffer_order == 0 then
        buffer_order = buffers
    else
        -- Remove closed buffers
        local valid_order = {}
        for _, bufnr in ipairs(buffer_order) do
            if vim.tbl_contains(buffers, bufnr) then
                table.insert(valid_order, bufnr)
            end
        end

        -- Add new buffers
        for _, bufnr in ipairs(buffers) do
            if not vim.tbl_contains(valid_order, bufnr) then
                table.insert(valid_order, bufnr)
            end
        end

        buffer_order = valid_order
    end

    return buffer_order
end

-- Get file icon using mini.icons
local function get_file_icon(filename, filetype)
    local icon = mini_icons.get("file", filename)
    if icon then
        return icon
    end

    icon = mini_icons.get("filetype", filetype)
    if icon then
        return icon
    end

    return ICON.file
end

-- Get status indicator
local function get_status_indicator(bufnr)
    if bo[bufnr].modified then
        return " " .. ICON.modified
    elseif bo[bufnr].readonly then
        return " " .. ICON.readonly
    elseif not bo[bufnr].modifiable then
        return " " .. ICON.nomodifiable
    end
    return ""
end

-- Truncate filename
local function truncate_filename(name, max_length)
    if #name <= max_length then
        return name
    end
    return string.sub(name, 1, max_length - 3) .. "..."
end

-- Main render function
function M.render()
    local current_buf = api.nvim_get_current_buf()
    local buffers = get_buffer_order()

    if #buffers == 0 then
        return ""
    end

    local out = {}

    for idx, bufnr in ipairs(buffers) do
        local is_current = bufnr == current_buf
        local hl = is_current and HL.number_current[1] or "TabLine"

        -- Get buffer name
        local name = api.nvim_buf_get_name(bufnr)
        local display_name = name == "" and "[No Name]" or fn.fnamemodify(name, ":t")
        display_name = truncate_filename(display_name, 20)

        -- Get icon and status
        local filetype = bo[bufnr].filetype
        local icon = get_file_icon(name, filetype)
        local status = get_status_indicator(bufnr)

        -- Index icon with highlighting
        local index_hl = is_current and HL.number_current[1] or HL.number[1]
        local index_icon = utils.hl_str(index_hl, string.format("%d ", idx))

        -- Build clickable tab
        local tab = string.format(
            "%%%dT%s %s%s %s%s %%T",
            bufnr,
            utils.hl_str(hl, ""),
            index_icon,
            utils.hl_str(hl, icon),
            utils.hl_str(hl, display_name),
            status
        )

        table.insert(out, tab)
    end

    return utils.hl_str("TabLineFill", " " .. icons.stack .. "    ")
        .. table.concat(out)
        .. "%#TabLineFill#"
end

-- Navigate to specific buffer by index
function M.goto_tab(n)
    local buffers = get_buffer_order()
    if buffers[n] then
        api.nvim_set_current_buf(buffers[n])
    end
end

-- Cycle through buffers (positive = forward, negative = backward)
function M.cycle(direction)
    direction = direction or 1
    local buffers = get_buffer_order()
    local current = api.nvim_get_current_buf()

    for i, bufnr in ipairs(buffers) do
        if bufnr == current then
            local new_idx = direction > 0
                and (i % #buffers + 1)
                or (i == 1 and #buffers or i - 1)
            api.nvim_set_current_buf(buffers[new_idx])
            return
        end
    end
end

-- Move buffer in the order (positive = right, negative = left)
function M.move(direction)
    direction = direction or 1
    local current = api.nvim_get_current_buf()

    for i, bufnr in ipairs(buffer_order) do
        if bufnr == current then
            local new_idx = direction > 0
                and (i == #buffer_order and 1 or i + 1)
                or (i == 1 and #buffer_order or i - 1)

            buffer_order[i], buffer_order[new_idx] = buffer_order[new_idx], buffer_order[i]
            vim.cmd('redrawtabline')
            return
        end
    end
end

api.nvim_create_user_command('Tcyclenext', function() M.cycle(1) end, { desc = 'Cycle to next buffer' })
api.nvim_create_user_command('Tcycleprev', function() M.cycle(-1) end, { desc = 'Cycle to previous buffer' })
api.nvim_create_user_command('Tmovenext', function() M.move(1) end, { desc = 'Move buffer right' })
api.nvim_create_user_command('Tmoveprev', function() M.move(-1) end, { desc = 'Move buffer left' })

return M
