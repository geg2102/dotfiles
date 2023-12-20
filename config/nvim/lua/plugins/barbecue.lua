return {
    {
        "utilyre/barbecue.nvim",
        version = "*",
        branch = "main",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons", -- optional dependency
        },
        config = function()
            require("barbecue").setup()
        end,
    }
}
