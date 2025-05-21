return {
    {
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async" },
        -- commit = "5a76766",           -- (optional pin)
        config = function()
            -- initialize the plugin
            require("ufo").setup({
                provider_selector = function(bufnr, filetype, buftype)
                    return { "treesitter", "indent" }
                end,
            })

            -- now that `ufo` is loaded, we can safely map its commands
            vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
            vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
        end,

        -- you can also lazy-load on the keys themselves:
        -- keys = { "zR", "zM" },
    }
}
