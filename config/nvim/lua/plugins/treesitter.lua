return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = function()
            pcall(require("nvim-treesitter.install").update { with_sync = true })
        end,
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        -- branch = "main",
        ft = { "python", "sh", "lua", "scala", "c", "cpp", "yaml", "json", "r", "vim", "md", "go", "js", "tsx" },
        config = function()
            local treesitter = require("nvim-treesitter.configs")
            treesitter.setup {
                ensure_installed = { "python", "bash", "lua", "scala", "c", "cpp", "vim", "yaml", "hcl",
                    "terraform", "r", "markdown", "markdown_inline", "vimdoc", "javascript" },
                highlight = {
                    enable = true,
                    disable = function(_, bufnr) -- Disable in large buffers
                        return vim.api.nvim_buf_line_count(bufnr) >= 5000
                    end,
                },
                indent = {
                    enable = false
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<CR>",
                        node_incremental = "<CR>",
                        scope_incremental = "<c-s>",
                        node_decremental = "<c-backspace>"
                    }
                },
                -- rainbow = {
                --     enable = true,
                --     query = 'rainbow-parens',
                --     strategy = require("ts-rainbow").strategy.global,
                -- },
                autopairs = {
                    enable = true
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["aa"] = "@parameter.outer",
                            ["ia"] = "@parameter.inner",
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                        }
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            ["]m"] = "@function.outer",
                            ["]]"] = "@class.outer",
                        },
                        goto_next_end = {
                            ["]M"] = "@function.outer",
                            ["]["] = "@class.outer",

                        },
                        goto_previous_start = {
                            ["[m"] = "@function.outer",
                            ["[["] = "@class.outer",
                        },
                        goto_previous_end = {
                            ["[M"] = "@function.outer",
                            ["[]"] = "@class.outer",
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ["<leader>b"] = "@parameter.inner"
                        },
                        swap_previous = {
                            ["<leader>B"] = "@parameter.inner"
                        }
                    }
                }
            }
        end
    }
}
