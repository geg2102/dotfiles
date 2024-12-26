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

RELOAD = function(...)
    return require("plenary.reload").reload_module(...)
end

R = function(name)
    RELOAD(name)
    return require(name)
end

vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
    pattern = { "*.lua", "*.ipynb" },
    group = vim.api.nvim_create_augroup("luabuffer", { clear = true }),
    callback = function()
        vim.keymap.set("n", "<leader>zz", function() R("nvim-jupyter-client") end, { desc = "Reload Lua File" })
    end
}
)

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
_G.current_colorscheme = _G.current_colorscheme or "kanagawa-wave"

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

    local special_filetypes = { "rust", "javascript", "typescript", "javascriptreact", "typescriptreact" }

    if is_special(special_filetypes, filetype) then
        if _G.current_colorscheme ~= "catppucin-latte" then
            vim.schedule(function()
                _G.current_colorscheme = "catppuccin-latte"
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
        if _G.current_colorscheme ~= "kanagawa-wave" then
            vim.schedule(function()
                _G.current_colorscheme = "kanagawa-wave"
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

vim.api.nvim_create_autocmd({ 'Filetype', 'BufEnter' }, {
    group = 'ChangeColorscheme',
    desc = "Change colorscheme based on filetype",
    pattern = '*',
    callback = change_colorscheme,
})
