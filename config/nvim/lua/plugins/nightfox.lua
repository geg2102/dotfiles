return {
    {
        "EdenEast/nightfox.nvim",
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
            require("nightfox").setup({
                options = {
                    transparent = false,
                    dim_inactive = true,
                    styles = {
                        comments = "italic",
                        keywords = "bold",
                        types = "italic,bold",
                    }
                }
            })
            vim.cmd("colorscheme nightfox")
        end
    },
}