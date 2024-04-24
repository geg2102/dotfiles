local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- use a protected call so we don't error out on first use
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
    print("lazy just installed, please restart neovim")
    return
end

lazy.setup({
    spec = {
        -- ui
        require("plugins.barbar"),
        require("plugins.dressing"),
        require("plugins.focus"),
        require("plugins.gitsigns"),
        require("plugins.indent-blankline"),
        require("plugins.kanagawa"),
        require("plugins.lualine"),
        require("plugins.nvim-ufo"),
        require("plugins.tint"),
        require("plugins.vim-illuminate"),
        require("plugins.vim-smoothie"),
        require("plugins.noice"),

        -- lsp
        require("plugins.cmp"),
        require("plugins.neodev"),
        require("plugins.lsp"),
        require("plugins.mason"),
        require("plugins.none-ls"),
        require("plugins.nvim-luaref"),
        require("plugins.nvim-navbuddy"),
        require("plugins.nvim-navic"),
        require("plugins.symbols-outline"),

        -- treesitter
        require("plugins.treesitter"),
        -- require("plugins.nvim-treesitter-textsubjects"),
        require("plugins.nvim-ts-rainbow2"),

        -- navigation
        require("plugins.hop"),
        require("plugins.project"),
        require("plugins.telescope"),
        require("plugins.vim-tmux-navigator"),
        require("plugins.mini"),

        -- convenience
        require("plugins.accelerated-jk"),
        require("plugins.alpha-nvim"),
        require("plugins.barbecue"),
        require("plugins.diffview"),
        require("plugins.marks"),
        require("plugins.nvim-autopairs"),
        require("plugins.nvim-osc52"),
        require("plugins.nvim-surround"),
        require("plugins.oil"),
        require("plugins.quick-scope"),
        require("plugins.trouble"),
        require("plugins.suda"),
        -- require("plugins.vim-bbye"),
        require("plugins.vim-repeat"),
        require("plugins.vim-uppercase-sql"),
        require("plugins.vim-visual-multi"),
        require("plugins.wrapping"),

        -- coding
        require("plugins.todo-comments"),
        require("plugins.comment"),
        require("plugins.copilot"),
        require("plugins.copilotchat"),
        require("plugins.dadbod"),
        require("plugins.hydra"),
        require("plugins.lazygit"),
        require("plugins.neogit"),
        require("plugins.luasnip"),
        require("plugins.nvim-metals"),
        require("plugins.nvim-python-repl"),
        require("plugins.nvim-r"),
        require("plugins.toggleterm"),
        require("plugins.vim-doge"),
        require("plugins.vimtex"),
        require("plugins.harpoon"),
        --
    },
    default = {
        lazy = true
    },
    performance = { rtp = { paths = { vim.fn.expand("~/dotfiles/config/nvim") } } }
}

)
