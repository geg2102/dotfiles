return {
    {
        "ojroques/nvim-osc52",
        config = function()
            require("osc52").setup({ tmux_passthrough = true })
            -- vim.keymap.set('n', '<leader>c', require('osc52').copy_operator, { expr = true })
            -- vim.keymap.set('n', '<leader>cc', '<leader>c_', { remap = true })
            -- vim.keymap.set('x', '<leader>c', require('osc52').copy_visual)
            local function copy(lines, _)
                require('osc52').copy(table.concat(lines, '\n'))
            end

            local function paste()
                return { vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('') }
            end

            vim.g.clipboard = {
                name = 'osc52',
                copy = { ['+'] = copy, ['*'] = copy },
                paste = { ['+'] = paste, ['*'] = paste },
            }

            -- Now the '+' register will copy to system clipboard using OSC52
            vim.keymap.set("n", '<leader>c', '"+y')
            vim.keymap.set("x", "<leader>c", '"+y')
        end,

    }
}
