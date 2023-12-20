return {
    {
        "geg2102/nvim-python-repl",
        -- ft = { "python", "lua", "scala" },
        event = "InsertEnter",
        config = function()
            require("nvim-python-repl").setup({
                vsplit = true,
            })
        end,
        vim.keymap.set("n", "<leader>n", function() require('nvim-python-repl').send_statement_definition() end,
            { desc = "Send semantic unit to REPL" }),
        vim.keymap.set("v", "<leader>n", function() require('nvim-python-repl').send_visual_to_repl() end,
            { desc = "Send visual selection to REPL" }),
        vim.keymap.set("n", "<leader>nr", function() require('nvim-python-repl').send_buffer_to_repl() end,
            { desc = "Send entire buffer to REPL" }),
        vim.keymap.set("n", "<leader>e", function() require('nvim-python-repl').toggle_execute() end,
            { desc = "Automatically execute command in REPL after sent" }),

    }
}
