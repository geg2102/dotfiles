local lsp_utils = require("lsp_utils")

vim.keymap.set("n", "<leader>ut", function() lsp_utils.toggle_basedpyright_settings() end,
    { desc = "Toggle BasedPyright Settings" })

vim.keymap.set('n', '<leader>U', function() vim.cmd([[%s/[^\x00-\x7F]//g]]) end, { desc = "Remove non-ascii characters" })

vim.keymap.set("n", "<Space>", "za", { desc = "Toggle fold" })
vim.keymap.set("n", "<leader><Space>", "zA", { desc = "Toggle all folds" })
-- vim.keymap.set("n", "zR", require("ufo").openallFolds, { desc = "Open all folds" })
-- vim.keymap.set("n", "zM", require("ufo").closeallFolds, { desc = "Close all folds" })

-- vim.keymap.set("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{async=true}<CR>")
-- vim.keymap.set("i", "<leader>lf", "<cmd>lua vim.lsp.buf.format{async=true}<CR>")

vim.keymap.set("t", "<A-[>", "<C-\\><C-n>")
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l")
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h")
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j")
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k")
vim.keymap.set("t", "<leader><Esc>", "<C-\\><C-n>")

vim.keymap.set("n", "<leader>p", "<Plug>PlenaryTestFile", { desc = "Run test file you are in" })
vim.keymap.set("n", "<leader>s", ":SymbolsOutline<CR>", { desc = "Open symbols outline" })
vim.keymap.set("n", "<leader>S", ":Navbuddy<CR>", { desc = "Open navbuddy" })

vim.keymap.set("n", "<leader>s", ":SymbolsOutline<CR>", { desc = "Symbols outline" })

vim.keymap.set("n", "<leader>du", "<cmd>DBUIToggle<cr>", { desc = "Toggle Dadbod UI" })
-- vim.keymap.set("n", "yy", '"+yy', { desc = "Yanking" })
-- vim.keymap.set("n", "y", '"+y', { desc = "Yanking" })
-- vim.keymap.set("x", "y", '"+y', { desc = "Yanking" })
-- vim.keymap.set("n", "Y", '"+y$', { desc = "Yanking" })
-- vim.keymap.set("x", "Y", '"+Y', { desc = "Yanking" })
--

vim.keymap.set("n", "<C-i>", "<C-a>", { desc = "Increment number" })
vim.keymap.set("x", "<C-i>", "g<C-a>", { desc = "Increment number" })
vim.keymap.set("n", "\\c", function()
    vim.cmd("/\\%" .. vim.fn.virtcol('.') .. "c\\S")
end, { noremap = true })

vim.keymap.set("n", "\\C", function()
    vim.cmd("?\\%" .. vim.fn.virtcol('.') .. "c\\S")
end, { noremap = true })
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

vim.keymap.set("n", "<leader>tc", function()
    if _G.current_colorscheme == "nightfox" then
        _G.current_colorscheme = "dayfox"
        vim.cmd.colorscheme(_G.current_colorscheme)
        vim.go.background = "light"
        -- require("lualine").setup({ options = { theme = "catppuccin" } })
    else
        _G.current_colorscheme = "nightfox"
        vim.cmd.colorscheme(_G.current_colorscheme)
        vim.go.background = "dark"
        -- require("lualine").setup({ options = { theme = "kanagawa" } })
    end
end, { desc = "Toggle colorscheme " })

vim.b.inlay_hints_enabled = true -- initial state

vim.keymap.set("n", "<leader>ih", function()
    local current = vim.b.inlay_hints_enabled
    local new_value = not current
    vim.lsp.inlay_hint.enable(new_value)
    vim.b.inlay_hints_enabled = new_value
    print("Inlay hints " .. (new_value and "enabled" or "disabled"))
end, { desc = "Toggle Inlay Hints" })
