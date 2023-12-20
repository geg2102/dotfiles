return {
    {
        "kevinhwang91/nvim-ufo",
        dependencies = "kevinhwang91/promise-async",
        config = function()
            require("ufo").setup({
                provider_selector = function(_, _, _)
                    return ''
                end,
            })
        end

    }
}
