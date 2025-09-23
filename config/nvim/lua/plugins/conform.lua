return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            "<leader>lf",
            function()
                require("conform").format({ async = true })
            end,
            mode = "",
            desc = "Format buffer",
        },
    },
    -- This will provide type hinting with LuaLS
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
        -- Define your formatters
        formatters_by_ft = {
            lua = { "stylua" },
            python = {
                -- "black",
                -- To fix auto-fixable lint errors.
                "ruff_fix",
                -- To run the Ruff formatter.
                "ruff_format",
                -- To organize the imports.
                "ruff_organize_imports",

            },
            javascript = { "prettierd", "prettier", stop_after_first = true },
            typescript = { "prettierd", "prettier", stop_after_first = true },
            rust = { "rustfmt", lsp_format = "fallback" },
            go = { "gofumpt", "goimports" },
        },
        -- Set default options
        default_format_opts = {
            lsp_format = "fallback",
        },
        -- Set up format-on-save
        format_on_save = { timeout_ms = 1000 },
        -- Customize formatters
        formatters = {
            shfmt = {
                prepend_args = { "-i", "2" },
            },
            black = {
                prepend_args = { "--enable-unstable-feature", "string_processing", "--preview" }
            }
        },
    },
    init = function()
        -- If you want the formatexpr, here is the place to set it
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
}
