-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    -- Telescope
    use { 'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use { "folke/zen-mode.nvim",
        config = function()
            require("zen-mode").setup {
                options = {
                    cursorcolumn = false, -- disable cursor column
                },
            }
        end
    }

    use { "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup {
            }
        end
    }

    use {
	    "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    }


    use 'lervag/vimtex'

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
    'goolord/alpha-nvim',
    requires = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
        require'alpha'.setup(require'dashboard-nvim theme'.config)
    end
}

    use { 'VonHeikemen/lsp-zero.nvim',
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

    use { 'nvim-tree/nvim-tree.lua',
        tag = 'nightly' -- optional, updated every week. (see issue #1193)
    }
    use { 'numToStr/Comment.nvim',
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
    use 'antoinemadec/FixCursorHold.nvim'

    use { "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require("todo-comments").setup {
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
                    bottom_search = true,         -- use a classic bottom cmdline for search
                    command_palette = false,      -- position the cmdline and popupmenu together
                    long_message_to_split = true, -- long messages will be sent to a split
                    inc_rename = false,           -- enables an input dialog for inc-rename.nvim
                    lsp_doc_border = false,       -- add a border to hover docs and signature help
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

    use "junegunn/limelight.vim"
    use "junegunn/vim-journal"
    use 'dylanaraps/wal.vim'
    use 'folke/tokyonight.nvim'
end)
