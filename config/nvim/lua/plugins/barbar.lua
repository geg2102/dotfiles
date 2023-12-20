return {
    {
        "romgrk/barbar.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "VeryLazy",
        -- init = function() vim.g.barbar_auto_setup = false end,
        config = function()
            vim.keymap.set("n", "<C-p>", "<cmd>BufferPick<CR>")
            vim.keymap.set("n", "<leader>,", "<cmd>BufferPrevious<CR>")
            vim.keymap.set("n", "<leader>.", "<cmd>BufferNext<CR>")
            vim.keymap.set("n", "<leader>q", "<cmd>BufferClose!<CR>")
        end
    }
}
