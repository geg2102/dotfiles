return {
    {
        "nvimtools/none-ls.nvim",
        dependencies = { "nvim-lua/plenary.nvim", },
        config = function()
            local os = require("os")
            function os.capture(cmd, raw)
                local f = assert(io.popen(cmd, 'r'))
                local s = assert(f:read('*a'))
                f:close()
                if raw then return s end
                s = string.gsub(s, '^%s+', '')
                s = string.gsub(s, '%s+$', '')
                s = string.gsub(s, '[\n\r]+', ' ')
                return s
            end

            require("null-ls").setup({
                debug = true,
                sources = {
                    -- require("null-ls").builtins.formatting.black.with({
                    --     extra_args = { "--preview", "--line-length=88" }
                    -- }),
                    -- require("null-ls").builtins.diagnostics.mypy.with({
                    --     extra_args = function()
                    --         local virtual = os.capture("which python", false)
                    --         return { "--python-executable", virtual, "--install-types", "--non-interactive",
                    --             "--ignore-missing-imports" }
                    --     end,
                    -- }), --extra_args = "--ignore-missing-imports" }),
                    -- -- require("null-ls").builtins.diagnostics.ruff.with({}),
                    -- require("null-ls").builtins.formatting.isort.with({}),
                    require("null-ls").builtins.formatting.prettier.with({
                        filetypes = { "html", "json", "yaml", "graphql", "md", "txt", "css", "jsx", "tsx", "js", "ts" }
                    }),
                    -- require("null-ls").builtins.formatting.fixjson.with({}),
                    require("null-ls").builtins.diagnostics.sqlfluff.with({
                        extra_args = { "--dialect", "tsql" }, -- change to your dialect
                    }),
                }
            })
        end
    }
}
