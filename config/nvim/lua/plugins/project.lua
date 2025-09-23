return {
    {
        "DrKJeff16/project.nvim",
        dependencies = { "ibhagwan/fzf-lua" },
        config = function()
            require("project").setup(
                {
                    fzf_lua = { enabled = false }
                }
            )
            -- -- Guard project.nvim path utils to avoid nil scans
            -- do
            --     local Path = require('project.utils.path')
            --     local uv = vim.uv or vim.loop
            --
            --     -- wrap get_files
            --     local _get_files = Path.get_files
            --     Path.get_files = function(file_dir)
            --         if type(file_dir) ~= 'string' or file_dir == '' then
            --             return
            --         end
            --         -- also ensure the dir actually exists
            --         local st = uv.fs_stat(file_dir)
            --         if not st or st.type ~= 'directory' then
            --             return
            --         end
            --         return _get_files(file_dir)
            --     end
            --
            --     -- wrap match so nil/empty dirs short-circuit
            --     local _match = Path.match
            --     Path.match = function(dir, pattern)
            --         if type(dir) ~= 'string' or dir == '' then
            --             return false
            --         end
            --         return _match(dir, pattern)
            --     end
            --
            --     -- wrap get_parent to be defensive
            --     local _get_parent = Path.get_parent
            --     Path.get_parent = function(path_str)
            --         if type(path_str) ~= 'string' or path_str == '' then
            --             return '/'
            --         end
            --         local ok, parent = pcall(_get_parent, path_str)
            --         if not ok or not parent or parent == '' then
            --             return '/'
            --         end
            --         return parent
            --     end
            --
            --     -- wrap root_included to bail early on bad input
            --     local _root_included = Path.root_included
            --     Path.root_included = function(dir)
            --         if type(dir) ~= 'string' or dir == '' then
            --             return nil
            --         end
            --         return _root_included(dir)
            --     end
            -- end
        end
    }
}
