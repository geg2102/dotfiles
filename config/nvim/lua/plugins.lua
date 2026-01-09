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
        require("plugins.orgmode"),
        require("plugins.nightfox"),
        require("plugins.barbar"),
        require("plugins.focus"),
        require("plugins.gitsigns"),
        require("plugins.lualine"),
        require("plugins.nvim-ufo"),
        require("plugins.tint"),
        require("plugins.markdown"),

        -- lsp
        require("plugins.blink"),
        require("plugins.neodev"),
        require("plugins.lsp"),
        require("plugins.mason"),
        require("plugins.conform"),
        require("plugins.nvim-lint"),
        require("plugins.nvim-luaref"),

        -- treesitter
        require("plugins.treesitter"),
        require("plugins.rainbow-delimiters"),

        -- navigation
        require("plugins.hop"),
        require("plugins.project"),
        require("plugins.vim-tmux-navigator"),
        require("plugins.mini"),

        -- convenience
        require("plugins.codediff"),
        require("plugins.marks"),
        require("plugins.nvim-autopairs"),
        require("plugins.nvim-surround"),
        require("plugins.trouble"),
        require("plugins.suda"),
        require("plugins.vim-repeat"),
        require("plugins.vim-uppercase-sql"),
        require("plugins.wrapping"),

        -- coding
        require("plugins.todo-comments"),
        require("plugins.copilot"),
        require("plugins.dadbod"),
        require("plugins.dbee"),
        require("plugins.neogit"),
        require("plugins.nvim-metals"),
        require("plugins.nvim-python-repl"),
        require("plugins.nvim-jupyter-client"),
        require("plugins.toggleterm"),
        require("plugins.neogen"),
        require("plugins.vimtex"),
        require("plugins.go"),
        require("plugins.nvim-bqf"),
        require("plugins.which-key"),
        require("plugins.rustacean"),
        require("plugins.crates"),
        require("plugins.nvim-dap"),
        require("plugins.nvim-dap-ui"),
        require("plugins.claudecode"),
        require("plugins.snacks"),
        require("plugins.venvselector"),
        { "microsoft/python-type-stubs" },
        { "python/typeshed" }
        --
        -- require("plugins.telescope-azstorage")
    },
    default = {
        lazy = true
    },
    performance = { rtp = { paths = { vim.fn.expand("~/dotfiles/config/nvim") } } }
}

)
