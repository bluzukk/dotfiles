-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    -- Telescope
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use {
        "folke/zen-mode.nvim",
        config = function()
            require("zen-mode").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
                options = {
                    -- signcolumn = "no", -- disable signcolumn
                    -- number = false, -- disable number column
                    -- relativenumber = false, -- disable relative numbers
                    -- cursorline = false, -- disable cursorline
                    cursorcolumn = false, -- disable cursor column
                    -- foldcolumn = "0", -- disable fold column
                    -- list = false, -- disable whitespace characters
                },
            }
        end
    }
    -- Session Management
    use {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    }

    --use "xolox/vim-session"
    -- Lua
    use {
        "Shatur/neovim-session-manager",
        config = function()
            local Path = require('plenary.path')
            require('session_manager').setup({
                sessions_dir = Path:new(vim.fn.stdpath('data'), 'sessions'), -- The directory where the session files will be saved.
                path_replacer = '__', -- The character to which the path separator will be replaced for session files.
                colon_replacer = '++', -- The character to which the colon symbol will be replaced for session files.
                autoload_mode = require('session_manager.config').AutoloadMode.LastSession, -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
                autosave_last_session = true, -- Automatically save last session on exit and on session switch.
                autosave_ignore_not_normal = true, -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
                autosave_ignore_dirs = {}, -- A list of directories where the session will not be autosaved.
                autosave_ignore_filetypes = { -- All buffers of these file types will be closed before the session is saved.
                'gitcommit',
            },
            autosave_ignore_buftypes = {}, -- All buffers of these bufer types will be closed before the session is saved.
            autosave_only_in_session = true, -- Always autosaves session. If true, only autosaves after a session is active.
            max_path_length = 80,  -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
        })
        end
    }
    use 'lervag/vimtex'
    use 'glepnir/dashboard-nvim'
    use "liuchengxu/space-vim-theme"
    use "bluz71/vim-moonfly-colors"
    use 'tribela/vim-transparent'
    use 'nekonako/xresources-nvim'
    use { 'AlphaTechnolog/pywal.nvim', as = 'pywal' }
    use({ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' })
    use 'nvim-treesitter/playground'
    use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP
    use({
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
    })

    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    }
    use "github/copilot.vim"

    use {
        'nvim-tree/nvim-tree.lua',
        tag = 'nightly' -- optional, updated every week. (see issue #1193)
    }
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }

    use "nvim-lualine/lualine.nvim"

    use({
        'noib3/nvim-cokeline',
        config = function()
            require('cokeline').setup()
        end
    })
    use 'ms-jpq/chadtree'
    use "tpope/vim-surround"
    use "alvan/vim-closetag"
    use 'mhinz/vim-signify'
    use 'jiangmiao/auto-pairs'
    use 'tpope/vim-abolish'
    use 'junegunn/vim-easy-align'
    use 'scrooloose/nerdcommenter'
    use 'Yggdroot/indentLine'
    use 'chrisbra/Colorizer'
    use 'KabbAmine/vCoolor.vim'
    use 'dkarter/bullets.vim'
    --use 'wellle/context.vim'
    use 'antoinemadec/FixCursorHold.nvim'

    use {
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require("todo-comments").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    }
    use "ciaranm/inkpot"
    use "NLKNguyen/papercolor-theme"
    use "dracula/vim"
    use "pineapplegiant/spaceduck"
    use "sainnhe/edge"
    use "kyoz/purify"
    use "bcicen/vim-vice"
    use "Shadorain/shadotheme"
    use "rebelot/kanagawa.nvim"
    use("petertriho/nvim-scrollbar")
    use({
        "folke/noice.nvim",
        config = function()
            require("noice").setup({
                lsp = {
                    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true,
                    },
                },
                -- you can enable a preset for easier configuration
                presets = {
                    bottom_search = true, -- use a classic bottom cmdline for search
                    command_palette = false, -- position the cmdline and popupmenu together
                    long_message_to_split = true, -- long messages will be sent to a split
                    inc_rename = false, -- enables an input dialog for inc-rename.nvim
                    lsp_doc_border = false, -- add a border to hover docs and signature help
                },
            })
        end,
        requires = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            "rcarriga/nvim-notify",
        }
    })

    -- Visual Stuff
    use "junegunn/rainbow_parentheses.vim"
    use "junegunn/limelight.vim"
    use "junegunn/vim-journal"
    use 'dylanaraps/wal.vim'

    use { "catppuccin/nvim", as = "catppuccin" }
    use 'folke/tokyonight.nvim'
end)
