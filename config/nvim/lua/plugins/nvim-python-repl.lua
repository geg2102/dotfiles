return {
    {
        dir = "~/nvim-python-repl",
        -- "geg2102/nvim-python-repl",
        -- event = "InsertEnter", -- You might want to adjust this event for better plugin loading timing
        ft = { "python" },
        config = function()
            -- Setup the REPL plugin
            require("nvim-python-repl").setup({ split_dir = "left", vsplit = true, spawn_command = { python = "ipython" } })

            -- Define key mappings
            vim.api.nvim_set_keymap("n", "<leader>n",
                "<cmd>lua require('nvim-python-repl').send_statement_definition()<CR>",
                { noremap = true, silent = true, desc = "Send semantic unit to REPL" })
            vim.api.nvim_set_keymap("v", "<leader>n", "<cmd>lua require('nvim-python-repl').send_visual_to_repl()<CR>",
                { noremap = true, silent = true, desc = "Send visual selection to REPL" })
            -- vim.api.nvim_set_keymap("n", "<leader>N", "<cmd>lua require('nvim-python-repl').send_current_cell_to_repl()<CR>",
            --     { noremap = true, silent = true, desc = "Send visual selection to REPL" }),
            vim.api.nvim_set_keymap("n", "<leader>N", "<cmd>lua require('nvim-python-repl').send_buffer_to_repl()<CR>",
                { noremap = true, silent = true, desc = "Send entire buffer to REPL" })
            vim.api.nvim_set_keymap("n", "<leader>e", "<cmd>lua require('nvim-python-repl').toggle_execute()<CR>",
                { noremap = true, silent = true, desc = "Automatically execute command in REPL after sent" })
            vim.api.nvim_set_keymap("n", "<leader>jn",
                "<cmd>lua require('nvim-python-repl').send_current_cell_to_repl()<CR>",
                { noremap = true, silent = true, desc = "Send cell to REPL" })
        end,
        branch = "main",
    }
}
