return {
    {
        "hoob3rt/lualine.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        event = "VeryLazy",
        init = function()
            -- disable until lualine loads
            vim.opt.laststatus = 0
        end,
        config = function()
            local icons = {
                diagnostics = {
                    Error = " ",
                    Warn = " ",
                    Hint = " ",
                    Info = " ",
                },
                git = {
                    added = " ",
                    modified = " ",
                    removed = " ",
                }
            }

            local function fg(name)
                return function()
                    ---@type {foreground?:number}?
                    local hl = vim.api.nvim_get_hl_by_name(name, true)
                    return hl and hl.foreground and { fg = string.format("#%06x", hl.foreground) }
                end
            end

            require("lualine").setup {
                -- options = {
                --     -- theme = "kanagawa",
                --     globalstatus = true,
                -- },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch" },
                    lualine_c = {
                        {
                            "diagnostics",
                            symbols = {
                                error = icons.diagnostics.Error,
                                warn = icons.diagnostics.Warn,
                                info = icons.diagnostics.Info,
                                hint = icons.diagnostics.Hint,
                            },
                        },
                        {
                            "filetype",
                            icon_only = true,
                            separator = "",
                            padding = {
                                left = 1, right = 0 }
                        },
                        { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
                        -- stylua: ignore
                        -- {
                        --     function() return require("nvim-navic").get_location() end,
                        --     cond = function()
                        --         return package.loaded["nvim-navic"] and
                        --             require("nvim-navic").is_available()
                        --     end,
                        -- },
                    },
                    lualine_x = {
                        -- stylua: ignore
                        {
                            function() return require("noice").api.status.command.get() end,
                            cond = function()
                                return package.loaded["noice"] and
                                    require("noice").api.status.command.has()
                            end,
                            color = fg("Statement")
                        },
                        -- stylua: ignore
                        {
                            function() return require("noice").api.status.mode.get() end,
                            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
                            color = fg("Constant"),
                        },
                        {
                            "diff",
                            symbols = {
                                added = icons.git.added,
                                modified = icons.git.modified,
                                removed = icons.git.removed,
                            },
                        },
                    },
                }

            }
        end
    }
}
