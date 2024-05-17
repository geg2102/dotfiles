vim.keymap.set("n", "<Space>", "za")
vim.keymap.set("n", "<leader><Space>", "zA")

vim.keymap.set("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{async=true}<CR>")
vim.keymap.set("i", "<leader>lf", "<cmd>lua vim.lsp.buf.format{async=true}<CR>")

vim.keymap.set("t", "<A-[>", "<C-\\><C-n>")
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l")
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h")
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j")
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k")

vim.keymap.set("n", "<leader>p", "<Plug>PlenaryTestFile", { desc = "Run test file you are in" })
vim.keymap.set("n", "<leader>s", ":SymbolsOutline<CR>", { desc = "Open symbols outline" })
vim.keymap.set("n", "<leader>S", ":Navbuddy<CR>", { desc = "Open navbuddy" })

vim.keymap.set("n", "<leader>s", ":SymbolsOutline<CR>", { desc = "Symbols outline" })

vim.keymap.set("n", "yy", '"+yy', { desc = "Symbols outline" })
vim.keymap.set("n", "y", '"+y', { desc = "Symbols outline" })
vim.keymap.set("x", "y", '"+y', { desc = "Symbols outline" })

local colorcolumn = vim.api.nvim_create_augroup("ColorColumn", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "python", "c", "cpp", "h", "lua", "scala" },
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
