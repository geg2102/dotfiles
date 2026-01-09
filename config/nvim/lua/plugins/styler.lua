return {
    {
        "folke/styler.nvim",
        config = function()
            require("styler").setup({
                themes = {
                    javascript = { colorscheme = "catppuccin-latte" },
                    typescript = { colorscheme = "catppuccin-latte" },
                    html = { colorscheme = "catppuccin-latte" },
                    css = { colorscheme = "catppuccin-latte" },
                    javascriptreact = { colorscheme = "catppuccin-latte" },
                    typescriptreact = { colorscheme = "catppuccin-latte" },
                    rust = { colorscheme = "catppuccin-latte" },
                }
            }
            )
        end
    }
}
