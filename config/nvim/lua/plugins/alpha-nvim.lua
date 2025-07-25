return {
    {
        "goolord/alpha-nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "VimEnter",
        config = function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")
            dashboard.section.buttons.val = {
                dashboard.button("e", "   New file", ":ene <BAR> startinsert <CR>"),
                dashboard.button("f", "󰈞   Find file", ":Telescope find_files <CR>"),
                dashboard.button("r", "   Recent", ":Telescope oldfiles<CR>"),
                dashboard.button("d", "󰈞   Open Database", ":Dbee<CR>"),
                dashboard.button("q", "󰩈   Quit NVIM", ":qa<CR>"),
            }
            alpha.setup(dashboard.opts)
            -- require("alpha").setup(require("alpha.themes.startify").config)
        end
    }
}
