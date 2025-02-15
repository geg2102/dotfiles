return {
    {
        "nvimtools/hydra.nvim",
        dependencies = { "anuvyklack/keymap-layer.nvim", "mfussenegger/nvim-dap", "rcarriga/nvim-dap-ui", "nvim-neotest/nvim-nio" },
        -- keys = {
        --     { "<leader>dh", "", { desc = "Dap Hydra" } },
        --     { "<leader>g",  "", { desc = "Git Hydra" } },
        --     { "<leader>ht", "", { desc = "Telescope Hydra" } }
        -- },
        config = function()
            local Hydra = require('hydra')
            local dap = require 'dap'
            require("dapui").setup()
            local hint = [[
 _n_: step over   _s_: Continue/Start   _b_: Breakpoint     _K_: Eval
 _i_: step into   _x_: Quit             _r_: Repl           _U_: UI
 _o_: step out    _X_: Stop             ^ ^
 _c_: to cursor   _C_: Close UI
 ^
 ^ ^              _q_: exit
]]

            local dap_hydra = Hydra({
                hint = hint,
                config = {
                    color = 'pink',
                    invoke_on_body = true,
                    hint = {
                        position = 'bottom',
                    },
                },
                name = 'dap',
                mode = { 'n', 'x' },
                body = '<leader>dh',
                heads = {
                    { 'n', dap.step_over,     { silent = true } },
                    { 'i', dap.step_into,     { silent = true } },
                    { 'o', dap.step_out,      { silent = true } },
                    { 'c', dap.run_to_cursor, { silent = true } },
                    { 's', dap.continue,      { silent = true } },
                    { 'r', dap.repl.open,     { silent = true } },
                    { 'x', ":lua require'dap'.disconnect({ terminateDebuggee = false })<CR>", {
                        exit = true,
                        silent = true
                    } },
                    { 'X', dap.close,                                                          { silent = true } },
                    { 'U', ":lua require('dapui').open()<cr>",                                 { silent = true } },
                    { 'C', ":lua require('dapui').close()<cr>:DapVirtualTextForceRefresh<CR>", { silent = true } },
                    { 'b', dap.toggle_breakpoint,                                              { silent = true } },
                    { 'K', ":lua require('dap.ui.widgets').hover()<CR>",                       { silent = true } },
                    { 'q', nil, {
                        exit = true,
                        nowait = true
                    } },
                }
            })
            Hydra.spawn = function(head)
                if head == "dap-hydra" then
                    dap_hydra:activate()
                end
            end

            local gitsigns = require('gitsigns')
            hint = [[
 _J_: next hunk   _s_: stage hunk        _d_: show deleted   _b_: blame line
 _K_: prev hunk   _u_: undo last stage   _p_: preview hunk   _B_: blame show full
 ^ ^              _S_: stage buffer      ^ ^                 _/_: show base file
 ^
 ^ ^              _<Enter>_: Lazygit              _q_: exit
]]
            Hydra({
                name = 'Git',
                hint = hint,
                config = {
                    buffer = bufnr,
                    color = 'pink',
                    invoke_on_body = true,
                    hint = {
                    },
                    on_enter = function()
                        vim.cmd 'mkview'
                        vim.cmd 'silent! %foldopen!'
                        vim.bo.modifiable = false
                        gitsigns.toggle_signs(true)
                        gitsigns.toggle_linehl(true)
                    end,
                    on_exit = function()
                        local cursor_pos = vim.api.nvim_win_get_cursor(0)
                        vim.cmd 'loadview'
                        vim.api.nvim_win_set_cursor(0, cursor_pos)
                        vim.cmd 'normal zv'
                        gitsigns.toggle_signs(false)
                        gitsigns.toggle_linehl(false)
                        gitsigns.toggle_deleted(false)
                    end,
                },
                mode = { 'n', 'x' },
                body = '<leader>g',
                heads = {
                    { 'J',
                        function()
                            if vim.wo.diff then return ']c' end
                            vim.schedule(function() gitsigns.next_hunk() end)
                            return '<Ignore>'
                        end,
                        { expr = true, desc = 'next hunk' } },
                    { 'K',
                        function()
                            if vim.wo.diff then return '[c' end
                            vim.schedule(function() gitsigns.prev_hunk() end)
                            return '<Ignore>'
                        end,
                        { expr = true, desc = 'prev hunk' } },
                    { 's', ':Gitsigns stage_hunk<CR>', { silent = true, desc = 'stage hunk' } },
                    { 'u', gitsigns.undo_stage_hunk,   { desc = 'undo last stage' } },
                    { 'S', gitsigns.stage_buffer,      { desc = 'stage buffer' } },
                    { 'p', gitsigns.preview_hunk,      { desc = 'preview hunk' } },
                    { 'd', gitsigns.toggle_deleted, {
                        nowait = true,
                        desc = 'toggle deleted'
                    } },
                    { 'b', gitsigns.blame_line,                                { desc = 'blame' } },
                    { 'B', function() gitsigns.blame_line { full = true } end, { desc = 'blame show full' } },
                    { '/', gitsigns.show, {
                        exit = true,
                        desc = 'show base file'
                    } }, -- show the base of the file
                    { '<Enter>', '<Cmd>LazyGit<CR>', { exit = true, desc = 'Neogit' } },
                    { 'q', nil, {
                        exit = true,
                        nowait = true,
                        desc = 'exit'
                    } },
                }
            })

            local cmd = require('hydra.keymap-util').cmd

            hint = [[
                 _f_: files       _m_: marks
   🭇🬭🬭🬭🬭🬭🬭🬭🬭🬼    _o_: old files   _g_: live grep
  🭉🭁🭠🭘    🭣🭕🭌🬾   _p_: projects    _/_: search in file
  🭅█ ▁     █🭐
  ██🬿      🭊██   _r_: resume      _u_: undotree
 🭋█🬝🮄🮄🮄🮄🮄🮄🮄🮄🬆█🭀  _h_: vim help    _c_: execute command
 🭤🭒🬺🬹🬱🬭🬭🬭🬭🬵🬹🬹🭝🭙  _k_: keymaps     _;_: commands history
                 _O_: options     _?_: search history
 ^
                 _<Enter>_: Telescope           _<Esc>_
]]

            Hydra({
                name = 'Telescope',
                hint = hint,
                config = {
                    color = 'teal',
                    invoke_on_body = true,
                    hint = {
                        position = 'middle',
                    },
                },
                mode = 'n',
                body = '<leader>ht',
                heads = {
                    { 'f',       cmd 'Telescope find_files' },
                    { 'g',       cmd 'Telescope live_grep' },
                    { 'o',       cmd 'Telescope oldfiles',                  { desc = 'recently opened files' } },
                    { 'h',       cmd 'Telescope help_tags',                 { desc = 'vim help' } },
                    { 'm',       cmd 'MarksListBuf',                        { desc = 'marks' } },
                    { 'k',       cmd 'Telescope keymaps' },
                    { 'O',       cmd 'Telescope vim_options' },
                    { 'r',       cmd 'Telescope resume' },
                    { 'p',       cmd 'Telescope projects',                  { desc = 'projects' } },
                    { '/',       cmd 'Telescope current_buffer_fuzzy_find', { desc = 'search in file' } },
                    { '?',       cmd 'Telescope search_history',            { desc = 'search history' } },
                    { ';',       cmd 'Telescope command_history',           { desc = 'command-line history' } },
                    { 'c',       cmd 'Telescope commands',                  { desc = 'execute command' } },
                    { 'u',       cmd 'silent! %foldopen! | UndotreeToggle', { desc = 'undotree' } },
                    { '<Enter>', cmd 'Telescope',                           { exit = true, desc = 'list all pickers' } },
                    { '<Esc>',   nil,                                       { exit = true, nowait = true } },
                }
            })
        end
    }
}
