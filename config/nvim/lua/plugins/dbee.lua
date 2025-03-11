return {
    {
        "kndndrj/nvim-dbee",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        build = function()
            -- Install tries to automatically detect the install method.
            -- if it fails, try calling it with one of these parameters:
            --    "curl", "wget", "bitsadmin", "go"
            require("dbee").install()
        end,
        -- keys = {
        --     "<leader>db",
        -- },
        config = function()
            require("dbee").setup({
                sources = {
                    -- require("dbee.sources").FileSource:new(vim.fn.stdpath("config") .. "/db_ui/connections.json")
                    require("dbee.sources").EnvSource:new("DBEE_CONNECTIONS")
                }
            })
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {

            "onsails/lspkind.nvim",
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
                    -- ["<C-e>"] = cmp.mapping.abort(),
                    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
                    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                    -- ["<Down>"] = cmp.mapping(function(fallback)
                    --     if cmp.visible() then
                    --         cmp.select_next_item()
                    --     elseif require("luasnip").expand_or_locally_jumpable() then
                    --         require("luasnip").expand_or_jump()
                    --     else
                    --         fallback()
                    --     end
                    -- end, { "i", "s" }),
                    -- ["<Up>"] = cmp.mapping(function(fallback)
                    --     if cmp.visible() then
                    --         cmp.select_prev_item()
                    --     elseif require("luasnip").locally_jumpable(-1) then
                    --         require("luasnip").jump(-1)
                    --     else
                    --         fallback()
                    --     end
                    -- end, { "i", "s" }),
                    ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                        { 'i' }),
                    ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
                        { 'i' }),
                },
                formatting = {
                    format = require("lspkind").cmp_format({
                        maxwidth = 50,
                        ellipsis_char = "...",
                    })
                },
                sources = {
                    -- { name = "nvim_lsp_signature_help", group_index = 1 },
                    -- { name = "luasnip",               max_item_count = 5,  group_index = 1 },
                    -- { name = "nvim_lsp",              max_item_count = 25, group_index = 1 },
                    -- { name = "nvim_lua",              group_index = 1 },
                    -- { name = "vim-dadbod-completion", group_index = 1 },
                    -- -- { name = "copilot",                 max_item_count = 5, group_index = 1},
                    -- { name = "path",                  group_index = 2 },
                    -- { name = "buffer",                keyword_length = 2,  max_item_count = 5, group_index = 2 },
                    -- -- { name = "copilot",               max_item_count = 5, group_index = 3 },
                    -- -- { name = "cmdline",               group_index = 2 },
                    -- { name = "zsh",                   group_index = 2 },
                    { name = "cmp-dbee", group_index = 2 },
                },
            })
        end
    },

}
