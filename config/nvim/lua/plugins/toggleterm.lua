return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        keys = {
            { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Terminal" }
        },
        config = function()
            require("toggleterm").setup({
                open_mapping = [[<leader>tt]],
                direction = "float",
                size = function(term)
                    if term.direction == "horizontal" then
                        return 15
                    elseif term.direction == "vertical" then
                        return vim.o.columns * .4
                    end
                end,
                float_opts = {
                    border = "double"
                },
                persist_size = false,
                shell = "zsh"
            })
        end
    }
}
