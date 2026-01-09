local colorcolumn = vim.api.nvim_create_augroup("ColorColumn", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "*.py", "*.c", "*.cpp", "*.h", "*.lua", "*.scala" },
    command = "silent! set colorcolumn=88",
    group = colorcolumn
})

local jsonconceal = vim.api.nvim_create_augroup("JsonConceal", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "json" },
    command = "silent! set conceallevel=0",
    group = jsonconceal
})

vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank({ timeout = 200 })
    end,
})

P = function(v)
    print(vim.inspect(v))
    return v
end

vim.api.nvim_create_autocmd({ "BufEnter" },
    {
        pattern = "*",
        desc = "Disable syntax highlighting in files larger than 1MB",
        callback = function(args)
            local success, highlighter = pcall(require "vim.treesitter.highlighter")
            if success then
                local ts_was_active = highlighter.active[args.buf]
                local file_size = vim.fn.getfsize(args.file)
                if (file_size > 1024 * 1024) then
                    pcall(vim.cmd("TSBufDisable highlight"))
                    -- vim.cmd("syntax off")
                    -- vim.cmd("syntax clear")
                    vim.cmd("IlluminatePauseBuf")
                    vim.cmd("IndentBlanklineDisable")
                    vim.cmd("NoMatchParen")
                    if (ts_was_active) then
                        vim.notify("File larger than 1MB, turned off syntax highlighting")
                    end
                end
            end
        end
    })

-- Store the current colorscheme globally
_G.current_colorscheme = _G.current_colorscheme or "nightfox"

local function change_colorscheme()
    local filetype = vim.bo.filetype
    local buftype = vim.bo.buftype

    -- Don't change colorscheme for special buffer types
    if buftype ~= "" then
        return
    end

    local function is_special(tab, val)
        for _, value in ipairs(tab) do
            if value == val then
                return true
            end
        end
        return false
    end

    local exclude_filetypes = { "qf", "help", "TelescopePrompt", "noice", "cmdwin" }
    if is_special(exclude_filetypes, filetype) then
        vim.cmd("hi clear")
        vim.cmd.colorscheme(_G.current_colorscheme)
        return
    end

    local special_filetypes = { "rust", "javascript", "typescript", "javascriptreact", "typescriptreact", "go", "gomod" }

    if is_special(special_filetypes, filetype) then
        if _G.current_colorscheme ~= "dayfox" then
            vim.schedule(function()
                -- _G.current_colorscheme = "kanagawa-wave"
                _G.current_colorscheme = "dayfox"
                vim.cmd.colorscheme(_G.current_colorscheme)
                vim.go.background = "light"
            end
            )
            -- require("lualine").setup({
            --     options = {
            --         theme = "catppuccin"
            --     }
            -- })
        else
            return
        end
    else
        if _G.current_colorscheme ~= "nightfox" then
            vim.schedule(function()
                _G.current_colorscheme = "nightfox"
                vim.cmd.colorscheme(_G.current_colorscheme)
                vim.go.background = "dark"
            end
            )
            -- require("lualine").setup({
            --     options = {
            --         theme = "kanagawa"
            --     }
            -- })
        else
            return
        end
    end
end

vim.api.nvim_create_augroup('ChangeColorscheme', { clear = true })

vim.api.nvim_create_autocmd({ 'Filetype', 'BufRead' }, {
    group = 'ChangeColorscheme',
    desc = "Change colorscheme based on filetype",
    pattern = '*',
    callback = change_colorscheme,
})

vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
    pattern = { "DiffviewFiles", "DiffviewFileHistory", "DiffviewFilePanel" },
    callback = function()
        vim.cmd("vert resize 30")
    end,
})

local ignore_filetypes = { 'neo-tree', 'dbui', 'snacks_picker_list' }
local ignore_buftypes = { 'nofile', 'prompt', 'popup' }

local augroup =
    vim.api.nvim_create_augroup('FocusDisable', { clear = true })

-- Combined callback function for both checks
local function set_focus_disable()
    local is_ignored_buftype = vim.tbl_contains(ignore_buftypes, vim.bo.buftype)
    local is_ignored_filetype = vim.tbl_contains(ignore_filetypes, vim.bo.filetype)

    local disable_focus = is_ignored_buftype or is_ignored_filetype

    -- We set both the window-local and buffer-local variables
    -- This ensures both are set when you enter the buffer/window.
    vim.w.focus_disable = disable_focus
    vim.b.focus_disable = disable_focus
end

-- Use BufWinEnter to catch both when a window is entered AND when a buffer is loaded/changed in that window.
-- This is often more reliable than separate WinEnter and FileType events.
vim.api.nvim_create_autocmd({ 'WinEnter', 'BufWinEnter' }, {
    group = augroup,
    callback = set_focus_disable,
    desc = 'Disable focus autoresize for ignored buffer/filetypes',
})


vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(args)
        vim.lsp.inlay_hint.enable(false, { bufnr = args.buf })
    end,
})

local org_settings = vim.api.nvim_create_augroup('OrgSettings', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
    group = org_settings,
    pattern = 'org', -- This targets only .org files
    callback = function()
        -- Enable Treesitter folding
        -- Note: 0 refers to the current buffer/window
        vim.wo.foldmethod = 'expr'
        vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.wo.foldlevel = 99

        vim.bo.smartindent = false
        vim.bo.cindent = false
        vim.bo.autoindent = false
        vim.keymap.set('i', '<F11>', function()
            return '<Cmd>lua require("orgmode").action("org_mappings.meta_return")<CR>'
        end, { buffer = true, expr = true }) -- This only works because of alacritty remapping

        -- Auto-continue comments/lists
        -- vim.opt_local.formatoptions:remove({ 'o', 'r' })
    end,
})

local function align_org_tags()
    local bufnr = vim.api.nvim_get_current_buf()
    local target_col = 80
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    for i, line in ipairs(lines) do
        -- 1. Match any headline (*) that ends with :tags:
        -- Note the %- which escapes the hyphen for tags like :tech-stack:
        if line:match('^%*+.*:[%w_@#%%%-:]+:$') then
            -- 2. Split into headline content and the tag block
            local before, tags = line:match('^(.-)%s*(:[%w_@#%%%-:]+:)$')

            if before and tags then
                before = before:gsub('%s*$', '') -- Clean trailing whitespace
                local before_width = vim.fn.strdisplaywidth(before)
                local spaces = target_col - before_width

                if spaces < 1 then
                    lines[i] = before .. ' ' .. tags
                else
                    lines[i] = before .. string.rep(' ', spaces) .. tags
                end
            end
        end
    end

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
end

vim.api.nvim_create_autocmd('BufWritePre', {
    group = org_settings,
    pattern = '*.org',
    callback = align_org_tags,
})
