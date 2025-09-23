return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                -- "williamboman/mason-lspconfig",
                "williamboman/mason.nvim",
                "SmiteshP/nvim-navbuddy",
                dependencies = {
                    "SmiteshP/nvim-navic",
                    "MunifTanjim/nui.nvim"
                },
                opts = { lsp = { auto_attach = true } }
            }
        },
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local capabilities = require("blink.cmp").get_lsp_capabilities()
            capabilities.offsetEncoding = { "utf-16" }
            local on_attach = function(client, bufnr)
                -- if client.server_capabilities.documentSymbolProvider then
                --     require("nvim-navic").attach(client, bufnr)
                -- end
                -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(require("noice.lsp.hover").on_hover,
                --     { border = "rounded" })
            end
            local servers = {
                -- jedi_language_server = {},
                lua_ls = require("plugins.lsp.servers.luals")(on_attach),
                texlab = {},
                gopls = {},
                clangd = require("plugins.lsp.servers.clangd")(on_attach),
                ruff = {},
                -- tsserver = {},
                -- basedpyright = {}
            }
            local server_names = {}
            for server_name, _ in pairs(servers) do
                if server_name == "ts_ls" then
                    server_name = "tsserver"
                end
                table.insert(server_names, server_name)
            end
            -- require("mason-lspconfig").setup({
            --     ensure_installed = server_names,
            --     automatic_installation = true
            -- })

            for _, server in ipairs(server_names) do
                vim.lsp.config(server, {
                    capabilities = capabilities,
                    -- on_attach = on_attach,
                    flags = {
                        debounce_text_changes = 200,
                        allow_incremental_sync = true
                    }
                })
                vim.lsp.enable(server)
            end
            vim.lsp.config('ts_ls', {
                capabilities = capabilities,
                on_attach = on_attach,
                flags = {
                    debounce_text_changes = 200,
                    allow_incremental_sync = true
                }
            })
            vim.lsp.enable('ts_ls')

            vim.lsp.config('basedpyright', {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    basedpyright = {
                        analysis = {
                            autoSearchPaths = true,
                            diagnosticMode = "openFilesOnly",
                            useLibraryCodeForTypes = true,
                            stubPath = vim.fn.stdpath "data" .. "/lazy/python-type-stubs",
                            disableTaggedHints = true,
                            disableOrganizeImports = true, --using ruff
                            reportUnkownVariableType = false,
                            typeCheckingMode = "standard", -- using mypy
                            diagnosticSeverityOverrides = {
                                reportUndefinedVariable = "none",
                            },
                            extraPaths = (function()
                                local root_dir = vim.fn.getcwd()
                                local extra_paths = {}
                                table.insert(extra_paths, vim.fn.stdpath "data" .. "/lazy/typeshed")
                                for _, dir in ipairs(vim.fn.glob(root_dir .. "/*", 0, 1)) do
                                    if vim.fn.isdirectory(dir) == 1 then
                                        table.insert(extra_paths, dir)
                                    end
                                end
                                return extra_paths
                            end)(),
                        },
                    }
                },
            })
            vim.lsp.enable("basedpyright")
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Goto definition" })
            vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { desc = "Goto implementation" })
            vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { desc = "Rename" })
            vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, { desc = "Hover" })
            vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, { desc = "Signature Help" })
            vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })
            vim.keymap.set("n", "gx", vim.lsp.buf.code_action, { desc = "Code action" })
            vim.keymap.set("v", "gx", vim.lsp.buf.code_action, { desc = "Code action" })
            vim.keymap.set("n", "go", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
            vim.keymap.set("n", "gl", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
            vim.keymap.set("n", "gh", vim.diagnostic.goto_prev, { desc = "Go to prev diagnostic" })
        end
    }
}
