return {
    "azorng/goose.nvim",
    -- Only load when explicitly commanded to
    cmd = { "Goose" },
    keys = {
        -- You can define keymaps here that would load the plugin when used
        { "<leader>ga", "<cmd>Goose<cr>", desc = "Open Goose AI" },
    },
    config = function()
        require("goose").setup({
            -- You can add configuration options here if needed
            -- See plugin documentation for available options
        })
    end,
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "MeanderingProgrammer/render-markdown.nvim",
            opts = {
                anti_conceal = { enabled = false },
            },
        }
    },
}
