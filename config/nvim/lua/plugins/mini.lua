return {
    {
        'echasnovski/mini.nvim',
        version = '*',
        config = function()
            require("mini.files").setup()
            vim.keymap.set("n", "<leader>m", function() require("mini.files").open() end,
                { silent = true, desc = "Minifiles" })
        end,
    }
}
