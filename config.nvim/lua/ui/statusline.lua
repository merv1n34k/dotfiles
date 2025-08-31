-- Special thanks to mcauley-penney for this amazing config!
-- See https://github.com/mcauley-penney/nvim/blob/main/lua/ui/tabline.lua


local M = {}

local api, fn, bo = vim.api, vim.fn, vim.bo
local get_opt = api.nvim_get_option_value

local utils = require("core.utils")
local icons = utils.data.ui.icons
local mini_icons = require("mini.icons")

local HL = {
    branch = { "DiagnosticOk", icons.branch },
    file = { "NonText", icons.node },
    fileinfo = { "Function", icons.document },
    nomodifiable = { "DiagnosticWarn", icons.bullet },
    modified = { "DiagnosticError", icons.bullet },
    readonly = { "DiagnosticWarn", icons.lock },
    error = { "DiagnosticError", icons.error },
    warn = { "DiagnosticWarn", icons.warning },
    visual = { "DiagnosticInfo", "‹› " },
}

local ICON = {}
for k, v in pairs(HL) do
    ICON[k] = utils.hl_str(v[1], v[2])
end

local IGNORE = {
    "quickfix",
    "prompt",
    "nofile",
    "alpha",
    "NvimTree",
    "neo-tree",
    "Outline",
    "TelescopePrompt",
}

local ORDER = {
    "pad",
    "mode",
    "git",
    "path",
    "venv",
    "mod",
    "ro",
    "sep",
    "diff",
    "diag",
    "fileinfo",
    "pad",
    "scrollbar",
    "pad",
}

local PAD = " "
local SEP = "%="

-- utilities -----------------------------------------
local function concat(parts)
    local out, i = {}, 1
    for _, k in ipairs(ORDER) do
        local v = parts[k]
        if v and v ~= "" then
            out[i] = v
            i = i + 1
        end
    end
    return table.concat(out, " ")
end

local function esc_str(str)
    return str:gsub("([%(%)%%%+%-%*%?%[%]%^%$])", "%%%1")
end

local function check_width(parts, part, win_w)
    local width = concat(parts):gsub("%%#.-#(.-)%%[*#]", "%1")
    local part = parts[part]
    if part then part = part:gsub("%%#.-#(.-)%%[*#]", "%1") else part = "" end
    local need = #width - #part

    if win_w and need < win_w then
        return true
    end

    return false
end

-- mode info
local function mode_widget()
    local mode = vim.api.nvim_get_mode()["mode"]

    if mode == "n" then
        mode = utils.hl_str("String", "NORMAL")
    elseif mode == "v" then
        mode = utils.hl_str("Search", "VISUAL")
    elseif mode == "V" then
        mode = utils.hl_str("Search", "V" .. icons.bullet .. "LINE")
    elseif mode == "R" then
        mode = utils.hl_str("Substitute", "REPLACE")
    elseif mode == "i" then
        mode = utils.hl_str("ModeMsg", "INSERT")
    elseif mode == "c" then
        mode = utils.hl_str("CurSearch", "COMMAND")
    elseif mode == "t" then
        mode = utils.hl_str("ModeMsg", "TERM")
    else
        mode = utils.hl_str("String", "MODE")
    end

    return mode
end

-- git info -----------------------------------------
local function git_widget(root, width)
    local remote = utils.get_git_remote_name(root) or ""
    local branch = utils.get_git_branch(root) or ""

    local repo_info = ""

    if branch then
        branch = utils.hl_str("Substitute", "@ " .. branch)

        local need = #remote + #branch
        if width < need + 60 then remote = "" end

        repo_info = string.format("%s %s %s ", ICON.branch, remote, branch)
    end

    return repo_info
end

-- path info -----------------------------------------
local function path_widget(root, fname, width)
    local file_name = fn.fnamemodify(fname, ":t")
    if fname == "" then file_name = "[No Name]" end

    local path = file_name

    if bo.buftype == "help" then return path end

    local dir_path = fn.fnamemodify(fname, ":h") .. "/"

    if dir_path == "./" then dir_path = "" end

    if root and dir_path then
        dir_path = dir_path:gsub("^" .. esc_str(root) .. "/", "")
    end

    local need = #dir_path + #path
    if width < need + 80 then dir_path = "" end

    return dir_path .. path
end

-- diagnostics ---------------------------------------------
local function diagnostics_widget()
    if not utils.diagnostics_available() then return "" end
    local diag_count = vim.diagnostic.count()
    local err, warn =
        string.format("%-3d", diag_count[1] or 0),
        string.format("%-3d", diag_count[2] or 0)

    return string.format(
        "%s%s %s%s ",
        ICON.error,
        utils.hl_str("DiagnosticError", err),
        ICON.warn,
        utils.hl_str("DiagnosticWarn", warn)
    )
end

-- git diff ------------------------------------------------
local function diff_widget(fname)
    -- Check if we have a filename
    local file_name = fn.fnamemodify(fname, ":t")
    if file_name == '' then
        return nil
    end

    -- Run git diff on current file
    local cmd = string.format(
        'git -C %s --no-pager diff --no-color --no-ext-diff -U0 -- %s',
        vim.fn.shellescape(fn.fnamemodify(fname, ":h")),
        vim.fn.shellescape(file_name)
    )

    local output = vim.fn.system(cmd)

    -- Return nil if not in a git repo or command failed
    if vim.v.shell_error ~= 0 then
        return nil
    end

    -- Count the changes
    local added, removed, modified = 0, 0, 0

    for line in output:gmatch("[^\n]+") do
        -- Look for diff hunk headers (lines starting with @@)
        if line:match("^@@ ") then
            -- Extract line counts: @@ -old_start,old_count +new_start,new_count @@
            local old_count = line:match("^@@ %-[%d]+,?([%d]*) %+") or "1"
            local new_count = line:match("%+[%d]+,?([%d]*) @@") or "1"

            old_count = old_count == "" and 1 or tonumber(old_count)
            new_count = new_count == "" and 1 or tonumber(new_count)

            -- Classify the change
            if old_count == 0 and new_count > 0 then
                added = added + new_count
            elseif old_count > 0 and new_count == 0 then
                removed = removed + old_count
            else
                local min = math.min(old_count, new_count)
                modified = modified + min
                added = added + (new_count - min)
                removed = removed + (old_count - min)
            end
        end
    end

    return string.format(
        "%s %s %s ",
        utils.hl_str("DiffAdd", "+" .. added),
        utils.hl_str("DiffChange", "~" .. modified),
        utils.hl_str("DiffDelete", "-" .. removed)
    )
end

-- file/selection info -------------------------------------
local function fileinfo_widget(fname)
    local ft = get_opt("filetype", {})
    local lines = utils.group_number(api.nvim_buf_line_count(0), ",")

    local file_name = fn.fnamemodify(fname, ":t")

    if fname == "" then file_name = "[No Name]" end

    local icon, hl
    icon, hl = mini_icons.get("file", file_name)

    local str = utils.hl_str(hl, icon) .. " "

    if not utils.data.nonprog_modes[ft] then
        return str .. string.format("%3s lines", lines)
    end

    local wc = fn.wordcount()
    if not wc.visual_words then
        return str
            .. string.format(
                "%3s lines  %3s words",
                lines,
                utils.group_number(wc.words, ",")
            )
    end

    local vlines = math.abs(fn.line(".") - fn.line("v")) + 1
    return str
        .. string.format(
            "%3s lines %3s words  %3s chars",
            utils.group_number(vlines, ","),
            utils.group_number(wc.visual_words, ","),
            utils.group_number(wc.visual_chars, ",")
        )
end

-- python venv ---------------------------------------------
local function venv_widget()
    if bo.filetype ~= "python" then return "" end
    local env = vim.env.VIRTUAL_ENV

    local str
    if env and env ~= "" then
        str = string.format("[.venv: %s]  ", fn.fnamemodify(env, ":t"))
        return utils.hl_str("Comment", str)
    end
    env = vim.env.CONDA_DEFAULT_ENV
    if env and env ~= "" then
        str = string.format("[conda: %s]  ", env)
        return utils.hl_str("Comment", str)
    end
    return utils.hl_str("Comment", "[no venv]")
end

-- scrollbar ---------------------------------------------
local function scrollbar_widget()
    local cur = api.nvim_win_get_cursor(0)[1]
    local total = api.nvim_buf_line_count(0)
    local idx = math.ceil(((cur - 1) / total) * 100)
    return utils.hl_str("Substitute", tostring(idx) .. "%%")
end

-- render ---------------------------------------------
function M.render()
    -- Check if statusline_winid is valid, fallback to current window
    local winid = vim.g.statusline_winid
    if not winid or not api.nvim_win_is_valid(winid) then
        winid = api.nvim_get_current_win()
    end

    -- Check if it's a floating window and return early with simple text
    local config = api.nvim_win_get_config(winid)
    if config.relative ~= "" then
        return " " -- Or return "" for completely empty
    end

    -- Get the buffer from the statusline window (not current buffer!)
    local buf = api.nvim_win_get_buf(winid)

    -- Now get fname and buftype from the correct buffer
    local fname = api.nvim_buf_get_name(buf)
    local buftype = vim.bo[buf].buftype
    local filetype = vim.bo[buf].filetype

    -- Hide statusline if buftype or filetype is in ignore list
    if vim.tbl_contains(IGNORE, buftype) or vim.tbl_contains(IGNORE, filetype) then
        return " "
    end

    local root = (buftype == "" and utils.get_path_root(fname)) or nil
    if buftype ~= "" and buftype ~= "help" then
        fname = vim.bo[buf].filetype
    end

    local win_w = api.nvim_win_get_width(winid)

    -- Build essential parts first
    local parts = {
        pad = PAD,
        mode = mode_widget(),
        path = path_widget(root, fname, win_w),
        git = git_widget(root, win_w),
        venv = venv_widget(),
        mod = get_opt("modifiable", { buf = buf })
            and (get_opt("modified", { buf = buf }) and ICON.modified or " ")
            or ICON.nomodifiable,
        ro = get_opt("readonly", { buf = buf }) and ICON.readonly or "",
        sep = SEP,
        diff = diff_widget(fname),
        diag = diagnostics_widget(),
        fileinfo = fileinfo_widget(fname),
        scrollbar = scrollbar_widget(),
    }

    -- remove non essential widgets if width is too narrow
    for _, part in pairs({ "path", "git", "venv", "diff", "diag" }) do
        if check_width(parts, part, win_w) ~= true then
            parts[part] = ""
        end
    end

    return concat(parts)
end

vim.o.statusline = "%!v:lua.require('ui.statusline').render()"

return M
