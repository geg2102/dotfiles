return {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    event = "InsertEnter",
    config = function()
        local luasnip = require("luasnip")
        luasnip.config.set_config({
            history = true,
            updateevents = "TextChanged,TextChangedI",
            enable_autosnippets = true,
        })
        -- add vscode exported completions
        require("luasnip.loaders.from_vscode").lazy_load()

        vim.keymap.set({ "i", "s" }, "<c-n>", function()
            if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            end
        end, { desc = "Expand current snippet or jump to next", silent = true })

        vim.keymap.set({ "i", "s" }, "<c-p>", function()
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            end
        end, { desc = "Go to previous snippet", silent = true })

        vim.keymap.set("i", "<c-l>", function()
            if luasnip.choice_active() then
                luasnip.change_choice(1)
            end
        end, { desc = "Show list of options for snippets" })
    end,
}
