vim.keymap.set("n", "<Space>", "za")
vim.keymap.set("n", "<leader><Space>", "zA")

-- vim.keymap.set("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{async=true}<CR>")
-- vim.keymap.set("i", "<leader>lf", "<cmd>lua vim.lsp.buf.format{async=true}<CR>")

vim.keymap.set("t", "<A-[>", "<C-\\><C-n>")
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l")
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h")
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j")
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k")

vim.keymap.set("n", "<leader>p", "<Plug>PlenaryTestFile", { desc = "Run test file you are in" })
vim.keymap.set("n", "<leader>s", ":SymbolsOutline<CR>", { desc = "Open symbols outline" })
vim.keymap.set("n", "<leader>S", ":Navbuddy<CR>", { desc = "Open navbuddy" })

vim.keymap.set("n", "<leader>s", ":SymbolsOutline<CR>", { desc = "Symbols outline" })

vim.keymap.set("n", "yy", '"+yy', { desc = "Yanking" })
vim.keymap.set("n", "y", '"+y', { desc = "Yanking" })
vim.keymap.set("x", "y", '"+y', { desc = "Yanking" })
vim.keymap.set("n", "Y", '"+y$', { desc = "Yanking" })
vim.keymap.set("x", "Y", '"+Y', { desc = "Yanking" })


vim.keymap.set("n", "<C-i>", "<C-a>", { desc = "Increment number" })
vim.keymap.set("x", "<C-i>", "g<C-a>", { desc = "Increment number" })

-- vim.keymap.set("n", "cN", "<cmd>cnext<CR>zz", { desc = "Next quickfix" })
-- vim.keymap.set("n", "cP", "<cmd>cprev<CR>zz", { desc = "Previous quickfix" })

vim.keymap.set("n", "<leader>df", "<cmd>lua require('neogen').generate()<CR>", { desc = "Generate function docstring" })
vim.keymap.set("n", "<leader>dc", "<cmd>lua require('neogen').generate({type='class'})<CR>",
    { desc = "Generate class docstring" })

vim.keymap.set("n", "<Leader>dl", "<cmd>lua require'dap'.step_into()<CR>", { desc = "Debugger step into" })
vim.keymap.set("n", "<Leader>dj", "<cmd>lua require'dap'.step_over()<CR>", { desc = "Debugger step over" })
vim.keymap.set("n", "<Leader>dk", "<cmd>lua require'dap'.step_out()<CR>", { desc = "Debugger step out" })
vim.keymap.set("n", "<Leader>dc", "<cmd>lua require'dap'.continue()<CR>", { desc = "Debugger continue" })
vim.keymap.set("n", "<Leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>",
    { desc = "Debugger toggle breakpoint" })
vim.keymap.set(
    "n",
    "<Leader>dd",
    "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
    { desc = "Debugger set conditional breakpoint" }
)
vim.keymap.set("n", "<Leader>de", "<cmd>lua require'dap'.terminate()<CR>", { desc = "Debugger reset" })
vim.keymap.set("n", "<Leader>dr", "<cmd>lua require'dap'.run_last()<CR>", { desc = "Debugger run last" })

vim.api.nvim_set_keymap('n', '<leader>sb', "<cmd>lua require('plugins.telescope-azstorage').search_blobs()<CR>",
    { noremap = true, silent = true })

vim.keymap.set("n", "<leader>gf", ":Telescope git_file_history<CR>", { desc = "Github file history" })

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
        return
    end

    local special_filetypes = { "rust", "javascript", "typescript", "javascriptreact", "typescriptreact" }

    if is_special(special_filetypes, filetype) then
        _G.current_colorscheme = "catppuccin-latte"
        vim.schedule(function()
            vim.cmd.colorscheme(_G.current_colorscheme)
            require("lualine").setup {
                options = { theme = "catppuccin" }
            }
        end)
    else
        _G.current_colorscheme = "kanagawa-wave"
        vim.schedule(function()
            vim.cmd.colorscheme(_G.current_colorscheme)
            require("lualine").setup {
                options = { theme = "kanagawa" }
            }
        end)
    end
end

vim.api.nvim_create_augroup('ChangeColorscheme', { clear = true })

vim.api.nvim_create_autocmd({ 'Filetype', 'BufEnter' }, {
    group = 'ChangeColorscheme',
    desc = "Change colorscheme based on filetype",
    pattern = '*',
    callback = change_colorscheme,
})

-- you need to run this after the plugin runs.
local buf = vim.api.nvim_get_current_buf()
local group = 'jupyterrender_' .. buf

-- Clear the plugin’s autocmd
vim.api.nvim_clear_autocmds({ group = group, buffer = buf })

-- Recreate it and include BufWritePre and BufWritePost calls
vim.api.nvim_create_autocmd("BufWriteCmd", {
    group = group,
    buffer = buf,
    callback = function()
        vim.cmd('doautocmd <nomodeline> BufWritePre')
        print("saving notebook") -- anything you want
        local nb = require('nvim-jupyter-client').get_notebook()
        if nb then
            nb:save()
            vim.bo[buf].modified = false
        end
        vim.cmd('doautocmd <nomodeline> BufWritePost')
    end
})
