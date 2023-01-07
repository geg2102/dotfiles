-- =====================================================================================
-- PACKER BOOTSTRAP
-- =====================================================================================

local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({
            "git",
            "clone",
            "--depth",
            "1",
            "https://github.com/wbthomason/packer.nvim",
            install_path
        })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

-- =====================================================================================
-- PLUGINS
-- =====================================================================================
require("packer").startup(function(use)
    use {
        "wbthomason/packer.nvim"
    }
    use {
        "ahmedkhalf/project.nvim",
        config = function()
            require("project_nvim").setup {}
        end
    }
    use {
        "akinsho/toggleterm.nvim",
        tag = "*",
        config = function()
            require("toggleterm").setup({
                open_mapping = [[<leader>t]],
                direction = "float",
                size = function(term)
                    if term.direction == "horizontal" then
                        return 15
                    elseif term.direction == "vertical" then
                        return vim.o.columns * .4
                    end
                end,
                float_opts = {
                    border = "double"
                },
                persist_size = false
            })
        end
    }
    use {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
        end
    }
    use {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    }
    use {
        "williamboman/mason-lspconfig",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "bashls", "jedi_language_server", "sumneko_lua" },
                automatic_installation = true
            })
        end
    }
    use {
        "neovim/nvim-lspconfig",
        config = function()
            local path = {}
            table.insert(path, "lua/?.lua")
            table.insert(path, "lua/?/init.lua")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local servers = {
                "bashls",
                "jedi_language_server",
                "sumneko_lua",
            }
            local nvim_lsp = require("lspconfig")
            for _, server in ipairs(servers) do
                nvim_lsp[server].setup {
                    capabilities = capabilities,
                }
            end
            nvim_lsp.sumneko_lua.setup {
                cmd = { "lua-language-server" },
                settings = {
                    Lua = {
                        runtime = {
                            version = "LuaJIT",
                            path = path
                        },
                        diagnostics = {
                            globals = { "vim" }
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false
                        },
                        telemetry = {
                            enable = false,
                        },
                    },
                    capabilities = capabilities
                }
            }
            nvim_lsp.ccls.setup {
                capabilities = capabilities,
                init_options = {
                    compilationDatabaseDirectory = "root",
                    index = {
                        threads = 0
                    },
                    clang = {
                        excludeArgs = { "-frounding-math" }
                    }
                }
            }
        end

    }
    use {
        "mfussenegger/nvim-dap"
    }
    use {
        "rcarriga/nvim-dap-ui",
        requires = { "mfussenegger/nvim-dap" },
        config = function()
            require("dapui").setup()
        end
    }
    use {
        "jayp0521/mason-nvim-dap.nvim",
        config = function()
            require("mason-nvim-dap").setup({
                ensure_installed = {
                    "lldb",
                    "debugpy",
                },
                automatic_setup = true
            })
        end
    }
    use {
        "nvim-telescope/telescope.nvim",
        requires = { "nvim-lua/plenary.nvim", "nvim-lua/popup.nvim" },
        config = function()
            require("telescope").setup({})
        end
    }
    use {
        "nvim-telescope/telescope-file-browser.nvim",
        config = function()
            require("telescope").load_extension("file_browser")
        end
    }
    use {
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "make",
        config = function()
            require("telescope").load_extension("fzf")
        end
    }
    use {
        "nvim-treesitter/nvim-treesitter",
        run = function()
            pcall(require("nvim-treesitter.install").update { with_sync = true })
        end,
        config = function()
            local treesitter = require("nvim-treesitter.configs")
            treesitter.setup {
                ensure_installed = { "python", "bash", "lua", "scala", "c", "cpp", "vim", "help" },
                highlight = {
                    enable = true,
                    disable = function(_, bufnr) -- Disable in large buffers
                        return vim.api.nvim_buf_line_count(bufnr) > 5000
                    end,
                },
                indent = {
                    enable = false
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<c-space>",
                        node_incremental = "<c-space>",
                        scope_incremental = "<c-s>",
                        node_decremental = "<c-backspace>"
                    }
                },
                rainbow = {
                    enable = true,
                    extended_mode = true,
                },
                autopairs = {
                    enable = true
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["aa"] = "@parameter.outer",
                            ["ia"] = "@parameter.inner",
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                        }
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            ["]m"] = "@function.outer",
                            ["]]"] = "@class.outer",
                        },
                        goto_next_end = {
                            ["]M"] = "@function.outer",
                            ["]["] = "@class.outer",

                        },
                        goto_previous_start = {
                            ["[m"] = "@function.outer",
                            ["[["] = "@class.outer",
                        },
                        goto_previous_end = {
                            ["[M"] = "@function.outer",
                            ["[]"] = "@class.outer",
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ["<leader>s"] = "@parameter.inner"
                        },
                        swap_previous = {
                            ["<leader>S"] = "@parameter.inner"
                        }
                    }
                }
            }
        end
    }
    use {
        "rebelot/kanagawa.nvim",
        config = function()
            require("kanagawa").setup({
                dimInactive = true
            })
        end
    }
    use {
        "geg2102/nvim-python-repl",
        config = function()
            require("nvim-python-repl").setup({
                vsplit = true
            })
        end
    }
    use {
        "beauwilliams/focus.nvim",
        config = function()
            require("focus").setup()
        end
    }
    use {
        "ojroques/vim-oscyank"
    }
    use {
        "kylechui/nvim-surround",
        tag = "*",
        config = function()
            require("nvim-surround").setup({})
        end
    }
    use {
        "phaazon/hop.nvim",
        config = function()
            require("hop").setup {
                create_al_autocmd = true
            }
        end
    }
    use {
        "machakann/vim-highlightedyank"
    }
    use {
        "hoob3rt/lualine.nvim",
        config = function()
            require("lualine").setup {
                options = {
                    theme = "kanagawa"
                }
            }
        end
    }
    use {
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/vim-vsnip",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-vsnip",
            "hrsh7th/vim-vsnip-integ",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "tamago324/cmp-zsh",
        },
        config = function()
            local has_words_before = function()
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and
                    vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            local feedkey = function(key, mode)
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
            end
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body)
                    end
                },
                mapping = {
                    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
                    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif vim.fn["vsnip#available"](1) == 1 then
                            feedkey("<Plug>(vsnip-expand-or-jump)", "")
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function()
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                            feedkey("<Plug>(vsnip-jump-prev)", "")
                        end
                    end, { "i", "s" }),
                },
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "vsnip" },
                    { name = "nvim_lsp_signature_help" },
                    { name = "cmp-nvim-lua" },
                    { name = "cmp-zsh" },
                    { name = "path" }
                }, {
                    { name = "buffer" },
                }),
            })
            cmp.setup.cmdline("/", {
                sources = {
                    { name = "buffer" }
                }
            })
            cmp.setup.cmdline(":", {
                sources = cmp.config.sources({
                    { name = "path" }
                }, {
                    { name = "cmdline" }
                })
            })
        end
    }
    use {
        "psliwka/vim-smoothie"
    }
    use {
        "christoomey/vim-tmux-navigator"
    }
    use {
        "rhysd/accelerated-jk"
    }
    use {
        "glepnir/lspsaga.nvim",
        branch = "main",
        config = function()
            local saga = require("lspsaga")
            saga.init_lsp_saga({
                symbol_in_winbar = {
                    enable = true,
                    in_custom = true
                }
            })
        end,
    }
    use {
        "kdheepak/lazygit.nvim"
    }
    use {
        "kevinhwang91/nvim-ufo",
        requires = "kevinhwang91/promise-async",
        config = function()
            require("ufo").setup({
                provider_selector = function(_, _, _)
                    return ''
                end,
            })
        end

    }
    use {
        "romgrk/barbar.nvim",
        requires = { "nvim-tree/nvim-web-devicons" },
        wants = { "nvim-web-devicons" }
    }
    use {
        "tpope/vim-repeat"
    }
    use {
        "lewis6991/impatient.nvim"
    }
    use {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
            require("null-ls").setup({
                debug = true,
                sources = {
                    require("null-ls").builtins.formatting.black.with({
                        extra_args = { "--preview", "--line-length=88" }
                    }),
                    require("null-ls").builtins.formatting.prettier.with({
                        filetypes = { "html", "json", "yaml", "graphql", "md", "txt", "css" }
                    }),
                    require("null-ls").builtins.formatting.fixjson.with({})
                }
            })
        end
    }
    use {
        "fedepujol/move.nvim"
    }
    use {
        "stevearc/aerial.nvim",
        config = function()
            require("aerial").setup({
                on_attach = function(bufnr)
                    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>a", "<cmd>AerialToggle!<CR>", {})
                    vim.api.nvim_buf_set_keymap(bufnr, "n", "{", "<cmd>AerialPrev<CR>", {})
                    vim.api.nvim_buf_set_keymap(bufnr, "n", "}", "<cmd>AerialNext<CR>", {})
                    vim.api.nvim_buf_set_keymap(bufnr, "n", "[[", "<cmd>AerialPrevUp<CR>", {})
                    vim.api.nvim_buf_set_keymap(bufnr, "n", "]]", "<cmd>AerialNextUp<CR>", {})
                end
            })
        end
    }
    use {
        "unblevable/quick-scope"
    }
    use {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({})
        end
    }
    use {
        "p00f/nvim-ts-rainbow"
    }
    use {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("indent_blankline").setup {
                show_current_context = true,
                show_current_context_start = true,
            }
        end
    }
    use {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end
    }
    use {
        "tpope/vim-dadbod"
    }
    use {
        "kristijanhusak/vim-dadbod-ui"
    }
    use {
        "kristijanhusak/vim-dadbod-completion"
    }
    use {
        "folke/lua-dev.nvim"
    }
    use {
        "nvim-treesitter/playground"
    }
    use {
        "tpope/vim-scriptease"
    }
    use {
        "scalameta/nvim-metals",
        config = function()
            local metals_config = require("metals").bare_config()

            metals_config.settings = {
                showImplicitArguments = true,
                excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
            }

            -- *READ THIS*
            -- I *highly* recommend setting statusBarProvider to true, however if you do,
            -- you *have* to have a setting to display this in your statusline or else
            -- you'll not see any messages from metals. There is more info in the help
            -- docs about this
            -- metals_config.init_options.statusBarProvider = "on"

            -- Example if you are using cmp how to make sure the correct capabilities for snippets are set
            metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Debug settings if you're using nvim-dap
            local dap = require("dap")

            dap.configurations.scala = {
                {
                    type = "scala",
                    request = "launch",
                    name = "RunOrTest",
                    metals = {
                        runType = "runOrTestFile",
                        --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
                    },
                },
                {
                    type = "scala",
                    request = "launch",
                    name = "Test Target",
                    metals = {
                        runType = "testTarget",
                    },
                },
            }

            metals_config.on_attach = function(client, bufnr)
                require("metals").setup_dap()
            end
            local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "scala", "sbt", "java" },
                callback = function()
                    require("metals").initialize_or_attach(metals_config)
                end,
                group = nvim_metals_group
            })
        end
    }
    use {
        "RRethy/nvim-treesitter-textsubjects",
        after = "nvim-treesitter"
    }
    use {
        "rafamadriz/friendly-snippets"
    }
    use {
        "moll/vim-bbye"
    }
    use {
        "goolord/alpha-nvim",
        requires = { "kyazdani42/nvim-web-devicons" },
        config = function()
            require("alpha").setup(require("alpha.themes.startify").config)
        end
    }
    use {
        "romgrk/nvim-treesitter-context"
    }
    use {
        "anuvyklack/hydra.nvim",
        requires = "anuvyklack/keymap-layer.nvim",
        config = function()
            local Hydra = require('hydra')
            local dap = require 'dap'

            local hint = [[
 _n_: step over   _s_: Continue/Start   _b_: Breakpoint     _K_: Eval
 _i_: step into   _x_: Quit             _r_: Repl           _U_: UI
 _o_: step out    _X_: Stop             ^ ^
 _c_: to cursor   _C_: Close UI
 ^
 ^ ^              _q_: exit
]]

            local dap_hydra = Hydra({
                hint = hint,
                config = {
                    color = 'pink',
                    invoke_on_body = true,
                    hint = {
                        position = 'bottom',
                        border = 'rounded'
                    },
                },
                name = 'dap',
                mode = { 'n', 'x' },
                body = '<leader>dh',
                heads = {
                    { 'n', dap.step_over, { silent = true } },
                    { 'i', dap.step_into, { silent = true } },
                    { 'o', dap.step_out, { silent = true } },
                    { 'c', dap.run_to_cursor, { silent = true } },
                    { 's', dap.continue, { silent = true } },
                    { 'r', dap.repl.open, { silent = true } },
                    { 'x', ":lua require'dap'.disconnect({ terminateDebuggee = false })<CR>", { exit = true,
                        silent = true } },
                    { 'X', dap.close, { silent = true } },
                    { 'U', ":lua require('dapui').open()<cr>", { silent = true } },
                    { 'C', ":lua require('dapui').close()<cr>:DapVirtualTextForceRefresh<CR>", { silent = true } },
                    { 'b', dap.toggle_breakpoint, { silent = true } },
                    { 'K', ":lua require('dap.ui.widgets').hover()<CR>", { silent = true } },
                    { 'q', nil, { exit = true, nowait = true } },
                }
            })
            Hydra.spawn = function(head)
                if head == "dap-hydra" then
                    dap_hydra:activate()
                end
            end

            local gitsigns = require('gitsigns')
            hint = [[
 _J_: next hunk   _s_: stage hunk        _d_: show deleted   _b_: blame line
 _K_: prev hunk   _u_: undo last stage   _p_: preview hunk   _B_: blame show full 
 ^ ^              _S_: stage buffer      ^ ^                 _/_: show base file
 ^
 ^ ^              _<Enter>_: Lazygit              _q_: exit
]]
            Hydra({
                name = 'Git',
                hint = hint,
                config = {
                    buffer = bufnr,
                    color = 'pink',
                    invoke_on_body = true,
                    hint = {
                        border = 'rounded'
                    },
                    on_enter = function()
                        vim.cmd 'mkview'
                        vim.cmd 'silent! %foldopen!'
                        vim.bo.modifiable = false
                        gitsigns.toggle_signs(true)
                        gitsigns.toggle_linehl(true)
                    end,
                    on_exit = function()
                        local cursor_pos = vim.api.nvim_win_get_cursor(0)
                        vim.cmd 'loadview'
                        vim.api.nvim_win_set_cursor(0, cursor_pos)
                        vim.cmd 'normal zv'
                        gitsigns.toggle_signs(false)
                        gitsigns.toggle_linehl(false)
                        gitsigns.toggle_deleted(false)
                    end,
                },
                mode = { 'n', 'x' },
                body = '<leader>g',
                heads = {
                    { 'J',
                        function()
                            if vim.wo.diff then return ']c' end
                            vim.schedule(function() gitsigns.next_hunk() end)
                            return '<Ignore>'
                        end,
                        { expr = true, desc = 'next hunk' } },
                    { 'K',
                        function()
                            if vim.wo.diff then return '[c' end
                            vim.schedule(function() gitsigns.prev_hunk() end)
                            return '<Ignore>'
                        end,
                        { expr = true, desc = 'prev hunk' } },
                    { 's', ':Gitsigns stage_hunk<CR>', { silent = true, desc = 'stage hunk' } },
                    { 'u', gitsigns.undo_stage_hunk, { desc = 'undo last stage' } },
                    { 'S', gitsigns.stage_buffer, { desc = 'stage buffer' } },
                    { 'p', gitsigns.preview_hunk, { desc = 'preview hunk' } },
                    { 'd', gitsigns.toggle_deleted, { nowait = true, desc = 'toggle deleted' } },
                    { 'b', gitsigns.blame_line, { desc = 'blame' } },
                    { 'B', function() gitsigns.blame_line { full = true } end, { desc = 'blame show full' } },
                    { '/', gitsigns.show, { exit = true, desc = 'show base file' } }, -- show the base of the file
                    { '<Enter>', '<Cmd>LazyGit<CR>', { exit = true, desc = 'Neogit' } },
                    { 'q', nil, { exit = true, nowait = true, desc = 'exit' } },
                }
            })

            local cmd = require('hydra.keymap-util').cmd

            hint = [[
                 _f_: files       _m_: marks
   🭇🬭🬭🬭🬭🬭🬭🬭🬭🬼    _o_: old files   _g_: live grep
  🭉🭁🭠🭘    🭣🭕🭌🬾   _p_: projects    _/_: search in file
  🭅█ ▁     █🭐
  ██🬿      🭊██   _r_: resume      _u_: undotree
 🭋█🬝🮄🮄🮄🮄🮄🮄🮄🮄🬆█🭀  _h_: vim help    _c_: execute command
 🭤🭒🬺🬹🬱🬭🬭🬭🬭🬵🬹🬹🭝🭙  _k_: keymaps     _;_: commands history 
                 _O_: options     _?_: search history
 ^
                 _<Enter>_: Telescope           _<Esc>_
]]

            Hydra({
                name = 'Telescope',
                hint = hint,
                config = {
                    color = 'teal',
                    invoke_on_body = true,
                    hint = {
                        position = 'middle',
                        border = 'rounded',
                    },
                },
                mode = 'n',
                body = '<Leader>f',
                heads = {
                    { 'f', cmd 'Telescope find_files' },
                    { 'g', cmd 'Telescope live_grep' },
                    { 'o', cmd 'Telescope oldfiles', { desc = 'recently opened files' } },
                    { 'h', cmd 'Telescope help_tags', { desc = 'vim help' } },
                    { 'm', cmd 'MarksListBuf', { desc = 'marks' } },
                    { 'k', cmd 'Telescope keymaps' },
                    { 'O', cmd 'Telescope vim_options' },
                    { 'r', cmd 'Telescope resume' },
                    { 'p', cmd 'Telescope projects', { desc = 'projects' } },
                    { '/', cmd 'Telescope current_buffer_fuzzy_find', { desc = 'search in file' } },
                    { '?', cmd 'Telescope search_history', { desc = 'search history' } },
                    { ';', cmd 'Telescope command_history', { desc = 'command-line history' } },
                    { 'c', cmd 'Telescope commands', { desc = 'execute command' } },
                    { 'u', cmd 'silent! %foldopen! | UndotreeToggle', { desc = 'undotree' } },
                    { '<Enter>', cmd 'Telescope', { exit = true, desc = 'list all pickers' } },
                    { '<Esc>', nil, { exit = true, nowait = true } },
                }
            })


        end
    }
    use {
        "mg979/vim-visual-multi"
    }
    use {
        "jalvesaq/Nvim-R",
        branch = "oldstable"
    }
    use {
        "sindrets/diffview.nvim",
        requires = "nvim-lua/plenary.nvim"
    }
    use {
        "kkoomen/vim-doge",
        run = function()
            vim.fn["doge#install"]()
        end
    }
    use {
        "jsborjesson/vim-uppercase-sql"
    }
    use {
        "lervag/vimtex"
    }
    use {
        "nvim-tree/nvim-tree.lua",
        requires = {
            "nvim-tree/nvim-web-devicons"
        },
        config = function()
            require("nvim-tree").setup()
            vim.g.loaded_netrw = 1
            vim.g.loadednetrwPlugin = 1
            vim.opt.termguicolors = true
        end
    }

    if packer_bootstrap then
        require("packer").sync()
    end
end
)

if packer_bootstrap then
    print "============================"
    print "Plugins are being installed"
    print "Wait until packer completes then restart"
    print "============================"
    return
end

-- Autorecompile when I save this file
local packer_group = vim.api.nvim_create_augroup("Packer", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
    command = "source <afile> | silent! LspStop | silent! LspStart | PackerCompile",
    group = packer_group,
    pattern = vim.fn.expand "$MYVIMRC"
})

-- =====================================================================================
-- VIM OPTIONS
-- =====================================================================================

vim.cmd([[colorscheme kanagawa]])

vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.mouse = ""
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.clipboard = "unnamed"
vim.opt.autoindent = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.pastetoggle = "<F10>"
vim.opt.undofile = true
vim.opt.scrolloff = 8
vim.opt.swapfile = false
vim.opt.splitbelow = true
vim.opt.foldcolumn = "1"
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevelstart = 0
vim.opt.foldenable = true
vim.opt.completeopt = { "menuone", "noselect", "noinsert" }
vim.g.nvim_system_wide = 1
vim.g.mapleader = ","
vim.g.indent_blankline_buftype_exclude = { "terminal" }

-- =====================================================================================
-- KEYBINDINGS
-- =====================================================================================
vim.keymap.set("i", "<C-s>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")

vim.keymap.set("n", "j", "<Plug>(accelerated_jk_gj)", { noremap = false })
vim.keymap.set("n", "k", "<Plug>(accelerated_jk_gk)", { noremap = false })

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Goto definition" })
vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { desc = "Goto implementation" })

vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Fuzzy find files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope file_browser<CR>", { desc = "File browser" })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope oldfiles<CR>", { desc = "Old files" })
vim.keymap.set("n", "<leader>fv", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" })
vim.keymap.set("n", '""', "<cmd>Telescope registers<CR>", { desc = "Search registers" })
vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", { desc = "Lsp references" })

vim.keymap.set("n", "<leader>w", "<cmd>HopWord<CR>")

vim.keymap.set("n", "<leader>r", "<cmd>Lspsaga rename<CR>")
vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>")
vim.keymap.set("n", "gh", "<cmd>Lspsaga lsp_finder<CR>")
vim.keymap.set("n", "gx", "<cmd>Lspsaga code_action<CR>")
vim.keymap.set("v", "gx", "<cmd>Lspsaga range_code_action<CR>")
vim.keymap.set("n", "go", "<cmd>Lspsaga show_line_diagnostics<CR>")
vim.keymap.set("n", "gj", "<cmd>Lspsaga diagnostic_jump_next<CR>")
vim.keymap.set("n", "gk", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
vim.keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<CR>")

vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>")

vim.keymap.set("n", "<Space>", "za")
vim.keymap.set("n", "<leader><Space>", "zA")

vim.keymap.set("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{async=true}<CR>")
vim.keymap.set("i", "<leader>lf", "<cmd>lua vim.lsp.buf.format{async=true}<CR>")


vim.keymap.set("n", "<C-p>", "<cmd>BufferPick<CR>")
vim.keymap.set("n", "<F1>", "<cmd>BufferPrevious<CR>")
vim.keymap.set("n", "<F2>", "<cmd>BufferNext<CR>")
vim.keymap.set("n", "<leader>q", "<cmd>BufferClose<CR>")
vim.keymap.set("n", "<leader>q!", "<cmd>BufferClose!<CR>")

vim.keymap.set("n", "<A-j>", ":MoveLine(1)<CR>")
vim.keymap.set("n", "<A-k>", ":MoveLine(-1)<CR>")
vim.keymap.set("n", "<A-h>", ":MoveHChar(-1)<CR>")
vim.keymap.set("n", "<A-l>", ":MoveHChar(1)<CR>")
vim.keymap.set("v", "<A-j>", ":MoveBlock(1)<CR>")
vim.keymap.set("v", "<A-k>", ":MoveBlock(-1)<CR>")
vim.keymap.set("v", "<A-h>", ":MoveHBlock(-1)<CR>")
vim.keymap.set("v", "<A-l>", ":MoveHBlock(1)<CR>")

vim.keymap.set("t", "<A-[>", "<C-\\><C-n>")
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l")
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h")
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j")
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k")

vim.keymap.set("v", "<leader>c", ":OSCYank<CR>")
vim.keymap.set("n", "<leader>c", "<Plug>OSCYank")

vim.keymap.set("n", "<leader>du", ":DBUIToggle<CR>")

-- =====================================================================================
-- AUTOCOMMANDS
-- =====================================================================================

local colorcolumn = vim.api.nvim_create_augroup("ColorColumn", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "python", "c", "cpp", "h", "lua", "scala" },
    command = "silent! set colorcolumn=88",
    group = colorcolumn
})
local dadbodcompletion = vim.api.nvim_create_augroup("DBCompletion", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "sql", "psql", "plsql" },
    command = [[
        lua require("cmp").setup.buffer({ 
            sources = { { name = "vim-dadbod-completion" } } 
        })
        ]],
    group = dadbodcompletion
})
local jsonconceal = vim.api.nvim_create_augroup("JsonConceal", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "json" },
    command = "silent! set conceallevel=0",
    group = jsonconceal
})


-- =====================================================================================
-- CUSTOM FUNCTIONS
-- =====================================================================================

P = function(v)
    print(vim.inspect(v))
    return v
end

RELOAD = function(...)
    return require("plenary.reload").reload_module(...)
end

R = function(name)
    RELOAD(name)
    return require(name)
end
