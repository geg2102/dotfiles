return {
    {
        "phaazon/hop.nvim",
        keys = { { "<leader>w", "<cmd>HopWord<CR>", desc = "Hop word" } },
        config = function()
            require("hop").setup {
                create_al_autocmd = true
            }
        end
    }
}
