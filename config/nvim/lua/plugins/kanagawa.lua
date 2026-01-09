return {
    {
        "rebelot/kanagawa.nvim",
        config = function()
            vim.opt.laststatus = 3
            vim.opt.fillchars:append({
                horiz = '━',
                horizup = '┻',
                horizdown = '┳',
                vert = '┃',
                vertleft = '┨',
                vertright = '┣',
                verthoriz = '╋',
            })
            require("kanagawa").setup({
                globalStatus = true,
                dimInactive = true
            })
            vim.cmd("colorscheme kanagawa")
        end
    },
}
