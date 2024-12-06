return {
    {
        "zbirenbaum/copilot.lua",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = {
                    enabled = true,
                    -- enabled = false,
                    auto_trigger = true,
                    keymap = {
                        accept = "<C-e>",
                        next = "<C-]"
                    }
                },
                panel = { enabled = false },
                server_opts_overrides = {
                    capabilities = {
                        offsetEncoding = { "utf-16" }
                    },
                }
            })
        end
    }
}
