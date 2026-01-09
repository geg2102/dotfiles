return {
    {
        dir = "~/nvim-jupyter-client",
        -- "geg2102/nvim-jupyter-client",
        config = function()
            require("nvim-jupyter-client").setup({
                -- cell_highlight_group = "Mycustomgroup",
                -- highlights = {
                --     cell_title = {
                --         bg = 'red',    -- white text
                --         fg = 'yellow', -- black background
                --         -- cterm = { bold = true },
                --     }
                -- }
            })
        end,
        -- Add cells
        vim.keymap.set("n", "<leader>ja", "<cmd>JupyterAddCellBelow<CR>", { desc = "Add Jupyter cell below" }),
        vim.keymap.set("n", "<leader>jA", "<cmd>JupyterAddCellAbove<CR>", { desc = "Add Jupyter cell above" }),

        -- Cell operations
        vim.keymap.set("n", "<leader>jd", "<cmd>JupyterRemoveCell<CR>", { desc = "Remove current Jupyter cell" }),
        vim.keymap.set("n", "<leader>jm", "<cmd>JupyterMergeCellAbove<CR>", { desc = "Merge with cell above" }),
        vim.keymap.set("n", "<leader>jM", "<cmd>JupyterMergeCellBelow<CR>", { desc = "Merge with cell below" }),
        vim.keymap.set("n", "<leader>jt", "<cmd>JupyterConvertCellType<CR>",
            { desc = "Convert cell type (code/markdown)" }),
        vim.keymap.set("v", "<leader>jm", "<cmd>JupyterMergeVisual<CR>", { desc = "Merge selected cells" }),
        vim.keymap.set("n", "<leader>jD", "<cmd>JupyterDeleteCell<CR>",
            { desc = "Delete cell under cursor and store in register" }),
    }
}
