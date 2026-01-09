return {
    {
        "kkoomen/vim-doge",
        event = "InsertEnter",
        build = function()
            vim.fn["doge#install"]()
        end
    }
}
