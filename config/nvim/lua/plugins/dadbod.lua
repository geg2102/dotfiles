return {
    "tpope/vim-dadbod",
    dependencies = {
        { 'kristijanhusak/vim-dadbod-ui' },
        -- { "ctdunc/vim-dadbod-ui-snowflake",       branch = "snowflake" },
        { "kristijanhusak/vim-dadbod-completion", ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    -- opts = {
    --     db_competion = function()
    --         ---@diagnostic disable-next-line
    --         require("cmp").setup.buffer { sources = { { name = "vim-dadbod-completion" } } }
    --     end,
    -- },
    config = function(_, opts)
        vim.g.db_ui_save_location = vim.fn.stdpath "config" .. require("plenary.path").path.sep .. "db_ui"

        -- vim.api.nvim_create_autocmd("FileType", {
        --     pattern = {
        --         "sql",
        --     },
        --     command = [[setlocal omnifunc=vim_dadbod_completion#omni]],
        -- })
        --
        -- vim.api.nvim_create_autocmd("FileType", {
        --     pattern = {
        --         "sql",
        --         "mysql",
        --         "plsql",
        --     },
        --     callback = function()
        --         vim.schedule(opts.db_completion)
        --     end,
        -- })
    end,
    -- keys = {
    --     { "<leader>du", "<cmd>DBUIToggle<cr>", desc = "Toggle Dadbod UI" },
    -- },
}
