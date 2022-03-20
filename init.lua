local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    packer_bootstrap = vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    print "Installing packer close and reopen Neovim..."
    vim.cmd [[packadd packer.nvim]]
end

-- Use a protected call so we don't error out on first use
local status_ok, _ = pcall(require, "packer")
if not status_ok then
  return
end
-- My REPL plugin


local use = require('packer').use
require('packer').startup(function()
	use "wbthomason/packer.nvim"                                                                   -- package manager
	use "rhysd/accelerated-jk"                                                                     -- Faster j/k when holding
	use "phaazon/hop.nvim"                                                                         -- For jumping to particular places
	use "psliwka/vim-smoothie"                                                                     -- For smooth scrolling
	use "unblevable/quick-scope"                                                                   -- For highlighting f spots
	use "christoomey/vim-tmux-navigator"                                                           -- For navigating between tmux panes and vim splits
	--"---------------------===Project navigation===-------------------                            --"
	use "nvim-telescope/telescope.nvim"                                                            -- For looking through files
	use "nvim-telescope/telescope-file-browser.nvim"                                               -- For looking through files
	use "nvim-lua/popup.nvim"                                                                      -- Dependency for telescope
	use "nvim-lua/plenary.nvim"                                                                    -- Dependency for telescope
	use "kyazdani42/nvim-tree.lua"                                                                 -- A file navigator window
	--"---------------------===Appearance===-------------------                                    --"
	use "navarasu/onedark.nvim"                                                                    -- Onedark theme
	use "kyazdani42/nvim-web-devicons"                                                             -- Icons
	use "ryanoasis/vim-devicons"                                                                   -- More icons
	use "hoob3rt/lualine.nvim"                                                                     -- Status line
	use {"windwp/nvim-autopairs"}                                                                  --Autopairs, integrates with both cmp and treesitter
	use {"numToStr/Comment.nvim"}                                                                  -- Quickly comment out lines
	use "lukas-reineke/indent-blankline.nvim"                                                      -- For indent guides
	use "p00f/nvim-ts-rainbow"                                                                     -- Rainbow Parentheses
	use "machakann/vim-highlightedyank"                                                            -- Highlighted yanks
	use "romgrk/barbar.nvim"                                                                       -- Tab line
	use "onsails/lspkind-nvim"                                                                     -- For lspkind icons
    use "rebelot/kanagawa.nvim"                                                                    -- Colorscheme
	--"---------------------===IDE Tools===-------------------                                     --"
	use {"nvim-treesitter/nvim-treesitter", run=":TSUpdate"}                                       -- Treesitter
	use "neovim/nvim-lspconfig"                                                                    -- LSP for neovim
	use "hrsh7th/vim-vsnip"                                                                        -- Snippet support
	use "hrsh7th/cmp-nvim-lsp"                                                                     -- For completion
	use "hrsh7th/cmp-buffer"                                                                       -- Cmp dependency
	use "hrsh7th/cmp-path"                                                                         -- Cmp dependency
	use "hrsh7th/cmp-cmdline"                                                                      -- Cmp dependency
	use "hrsh7th/nvim-cmp"                                                                         -- Cmp dependency
	use "hrsh7th/cmp-vsnip"                                                                        -- Cmp dependency
	use "hrsh7th/cmp-nvim-lua"                                                                     -- Cmp dependency
	use "hrsh7th/cmp-nvim-lsp-signature-help"                                                      -- Cmp show signature help while writing
	use "williamboman/nvim-lsp-installer"                                                          -- For installing language servers easily
	use "tami5/lspsaga.nvim"                                                                       -- Lsp plugin for performant UI
    use {"geg2102/nvim-python-repl"}                                                               -- My REPL plugin
	-- use "romgrk/nvim-treesitter-context"                                                        -- What function am I in
	use {"kkoomen/vim-doge", run= function() vim.fn['doge#install']() end }                        -- For docstrings
	use {"kristijanhusak/vim-dadbod", branch="async-query"}                                        -- Interacting with sql databases
	use "geg2102/vim-dadbod-ui"                                                                    -- Better UI for dadbod
	use "kristijanhusak/vim-dadbod-completion"                                                     -- Completion
   	use "averms/black-nvim"                                                                        -- Async black formatter for python
    use "jose-elias-alvarez/null-ls.nvim"                                                          -- Formatting for LSP without it
	--"---------------------===Other===-------------------                                         --"
	use "gennaro-tedesco/nvim-peekup"                                                              -- Quickly examine registers
	use "nvim-treesitter/playground"                                                               -- For examining things in treesitter
   	use "folke/lua-dev.nvim"                                                                       -- For plugin development
	use "ojroques/vim-oscyank"                                                                     -- Copying to clipboard over ssh
	use "rafamadriz/friendly-snippets"                                                             -- Snippets
	use {"ur4ltz/surround.nvim"}        -- For surrounding text
	use "sudormrfbin/cheatsheet.nvim"                                                              -- For commands I forget
	use "matze/vim-move"                                                                           -- For moving text around
	use "lewis6991/impatient.nvim"                                                                 -- Quicker loading
	use "moll/vim-bbye"                                                                            -- Better buffer delete
   	use "mg979/vim-visual-multi"                                                                   -- Multi cursor support
   	use "jsborjesson/vim-uppercase-sql"                                                            -- Auto uppercase sql keywords
   	use "goolord/alpha-nvim"                                                                       -- Start screen
    use { "beauwilliams/focus.nvim", config = function() require("focus").setup() end }            -- Autoresizing
    use "RRethy/nvim-treesitter-textsubjects"                                                      -- Text subjects
    use "sunjon/shade.nvim"                                                                        -- Shade inactive windows
    use "tpope/vim-repeat"                                                                         -- Dot command for plugin maps
    use "simrat39/symbols-outline.nvim"                                                            -- Symbol navigator
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

--Autocommands
vim.cmd([[autocmd FileType python,c,cpp,lua set colorcolumn=120]])
vim.cmd([[autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources= {{ name = 'vim-dadbod-completion' }} })]])

-- Set options
vim.opt.number=true
vim.opt.relativenumber=true
vim.opt.tabstop=4
vim.opt.shiftwidth=4
vim.opt.smarttab=true
vim.opt.expandtab=true
vim.opt.clipboard='unnamed'
vim.opt.autoindent=true
vim.opt.incsearch=true
vim.opt.hlsearch=true
vim.opt.wrap=true
vim.opt.linebreak=true
vim.opt.foldmethod="expr"
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.pastetoggle = '<F10>'
vim.opt.completeopt = { "menuone", "noselect" } -- For cmp
vim.opt.undofile = true -- Persistent undo
vim.opt.scrolloff = 8
vim.opt.swapfile = false
vim.g.db_ui_use_nerd_fonts = 1
vim.g.mapleader = ","
vim.g.indent_blankline_buftype_exclude={'terminal'}
vim.cmd([[filetype plugin indent on]])

-- Keymappings
local opts = {noremap = true, silent = true} -- Convenient for a lot of mappings
vim.api.nvim_set_keymap('n', "'", "<cmd>SymbolsOutline<CR>", opts)
vim.api.nvim_set_keymap('n', "j", "<Plug>(accelerated_jk_gj)", {})
vim.api.nvim_set_keymap('n', "k", "<Plug>(accelerated_jk_gk)", {})
vim.api.nvim_set_keymap('n', "<leader>ff", "<cmd>Telescope find_files<CR>", opts)
vim.api.nvim_set_keymap('n', "<leader>fg", "<cmd>Telescope live_grep<CR>", opts)
vim.api.nvim_set_keymap('n', "<leader>fb", "<cmd>Telescope file_browser<CR>", opts)
vim.api.nvim_set_keymap('n', "<leader>fd", "<cmd>Telescope current_buffer_fuzzy_find<CR>", opts)
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
vim.api.nvim_set_keymap("n", "<leader><Space>", "zA", opts)
vim.api.nvim_set_keymap("n", "<leader>du", ":DBUIToggle<CR>", opts)
vim.api.nvim_set_keymap("n", "<F10>", ":set invpaste paste?<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>q", ":BufferClose<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>q!", ":BufferClose!<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>b", ":BufferOrderByBufferNumber<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>y", "<cmd>call Black()<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-p>", ":BufferPick<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>h", ":noh<CR>", opts)
vim.api.nvim_set_keymap("i", "<C-s>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)

-- Colorscheme
require("onedark").setup{
    highlights = {
        Visual = {
            fg = '$cyan',
            bg = '$light_grey'
        }
    }
}

require("onedark").load()
-- vim.cmd([[colorscheme kanagawa]])
-- Lualine
local lualine = require("lualine")
lualine.setup {
	options = {
		-- theme="kanagawa"
        theme="onedark"
	}
}

-- Treesitter
local treesitter = require("nvim-treesitter.configs")
treesitter.setup {
    ensure_installed = {'python', 'bash', 'yaml', 'lua', 'vim'},
    highlight = {
        enable = true,
    },
    rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = nil,
    },
    indent = {
        enable = false
    },
    textsubjects = {
        enable = true,
        prev_selection = '"',
        keymaps = {
            ['<cr>'] = 'textsubjects-smart'
        }
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
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
        { name = 'nvim_lua'},
    }, {
      { name = 'buffer' },
      { name = 'cmdline' }
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
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local on_attach = function(_, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    buf_set_keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting_sync()<CR>", opts)
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
local path = {} --vim.split(package.path, ";")
table.insert(path, "lua/?.lua")
table.insert(path, "lua/?/init.lua")

local lsp_installer = require("nvim-lsp-installer")
lsp_installer.on_server_ready(function(server)
    local default_opts  = {
        capabilities = capabilities,
        on_attach = on_attach
    }

    local server_opts = {
    ["sumneko_lua"] = function()
        default_opts.cmd = {"lua-language-server"}
        default_opts.settings = {
                Lua = {
                    runtime = {
                        version = 'LuaJIT',
                        path = path
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
        end,
    ["bashls"] = function()
        default_opts.cmd = {"/usr/bin/bash-langauge-server"}
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

-- ccls
local nvim_lsp = require('lspconfig')
nvim_lsp.ccls.setup{
    on_attach = on_attach,
    capabilities = capabilities,
    init_options = {
        compiliationDatabaseDirectory = "build";
        index = {
            threads = 0
        };
        clang = {
          excludeArgs = { "-frounding-math"} ;
        };
    }
}

-- Indent blankline
require("indent_blankline").setup {
    show_current_context = true,
    show_current_context_start = true,
}

-- Alpha nvim (start screen)
require("alpha").setup(require("alpha.themes.startify").opts)

-- Telescope file browser
require("telescope").load_extension "file_browser"

-- Hop
require("hop").setup()

-- autopairs
require("nvim-autopairs").setup{}

-- comment
require('Comment').setup()

-- my repl
require("nvim-python-repl").setup()

-- surround
require("surround").setup{}

-- null-ls
require("null-ls").setup({
    sources = {
        require("null-ls").builtins.formatting.terraform_fmt
    },
    on_attach = function(client)
        if client.resolved_capabilities.document_formatting then
            vim.cmd([[
            augroup LspFormatting
            autocmd! * <buffer>
            autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()
            augroup END
            ]])
        end
    end
})
