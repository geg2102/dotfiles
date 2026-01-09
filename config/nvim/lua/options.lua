vim.cmd("filetype plugin on")
vim.g.mapleader = ","


vim.diagnostic.config({ severity_sort = true })

vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.mouse = ""
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.expandtab = true
-- vim.opt.clipboard = "unnamedplus"
vim.opt.autoindent = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.wrap = true
vim.opt.linebreak = true
--vim.opt.pastetoggle = "<F10>"
vim.opt.undofile = true
vim.opt.scrolloff = 8
vim.opt.swapfile = false
vim.opt.splitbelow = true
vim.opt.foldcolumn = "0"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.opt.completeopt = { "menuone", "noselect", "noinsert" }
vim.opt.showmode = false
vim.g.nvim_system_wide = 1
-- vim.g.indent_blankline_buftype_exclude = { "terminal", "json" }
vim.g.vimtex_view_method = "skim"
vim.g.db_ui_winwidth = 60
vim.g.db_ui_use_nerd_fonts = 1
vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
        ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
        ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
        ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
        ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
    },
}

vim.opt.clipboard:append("unnamedplus")
