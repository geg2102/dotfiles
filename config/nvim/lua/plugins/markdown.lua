return {
    'MeanderingProgrammer/render-markdown.nvim',
    name = 'render-markdown',
    -- commit = "a03ed82dfdeb1a4980093609ffe94c171ace8059",
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ft = { "md" },
    config = function()
        require('render-markdown').setup({})
    end,
}
