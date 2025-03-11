return {
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lua",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "tamago324/cmp-zsh",
            "onsails/lspkind.nvim",
            "zbirenbaum/copilot.lua",
            "zbirenbaum/copilot-cmp",
            {
                "MattiasMTS/cmp-dbee",
                dependencies = {
                    { "kndndrj/nvim-dbee" }
                },
                ft = "sql", -- optional but good to have
                opts = {},  -- needed
            },
        },
        ft = "sql",
        -- event = "InsertEnter",
        config = function()
            local cmp = require("cmp")
            local lsp_kind = require("lspkind")
            local cmp_next = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif require("luasnip").expand_or_jumpable() then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
                else
                    fallback()
                end
            end
            local cmp_prev = function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif require("luasnip").jumpable(-1) then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
                else
                    fallback()
                end
            end
            require("copilot_cmp").setup()
            lsp_kind.init()
            cmp.setup({
                confirm_opts = {
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true,
                },
                duplicates_default = 0,
                window = {
                    completion = cmp.config.window.bordered({}),
                    documentation = cmp.config.window.bordered({}),
                    -- hover = cmp.config.window.bordered(),
                },
                snippet = {
                    expand = function(args)
                        -- vim.fn["vsnip#anonymous"](args.body)
                        require("luasnip").lsp_expand(args.body)
                    end
                },
                mapping = {
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
                    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                    -- ["<Tab>"] = cmp.mapping(function(fallback)
                    --     if cmp.visible() then
                    --         cmp.select_next_item()
                    --     elseif require("luasnip").expand_or_locally_jumpable() then
                    --         require("luasnip").expand_or_jump()
                    --     else
                    --         fallback()
                    --     end
                    -- end, { "i", "s" }),
                    -- ["<S-Tab>"] = cmp.mapping(function(fallback)
                    --     if cmp.visible() then
                    --         cmp.select_prev_item()
                    --     elseif require("luasnip").locally_jumpable(-1) then
                    --         require("luasnip").jump(-1)
                    --     else
                    --         fallback()
                    --     end
                    -- end, { "i", "s" }),
                },
                formatting = {
                    format = require("lspkind").cmp_format({
                        maxwidth = 50,
                        ellipsis_char = "...",
                    })
                },
                sources = {
                    -- { name = "nvim_lsp_signature_help", group_index = 1 },
                    { name = "luasnip",               max_item_count = 5,  group_index = 1 },
                    { name = "nvim_lsp",              max_item_count = 25, group_index = 1 },
                    { name = "nvim_lua",              group_index = 1 },
                    { name = "vim-dadbod-completion", group_index = 1 },
                    -- { name = "copilot",                 max_item_count = 5, group_index = 1},
                    { name = "path",                  group_index = 2 },
                    { name = "buffer",                keyword_length = 2,  max_item_count = 5, group_index = 2 },
                    -- { name = "copilot",               max_item_count = 5, group_index = 3 },
                    -- { name = "cmdline",               group_index = 2 },
                    { name = "zsh",                   group_index = 2 },
                    -- { name = "cmp-dbee",              group_index = 2 },
                },
            })
        end
    },
}
