return {
    {
        "SmiteshP/nvim-navic",
        ft = { "python", "sh", "lua", "scala", "c", "cpp", "yaml", "json", "r", "markdown", "markdown_inline" },
        -- dependencies = "neovim/nvim-lspconfig",
        config = function()
            require("nvim-navic").setup({})
        end
    }
}
