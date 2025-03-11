return {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = "false",
    opts = {
        provider = "claude",
        claude = {
            endpoint = "https://api.anthropic.com",
            model = "claude-3-7-sonnet-20250219",
            timeout = 30000, -- Timeout in milliseconds
            temperature = 0,
            max_tokens = 8000,
            disable_tools = true
        },
        behaviour = {
            enable_project_context_for_as = true,
        },
        file_selector = { provider = "telescope" }
    },
    -- commit = "284998a994c30535ecc43d4dcb859736309c7862",
    -- branch = "feat/repo-map",
    version = false,
    -- build = "make BUILD_FROM_SOURCE=true",
    build = "make",
    dependencies = {
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        "zbirenbaum/copilot.lua",      -- for providers='copilot'
        {
            -- support for image pasting
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            opts = {
                -- recommended settings
                default = {
                    embed_image_as_base64 = false,
                    prompt_for_file_name = false,
                    drag_and_drop = {
                        insert_mode = true,
                    },
                    -- required for Windows users
                    use_absolute_path = true,
                },
            },
        },
        {
            -- Make sure to setup it properly if you have lazy=true
            'MeanderingProgrammer/render-markdown.nvim',
            opts = {
                file_types = { "markdown", "Avante" },
            },
            ft = { "markdown", "Avante" },
        },
    },

}
