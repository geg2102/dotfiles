return { {
    "catppuccin/nvim",
    name = "catppuccin",
    -- ft = { "javascript", "javascriptreact", "typescript", "typescriptreact", "rust" },
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            integrations = {
                barbar = true,
                hop = true,

            }
        })
    end
} }
