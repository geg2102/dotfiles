local lsp_utils = require("lsp_utils")

local function start_basedpyright()
    vim.lsp.start({
        name = "basedpyright",
        cmd = { "basedpyright-langserver", "--stdio" },
        root_dir = vim.fs.dirname(vim.fs.find(
            { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
            { upward = true }
        )[1]),
    })
end

vim.keymap.set("n", "<leader>ut", function() lsp_utils.toggle_basedpyright_settings() end,
    { desc = "Toggle BasedPyright Settings" })
vim.keymap.set('n', '<leader>U', function() vim.cmd([[%s/[^\x00-\x7F]//g]]) end, { desc = "Remove non-ascii characters" })
vim.keymap.set("n", "<Space>", "za", { desc = "Toggle fold" })
vim.keymap.set("n", "<leader><Space>", "zA", { desc = "Toggle all folds" })
vim.keymap.set('n', '<leader>cc', '<cmd>ClaudeCode<CR>', { desc = 'Toggle Claude Code' })
vim.keymap.set("t", "<A-[>", "<C-\\><C-n>")
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l")
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h")
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j")
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k")
vim.keymap.set("t", "<leader><Esc>", "<C-\\><C-n>")
vim.keymap.set("n", "<leader>p", "<Plug>PlenaryTestFile", { desc = "Run test file you are in" })
vim.keymap.set("n", "<leader>du", "<cmd>DBUIToggle<cr>", { desc = "Toggle Dadbod UI" })
vim.keymap.set("n", "<C-i>", "<C-a>", { desc = "Increment number" })
vim.keymap.set("x", "<C-i>", "g<C-a>", { desc = "Increment number" })
vim.keymap.set("n", "\\c", function()
    vim.cmd("/\\%" .. vim.fn.virtcol('.') .. "c\\S")
end, { noremap = true })
vim.keymap.set("n", "\\C", function()
    vim.cmd("?\\%" .. vim.fn.virtcol('.') .. "c\\S")
end, { noremap = true })
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
vim.keymap.set("n", "<leader>ct", "<cmd>GoTestFile -v<CR>", { desc = "Run go test file" })
vim.keymap.set("n", "<leader>cf", "<cmd>GoTestFunc -v<CR>", { desc = "Run go test function" })
vim.keymap.set("n", "<leader>tc", function()
    if _G.current_colorscheme == "nightfox" then
        _G.current_colorscheme = "dayfox"
        vim.cmd.colorscheme(_G.current_colorscheme)
        vim.go.background = "light"
    else
        _G.current_colorscheme = "nightfox"
        vim.cmd.colorscheme(_G.current_colorscheme)
        vim.go.background = "dark"
    end
end, { desc = "Toggle colorscheme " })

vim.keymap.set("n", "<leader>bp", start_basedpyright, { desc = "Start BasedPyright LSP" })

vim.keymap.set("n", "<leader>osf", function() Snacks.picker.files({ cwd = "~/orgfiles", prompt = "Org Notes: " }) end,
    { desc = "Find Org Files" })
vim.keymap.set("n", "<leader>ost",
    function() Snacks.picker.grep({ cwd = "~/orgfiles", search = ":%w+:", prompt = "Org Tags: " }) end,
    { desc = "Find Org Tags" })
vim.keymap.set("n", "<leader>osg", function() Snacks.picker.grep({ cwd = "~/orgfiles", prompt = "Org Grep: " }) end,
    { desc = "Grep Org Files" })
vim.keymap.set('n', '<leader>onn', function()
    local title = vim.fn.input('Note Title: ')
    if title == '' then return end

    local filename = os.date('%Y%m%d%H%M') .. '.org'
    local filepath = vim.fn.expand('~/orgfiles/notes/') .. filename

    local content = {
        '#+title: ' .. title,
        '#+filetags: :note:',
        '',
        '* ',
    }

    vim.fn.writefile(content, filepath)
    vim.cmd('edit ' .. filepath)
    vim.cmd('normal! G$') -- Go to end of last line
    vim.cmd('startinsert!')
end, { desc = 'New Zettel note' })
