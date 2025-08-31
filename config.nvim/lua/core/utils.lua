local fn = vim.fn

local M = {}

function M.executable(name)
    if fn.executable(name) > 0 then
        return true
    end

    return false
end

--- check whether a feature exists in Nvim
--- @feat: string
---   the feature name, like `nvim-0.7` or `unix`.
--- return: bool
M.has = function(feat)
    if fn.has(feat) == 1 then
        return true
    end

    return false
end

--- Create a dir if it does not exist
function M.may_create_dir(dir)
    local res = fn.isdirectory(dir)

    if res == 0 then
        fn.mkdir(dir, "p")
    end
end

--- Generate random integers in the range [Low, High], inclusive,
--- adapted from https://stackoverflow.com/a/12739441/6064933
--- @low: the lower value for this range
--- @high: the upper value for this range
function M.rand_int(low, high)
    -- Use lua to generate random int, see also: https://stackoverflow.com/a/20157671/6064933
    math.randomseed(os.time())

    return math.random(low, high)
end

--- Select a random element from a sequence/list.
--- @seq: the sequence to choose an element
function M.rand_element(seq)
    local idx = M.rand_int(1, #seq)

    return seq[idx]
end

M.data = {
    ui = {
        icons = {
            branch = "",
            bullet = "•",
            open_bullet = "○",
            ok = "✔",
            d_chev = "∨",
            ellipses = "…",
            node = "╼",
            document = "≡",
            lock = "",
            r_chev = ">",
            warning = " ",
            error = " ",
            info = "󰌶 ",
            deleted = "x",
            modified = "~",
            added = "+",
            stack = ""
        },
        kind_icons = {
            Array = " 󰅪 ",
            BlockMappingPair = " 󰅩 ",
            Boolean = "  ",
            BreakStatement = " 󰙧 ",
            Call = " 󰃷 ",
            CaseStatement = " 󰨚 ",
            Class = "  ",
            Color = "  ",
            Constant = "  ",
            Constructor = " 󰆧 ",
            ContinueStatement = "  ",
            Copilot = "  ",
            Declaration = " 󰙠 ",
            Delete = " 󰩺 ",
            DoStatement = " 󰑖 ",
            Element = " 󰅩 ",
            Enum = "  ",
            EnumMember = "  ",
            Event = "  ",
            Field = "  ",
            File = "  ",
            Folder = "  ",
            ForStatement = "󰑖 ",
            Function = " 󰆧 ",
            GotoStatement = " 󰁔 ",
            Identifier = " 󰀫 ",
            IfStatement = " 󰇉 ",
            Interface = "  ",
            Keyword = "  ",
            List = " 󰅪 ",
            Log = " 󰦪 ",
            Lsp = "  ",
            Macro = " 󰁌 ",
            MarkdownH1 = " 󰉫 ",
            MarkdownH2 = " 󰉬 ",
            MarkdownH3 = " 󰉭 ",
            MarkdownH4 = " 󰉮 ",
            MarkdownH5 = " 󰉯 ",
            MarkdownH6 = " 󰉰 ",
            Method = " 󰆧 ",
            Module = " 󰅩 ",
            Namespace = " 󰅩 ",
            Null = " 󰢤 ",
            Number = " 󰎠 ",
            Object = " 󰅩 ",
            Operator = "  ",
            Package = " 󰆧 ",
            Pair = " 󰅪 ",
            Property = "  ",
            Reference = "  ",
            Regex = "  ",
            Repeat = " 󰑖 ",
            Return = " 󰌑 ",
            RuleSet = " 󰅩 ",
            Scope = " 󰅩 ",
            Section = " 󰅩 ",
            Snippet = "  ",
            Specifier = " 󰦪 ",
            Statement = " 󰅩 ",
            String = "  ",
            Struct = "  ",
            SwitchStatement = " 󰨙 ",
            Table = " 󰅩 ",
            Terminal = "  ",
            Text = " 󰀬 ",
            Type = "  ",
            TypeParameter = "  ",
            Unit = "  ",
            Value = "  ",
            Variable = "  ",
            WhileStatement = " 󰑖 ",
        },
    },
    nonprog_modes = {
        ["markdown"] = true,
        ["org"] = true,
        ["orgagenda"] = true,
        ["text"] = true,
    },
}

local icons_spaced = {}
for key, value in pairs(M.data.ui.kind_icons) do
    icons_spaced[key] = value .. " "
end

M.data.ui.kind_icons_spaced = icons_spaced

-- files and directories -----------------------------
local branch_cache = setmetatable({}, { __mode = "k" })
local remote_cache = setmetatable({}, { __mode = "k" })

--- get the path to the root of the current file. The
-- root can be anything we define, such as ".git",
-- "Makefile", etc.
-- see https://www.reddit.com/r/neovim/comments/zy5s0l/you_dont_need_vimrooter_usually_or_how_to_set_up/
-- @tparam  path: file to get root of
-- @treturn path to the root of the filepath parameter
M.get_path_root = function(path)
    if path == "" then return end

    local root = vim.b.path_root
    if root then return root end

    local root_items = {
        ".git",
    }

    root = vim.fs.root(path, root_items)
    if root == nil then return nil end
    if root then vim.b.path_root = root end
    return root
end

local function git_cmd(root, ...)
    local job = vim.system({ "git", "-C", root, ... }, { text = true }):wait()

    if job.code ~= 0 then return nil, job.stderr end
    return vim.trim(job.stdout)
end

-- get the name of the remote repository
M.get_git_remote_name = function(root)
    if not root then return nil end
    if remote_cache[root] then return remote_cache[root] end

    local out = git_cmd(root, "config", "--get", "remote.origin.url")
    if not out then return nil end

    -- normalise to short repo name
    out = out:gsub(":", "/"):gsub("%.git$", ""):match("([^/]+/[^/]+)$")

    remote_cache[root] = out
    return out
end

function M.get_git_branch(root)
    if not root then return nil end
    if branch_cache[root] then return branch_cache[root] end

    local out = git_cmd(root, "rev-parse", "--abbrev-ref", "HEAD")
    if out == "HEAD" then
        local commit = git_cmd(root, "rev-parse", "--short", "HEAD")
        commit = M.hl_str("Comment", "(" .. commit .. ")")
        out = string.format("%s %s", out, commit)
    end

    branch_cache[root] = out

    return out
end

-- LSP -----------------------------
M.diagnostics_available = function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    local diagnostics = vim.lsp.protocol.Methods.textDocument_publishDiagnostics

    for _, cfg in pairs(clients) do
        if cfg:supports_method(diagnostics) then return true end
    end

    return false
end

-- highlighting -----------------------------
M.hl_str = function(hl, str) return "%#" .. hl .. "#" .. str .. "%*" end

-- insert grouping separators in numbers
-- viml regex: https://stackoverflow.com/a/42911668
-- lua pattern: stolen from Akinsho
M.group_number = function(num, sep)
    if num < 999 then return tostring(num) end

    num = tostring(num)
    return num:reverse():gsub("(%d%d%d)", "%1" .. sep):reverse():gsub("^,", "")
end

return M
