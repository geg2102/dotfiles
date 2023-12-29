return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "williamboman/mason-lspconfig",
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
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local on_attach = function(client, bufnr)
                if client.server_capabilities.documentSymbolProvider then
                    require("nvim-navic").attach(client, bufnr)
                end
            end
            local servers = {
                jedi_language_server = {},
                lua_ls = require("plugins.lsp.servers.luals")(on_attach),
                ruff_lsp = {},
                texlab = {}
            }
            local server_names = {}
            for server_name, _ in pairs(servers) do
                table.insert(server_names, server_name)
            end
            require("mason-lspconfig").setup({
                ensure_installed = server_names,
                automatic_installation = true
            })
            local nvim_lsp = require("lspconfig")
            for _, server in ipairs(server_names) do
                nvim_lsp[server].setup {
                    capabilities = capabilities,
                    on_attach = on_attach,
                    flags = {
                        debounce_text_changes = 200,
                        allow_incremental_sync = true
                    }
                }
            end
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Goto definition" })
            vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { desc = "Goto implementation" })
            vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { desc = "Rename" })
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
            vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, { desc = "Signature Help" })
            vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })
            vim.keymap.set("n", "gx", vim.lsp.buf.code_action, { desc = "Code action" })
            vim.keymap.set("v", "gx", vim.lsp.buf.code_action, { desc = "Code action" })
            vim.keymap.set("n", "go", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
            vim.keymap.set("n", "gj", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
            vim.keymap.set("n", "gk", vim.diagnostic.goto_prev, { desc = "Go to prev diagnostic" })
        end
    }
}
