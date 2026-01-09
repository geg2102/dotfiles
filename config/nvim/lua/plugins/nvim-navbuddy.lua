return {
    {
        "SmiteshP/nvim-navbuddy",
        ft = { "python", "sh", "lua", "scala", "c", "cpp", "yaml", "json", "r" },
        dependencies = { "neovim/nvim-lspconfig", "SmiteshP/nvim-navic", "MunifTanjim/nui.nvim" },
        config = function()
            require("nvim-navbuddy").setup { window = { border = "double" }, lsp = { auto_attach = true } }
        end
    }
}
