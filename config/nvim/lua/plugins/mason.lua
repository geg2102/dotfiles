return {
    {
        "williamboman/mason.nvim",
        build = { ":MasonUpdate", ":MasonInstall debugpy" },
        lazy = true,
        cmd = { "Mason" },
        config = function()
            require("mason").setup()
            end
    }
}
