return {
    {
        "nvim-neorg/neorg",
        lazy = false,  -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
        version = "*", -- Pin Neorg to the latest stable release
        config = function()
            require("neorg").setup {
                load = {
                    ["core.defaults"] = {},
                    ["core.concealer"] = {},
                    ["core.export"] = {},
                    ["core.export.markdown"] = {},
                    ["core.keybinds"] = {
                        config = {
                            default_keybinds = true,
                            preset = "neorg",
                            hook = function(keybinds)
                                -- Remap hop-link from <CR> to <LocalLeader>l
                            end,
                        },
                    },
                    ["core.esupports.hop"] = {},
                    ["core.completion"] = {
                        config = {
                            engine = { module_name = "external.lsp-completion" },
                        },
                    },
                    ["core.dirman"] = {
                        config = {
                            workspaces = {
                                notes = "~/notes",
                            },
                            default_workspace = "notes",
                        },
                    },
                    ["external.interim-ls"] = {
                        config = {
                            completion_provider = {
                                enable = true,
                                documentation = true,
                                categories = false,
                            }
                        }
                    },
                },
            }

            vim.wo.foldlevel = 99
            vim.wo.conceallevel = 2
            vim.keymap.set("n", "<leader>l", "<Plug>(neorg.esupports.hop.hop-link)",
                { buffer = true, desc = "Hop to Neorg link" })
            vim.g.maplocalleader = "\\"
        end
    },
    {
        "benlubas/neorg-interim-ls",
        ft = "norg"
    }
}
