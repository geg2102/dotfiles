return {
    "danymat/neogen",
    config = function()
        require("neogen").setup {
            enabled = true,
            languages = {
                python = {
                    template = {
                        annotation_convention = "reST"
                    }
                }
            },
            snippet_engine = "luasnip",
        }
    end,
    version = "*"
}
