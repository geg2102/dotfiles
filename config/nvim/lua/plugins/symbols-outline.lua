return {
    {
        "simrat39/symbols-outline.nvim",
        dependencies = { "neovim/nvim-lspconfig"},
        event = "InsertEnter",
        config = function()
            require("symbols-outline").setup()
        end
    }
}
