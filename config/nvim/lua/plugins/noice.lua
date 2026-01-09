return {
    "folke/noice.nvim",
    event = "InsertEnter",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
    config = function()
        require("noice").setup({
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
                signature = { auto_open = { enabled = true }, enabled = true, },
            },
            presets = {
                bottom_search = true,         --  a classic bottom cmdline for search
                command_palette = true,       -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = false,           -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = true,        -- add a border to hover docs and signature help
            },
            messages = { enabled = false },
            notify = { enabled = false },
            vim.keymap.set({ "n", "i", "s" }, "<c-f>", function()
                if not require("noice.lsp").scroll(4) then
                    return "<c-f>"
                end
            end, { silent = true, expr = true }),
            vim.keymap.set({ "n", "i", "s" }, "<c-b>", function()
                if not require("noice.lsp").scroll(-4) then
                    return "<c-b>"
                end
            end, { silent = true, expr = true })
        })
    end

} --
-- -- return {
-- --     'nvimdev/lspsaga.nvim',
-- --     config = function()
-- --         require('lspsaga').setup({})
-- --     end,
-- --     dependencies = {
-- --         'nvim-treesitter/nvim-treesitter', -- optional
-- --         'nvim-tree/nvim-web-devicons',     -- optional
-- --     }
-- -- }
--
