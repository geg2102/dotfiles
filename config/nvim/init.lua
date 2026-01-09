require("options")
require("autocommands")
require("keymaps")

if vim.g.noplugins == nil then
    require("plugins")
else
    local kanagawa_path = vim.fn.stdpath("data") .. "/lazy/kanagawa.nvim"
    local colors_file = kanagawa_path .. "/colors/kanagawa.vim"
    if vim.fn.filereadable(colors_file) == 1 then
        local kanagawa_lua = kanagawa_path .. "/lua"
        package.path = kanagawa_lua .. "/?.lua;" .. kanagawa_lua .. "/?/init.lua;" .. package.path
        require("kanagawa").load()
    end
end
