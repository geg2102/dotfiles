return {
    "greggh/claude-code.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim", -- Required for git operations
    },
    config = function()
        require("claude-code").setup({
            window = {
                position = "float"
            },
            command = "SHELL=/usr/bin/zsh /home/geoff/.claude/local/claude",
            keymaps = {
                toggle = {
                    normal = "<C-s>",
                    terminal = "<C-s>",
                    window_navigation = true,
                    scrolling = true
                }
            }
        }
        )
    end
}
