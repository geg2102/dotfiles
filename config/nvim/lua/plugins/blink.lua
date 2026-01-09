return {
    {
        "saghen/blink.compat",
        version = "2.*",
        dependencies = { "mattiasmts/cmp-dbee" },
        lazy = true,
        -- opts = {}
        -- opts = { impersonate_nvim_cmp = true, debug = true }


    },

    {
        'saghen/blink.cmp',
        -- optional: provides snippets for the snippet source
        dependencies = { {
            "mattiasmts/cmp-dbee",
            ft = "sql",
            opts = {},
        }
        , 'rafamadriz/friendly-snippets', { 'L3MON4D3/LuaSnip', version = 'v2.*' }, "Kaiser-Yang/blink-cmp-avante" },

        -- use a release tag to download pre-built binaries
        version = '1.*',
        -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        -- build = 'cargo build --release',
        -- If you use nix, you can build from source using latest nightly rust with:
        -- build = 'nix run .#build-plugin',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- 'default' for mappings similar to built-in completion
            -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
            -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
            -- See the full "keymap" documentation for information on defining your own keymap.
            keymap = {
                -- preset      = "default",
                ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
                -- ['<C-e>']     = { 'hide' },
                ["<C-y>"]     = { "select_and_accept" },
                ["<Tab>"]     = { "select_next", "fallback" },
                ["<S-Tab>"]   = { "select_prev", "fallback" },
                ["<C-p>"]     = { "snippet_backward" },
                ["<C-n>"]     = { "snippet_forward" },
                ['<C-b>']     = { 'scroll_documentation_up', 'fallback' },
                ['<C-f>']     = { 'scroll_documentation_down', 'fallback' },
            },
            -- keymap = { preset = 'default' },
            cmdline = {
                sources = function()
                    local type = vim.fn.getcmdtype()
                    -- Search forward and backward
                    if type == "/" or type == "?" then
                        return { "buffer" }
                    end
                    -- Commands
                    if type == ":" then
                        return { "cmdline" }
                    end
                    return {}
                end,

            },
            sources = {
                default = { "avante", "lsp", "path", "snippets", "buffer", "dadbod", "dbee" },
                providers = {
                    dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
                    avante = { name = "Avante", module = "blink-cmp-avante" },
                    dbee = { name = "cmp-dbee", module = "blink.compat.source", },
                    orgmode = {
                        name = 'Orgmode',
                        module = 'orgmode.org.autocompletion.blink',
                        fallbacks = { 'buffer' },
                    },

                },
            },

            appearance = {
                -- Sets the fallback highlight groups to nvim-cmp's highlight groups
                -- Useful for when your theme doesn't support blink.cmp
                -- Will be removed in a future release
                use_nvim_cmp_as_default = true,
                -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = 'mono'
            },

            completion = {
                accept = {
                    auto_brackets = { enabled = true },
                },
                menu = { draw = { treesitter = { "lsp" }, }, border = "single" },
                documentation = { auto_show = true, auto_show_delay_ms = 200, window = { border = "single" } },
                -- ghost_text = { enabled = vim.g.ai_cmp },
                ghost_text = { enabled = false },
                trigger = { show_on_insert_on_trigger_character = false }

            },

            signature = { enabled = false, window = { border = "single" } },
            snippets = {
                preset = "luasnip",
                expand = function(snippet) require('luasnip').lsp_expand(snippet) end,
                active = function(filter)
                    if filter and filter.direction then
                        return require('luasnip').jumpable(filter.direction)
                    end
                    return require('luasnip').in_snippet()
                end,
                jump = function(direction) require('luasnip').jump(direction) end,
            },
        },
        opts_extend = { "sources.default", "sources.providers" }
    }
}
