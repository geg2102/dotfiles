return {
    {
        "ojroques/nvim-osc52",
        config = function()
            require("osc52").setup({tmux_passthrought = true})
            vim.keymap.set('n', '<leader>c', require('osc52').copy_operator, { expr = true })
            vim.keymap.set('n', '<leader>cc', '<leader>c_', { remap = true })
            vim.keymap.set('x', '<leader>c', require('osc52').copy_visual)
        end,
    }
}
