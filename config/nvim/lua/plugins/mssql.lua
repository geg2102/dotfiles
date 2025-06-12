return {
    "Kurren123/mssql.nvim",
    opts = {},
    dependencies = { "folke/which-key.nvim" },
    config = function()
        require("mssql").setup({
            max_rows = 50,
            max_column_width = 50,
            connections_file = vim.fn.stdpath("data") ..
                "/mssql.nvim/connections.json"
        })
        require("mssql").set_keymaps("<leader>D")
    end
}
