require("options")
require("autocommands")
require("keymaps")
-- require("plugins.telescope-azstorage")
if vim.g.noplugins == nil then
    require("plugins")
else
    local colors = vim.fn.stdpath("data") .. "/lazy/kanagawa.nvim/colors/kanagawa.vim"
    if vim.fn.filereadable(colors) then
        local kanagawa_dir = vim.fn.stdpath("data") .. "/lazy/kanagawa.nvim/lua"
        local kanagawa_module_path = kanagawa_dir .. "/?.lua;" .. kanagawa_dir .. "/?/init.lua;"
        package.path = kanagawa_module_path .. package.path
        require("kanagawa").load()
    end
end
