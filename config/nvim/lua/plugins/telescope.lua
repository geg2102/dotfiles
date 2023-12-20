return {
    {
        "nvim-telescope/telescope.nvim",
        -- commit = "4226740",
        dependencies = { "nvim-lua/plenary.nvim", "nvim-lua/popup.nvim" },
        lazy = true,
        config = function()
            require("telescope").setup({
                extensions = {
                    file_browser = {
                        hijack_netrw = true,
                    }
                }
            })
        end,
        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<CR>",                desc = "Fuzzy find files" },
            { "<leader>fg", "<cmd>Telescope live_grep<CR>",                 desc = "Live grep" },
            { "<leader>fb", "<cmd>Telescope file_browser<CR>",              desc = "File browser" },
            { "<leader>fh", "<cmd>Telescope oldfiles<CR>",                  desc = "Old files" },
            { "<leader>fv", "<cmd>Telescope help_tags<CR>",                 desc = "Help tags" },
            { "<leader>fk", "<cmd>Telescope keymaps<CR>",                   desc = "Keymaps" },
            { "<leader>fc", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Current buffer fuzzy find" },
            { "<leader>ld", "<cmd>Telescope diagnostics<CR>",               desc = "List diagnostics" },
            { "<leader>lb", "<cmd>Telescope buffers<CR>",                   desc = "List buffers" },
            { '""',         "<cmd>Telescope registers<CR>",                 desc = "Search registers" },
            { "gr",         "<cmd>Telescope lsp_references<CR>",            desc = "Lsp references" },
        }
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
        lazy = true,
        config = function()
            require("telescope").load_extension("file_browser")
        end
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        lazy = true,
        config = function()
            require("telescope").load_extension("fzf")
        end
    }
}
