-- Just easier to wrap vim-plug commands in vim.cmd
-- In future, switch to packer
vim.cmd([[
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
]])

vim.cmd([[
call plug#begin()
"---------------------===Code navigation===---------------------"
Plug 'rhysd/accelerated-jk'				    " Faster j/k when holding
Plug 'phaazon/hop.nvim'			            " For jumping to particular places
Plug 'psliwka/vim-smoothie'				    " For smooth scrolling
Plug 'unblevable/quick-scope'               " For highlighting f spots
Plug 'christoomey/vim-tmux-navigator'       " For navigating between tmux panes and vim splits
"---------------------===Project navigation===---------------------"
Plug 'nvim-telescope/telescope.nvim'		" For looking through files
Plug 'nvim-lua/popup.nvim'				    " Dependency for telescope
Plug 'nvim-lua/plenary.nvim'				" Dependency for telescope
Plug 'kyazdani42/nvim-tree.lua'				" A file navigator window
"---------------------===Appearance===---------------------"
Plug 'geg2102/onedark.nvim-1'			    " Onedark theme
Plug 'kyazdani42/nvim-web-devicons'			" Icons 
Plug 'ryanoasis/vim-devicons'				" More icons
Plug 'hoob3rt/lualine.nvim'				    " Status line
Plug 'thaerkh/vim-indentguides'             " Indent guides
Plug 'p00f/nvim-ts-rainbow'                 " Rainbow Parentheses
Plug 'machakann/vim-highlightedyank'        " Highlighted yanks
Plug 'romgrk/barbar.nvim'                   " Tab line
"---------------------===IDE Tools===---------------------"
Plug 'nvim-treesitter/nvim-treesitter'		" Treesitter 
Plug 'neovim/nvim-lspconfig'			    " LSP for neovim
Plug 'hrsh7th/vim-vsnip'				    " Snippet support
Plug 'hrsh7th/cmp-nvim-lsp'				    " For completion 
Plug 'hrsh7th/cmp-buffer'				    " Cmp dependency
Plug 'hrsh7th/cmp-path'					    " Cmp dependency
Plug 'hrsh7th/cmp-cmdline'				    " Cmp dependency
Plug 'hrsh7th/nvim-cmp'					    " Cmp dependency
Plug 'hrsh7th/cmp-vsnip'				    " Cmp dependency
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'	" Cmp show signature help while writing
Plug 'williamboman/nvim-lsp-installer'      " For installing language servers easily
Plug 'tami5/lspsaga.nvim'				    " Lsp plugin for performant UI
Plug 'scrooloose/nerdcommenter'             " Easy code documentation
Plug 'urbainvaes/vim-ripple'                " For easy access to REPL
"---------------------===Other===---------------------"
Plug 'gennaro-tedesco/nvim-peekup'          " Quickly examine registers
Plug 'nvim-treesitter/playground'           " For examining things in treesitter
Plug 'ojroques/vim-oscyank'                 " Copying to clipboard over ssh
call plug#end()
]])

--Autocommands
vim.cmd([[autocmd FileType python,c,cpp,lua set colorcolumn=120]])

-- Set options
vim.o.number=true
vim.o.relativenumber=true
vim.o.tabstop=4
vim.o.shiftwidth=4
vim.o.smarttab=true
vim.o.expandtab=true
vim.o.clipboard='unnamed'
vim.o.incsearch=true
vim.o.hlsearch=true
vim.o.wrap=true
vim.o.linebreak=true
vim.o.foldmethod="expr"
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'

-- Keymappings
local opts = {noremap = true, silent = true} -- Convenient for a lot of mappings
vim.api.nvim_set_keymap('n', "'", "<cmd>NvimTreeToggle<CR>", opts)
vim.api.nvim_set_keymap('n', "j", "<Plug>(accelerated_jk_gj)", {})
vim.api.nvim_set_keymap('n', "k", "<Plug>(accelerated_jk_gk)", {})
vim.api.nvim_set_keymap('n', "<leader>ff", "<cmd>Telescope find_files<CR>", opts)
vim.api.nvim_set_keymap('n', "<leader>fg", "<cmd>Telescope live_grep<CR>", opts)
vim.api.nvim_set_keymap('n', "<leader>fb", "<cmd>Telescope buffers<CR>", opts)
vim.api.nvim_set_keymap('n', "<leader>fh", "<cmd>Telescope oldfiles<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>p", "<cmd>tabnew term://python3 -m pudb.run %<CR>", opts)
vim.api.nvim_set_keymap("n", "<F1>", "<cmd>BufferPrevious<CR>", {})
vim.api.nvim_set_keymap("n", "<F2>", "<cmd>BufferNext<CR>", {})
vim.api.nvim_set_keymap("t", "<A-[>", "<C-\\><C-n>", {noremap=true})
vim.api.nvim_set_keymap("t", "<C-l>", "<C-\\><C-n><C-w>l", {noremap=true})
vim.api.nvim_set_keymap("t", "<C-j>", "<C-\\><C-n><C-w>j", {noremap=true})
vim.api.nvim_set_keymap("t", "<C-h>", "<C-\\><C-n><C-w>h", {noremap=true})
vim.api.nvim_set_keymap("t", "<C-k>", "<C-\\><C-n><C-w>k", {noremap=true})
vim.api.nvim_set_keymap("n", "<leader>w", "<cmd>HopWord<CR>", opts)
vim.api.nvim_set_keymap("v", "<leader>c", ":OSCYank<CR>", {noremap=true})
vim.api.nvim_set_keymap("n", "<leader>o", "<Plug>OSCYank", {})
vim.api.nvim_set_keymap("n", "<Space>", "za", opts)

-- Colorscheme
require("onedark").setup({
})

-- Lualine
local lualine = require("lualine")
lualine.setup {
	options = {
		theme="onedark"
	}
}

-- Treesitter
local treesitter = require("nvim-treesitter.configs")
treesitter.setup {
    ensure_installed = 'maintained',
    highlight = {
        enable = true,
        disable = {"html"}
    },
    rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = nil,
    },
    indent = {
        enable = true
    }
}

-- Completion Engine
local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end
    },
    mapping = {
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<TAB>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ['<S-TAB>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
    }, {
      { name = 'buffer' },
    })
})

cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Lsp
local nvim_lsp = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    buf_set_keymap("n", "<leader>r", "<cmd>Lspsaga rename<cr>", opts)
    buf_set_keymap("n", "gx", "<cmd>Lspsaga code_action<cr>", opts)
    buf_set_keymap("x", "gx", ":<c-u>Lspsaga range_code_action<cr>", opts)
    buf_set_keymap("n", "K",  "<cmd>Lspsaga hover_doc<cr>", opts)
    buf_set_keymap("n", "go", "<cmd>Lspsaga show_line_diagnostics<cr>", opts)
    buf_set_keymap("n", "gj", "<cmd>Lspsaga diagnostic_jump_next<cr>", opts)
    buf_set_keymap("n", "gk", "<cmd>Lspsaga diagnostic_jump_prev<cr>", opts)
    buf_set_keymap("n", "<C-u>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<cr>", {})
    buf_set_keymap("n", "<C-d>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<cr>", {})
end

-- nvim-lsp-installer
local lsp_installer = require("nvim-lsp-installer")
lsp_installer.on_server_ready(function(server)
    local default_opts  = {
        capabilities = capabilities,
        on_attach = on_attach
    }

    local server_opts = {
    ["sumneko_lua"] = function()
        default_opts.settings = {
                Lua = {
                    runtime = {
                        version = 'LuaJIT',
                    },
                    diagnostics = {
                        globals = {'vim'},
                    },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file("", true),
                    },
                    telemetry = {
                        enable = false,
                    },
                },
            }
        end
        }
    local server_options = server_opts[server.name] and server_opts[server.name]() or default_opts
    server:setup(server_options)
end)

-- nvim-tree
require("nvim-tree").setup{
    view = {
        auto_resize = true
    }
}

-- hop
require("hop").setup()


