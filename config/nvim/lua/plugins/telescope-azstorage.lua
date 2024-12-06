-- ~/.config/nvim/lua/telescope-azstorage.lua
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local sorters = require('telescope.sorters')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local Job = require('plenary.job')

local M = {}

local function list_blobs(container_name)
    Job:new({
        command = 'az',
        args = { 'storage', 'blob', 'list', '--account-name', 'tdrdsblob', '--container-name', container_name, '--output', 'tsv', '--query', '[].{name:name}' },
        on_exit = function(j, return_val)
            vim.schedule(function()
                if return_val == 0 then
                    local blobs = {}
                    for _, v in pairs(j:result()) do
                        table.insert(blobs, v:match("%S+"))
                    end

                    pickers.new({}, {
                        prompt_title = 'Select a blob from the container: ' .. container_name,
                        finder = finders.new_table {
                            results = blobs,
                        },
                        sorter = sorters.get_generic_fuzzy_sorter(),
                        attach_mappings = function(prompt_bufnr, map)
                            actions.select_default:replace(function()
                                actions.close(prompt_bufnr)
                                local selected_blob = action_state.get_selected_entry()[1]
                                local blob_path = container_name .. '/' .. selected_blob
                                vim.fn.setreg('"', blob_path)
                                print("Selected blob path saved to register: " .. blob_path)
                            end)
                            return true
                        end,
                    }):find()
                else
                    print('Failed to list blobs in container: ' .. container_name)
                end
            end)
        end
    }):start()
end

M.search_blobs = function()
    Job:new({
        command = 'az',
        args = { 'storage', 'container', 'list', '--account-name', 'tdrdsblob', '--output', 'tsv', '--query', '[].{name:name}' },
        on_exit = function(j, return_val)
            vim.schedule(function()
                if return_val == 0 then
                    local containers = {}
                    for _, v in pairs(j:result()) do
                        table.insert(containers, v:match("%S+"))
                    end

                    pickers.new({}, {
                        prompt_title = 'Select a container',
                        finder = finders.new_table {
                            results = containers,
                        },
                        sorter = sorters.get_generic_fuzzy_sorter(),
                        attach_mappings = function(prompt_bufnr, map)
                            actions.select_default:replace(function()
                                actions.close(prompt_bufnr)
                                local container_name = action_state.get_selected_entry()[1]
                                list_blobs(container_name)
                            end)
                            return true
                        end,
                    }):find()
                else
                    print('Failed to list containers')
                end
            end)
        end
    }):start()
end

return M
