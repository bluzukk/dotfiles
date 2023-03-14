require("plugins")
require("sets")
require("binds")
require("lsp")

local api = vim.api

vim.cmd [[let g:mkdp_theme = 'dark']]
vim.cmd [[let g:mkdp_browser = 'librewolf']]
vim.cmd [[let g:mkdp_auto_start = 1]]

-- Highlight on yank
local yankGrp = api.nvim_create_augroup("YankHighlight", { clear = true })
api.nvim_create_autocmd("TextYankPost", {
    command = "silent! lua vim.highlight.on_yank()",
    group = yankGrp,
})
-- go to last loc when opening a buffer
api.nvim_create_autocmd("BufReadPost", {
    command = [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]] }
)
-- remove whitespace
api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*" },
    command = [[%s/\s\+$//e]],
})

vim.cmd [[let g:vimtex_view_method = 'mupdf']]
vim.cmd [[let g:vimtex_view_general_viewer = 'mupdf']]
vim.cmd [[let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex']]


local config_group = vim.api.nvim_create_augroup('MyConfigGroup', {}) -- A global group for all your config autocommands
vim.api.nvim_create_autocmd({ 'User' }, {
    pattern = "SessionLoadPost",
    group = config_group,
    callback = function()
        require('nvim-tree').toggle(false, true)
    end,
})


------------------------------------------------------------
-- nvim-tree
------------------------------------------------------------
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = false

vim.g.nvim_tree_show_icons = {
    git = 0,
    folders = 0,
    files = 0,
    folder_arrows = 0,
}
local nvim_tree = require('nvim-tree')

nvim_tree.setup({
    view = {
        side = "left",
        --adaptive_size = true,
        width = 25,
    },
    actions = {
        open_file = {
            resize_window = true,
        }
    }
})

------------------------------------------------------------
-- nvim-treesitter
------------------------------------------------------------
require('nvim-treesitter.configs').setup {
    ensure_installed = {
        'python',
        'comment',
        'lua',
    },
    sync_install = false,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}

require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'pywal-nvim',
        component_separators = { left = '|', right = '|' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        }
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = { 'branch' },
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
}

local colors = require("tokyonight.colors").setup()
require("scrollbar").setup({
    handle = {
        color = "#1B1B29",
    },
    marks = {
        Cursor = { color = "#1B1B29",
            text = "." },
        Search = { color = colors.orange },
        Error  = { color = colors.error },
        Warn   = { color = colors.warning },
        Info   = { color = "#8577D9" },
        Hint   = { color = colors.hint },
        Misc   = { color = colors.purple },
    }
})

local yellow = vim.g.terminal_color_3
local get_hex = require('cokeline/utils').get_hex
require('cokeline').setup({
    default_hl = {
        fg = function(buffer)
            return buffer.is_focused
                and get_hex('SpellRare', 'fg')
                -- and get_hex('NvimTreeNormal', "fg")
                or get_hex('NvimTreeNormal', "fg")
        end,
        bg = function(buffer)
            return buffer.is_focused
                and get_hex("CursorLine", "bg")
                or get_hex('NvimTreeNormal', "bg")
        end,
    },
    sidebar = {
        filetype = 'NvimTree',
        components = {
            {
                text = '',
                fg = yellow,
                style = 'bold',
            },
        }
    },
    components = {
        {
            text = '    ',
        },
        {
            text = function(buffer) return buffer.unique_prefix or "!" end,
            fg = get_hex('SpellRare', 'fg'),
            style = "underline",
        },
        {
            text = function(buffer) return buffer.filename .. ' ' end,
        },
        {
            text = '    ',
        }
    },
})

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

require("notify").setup({
    -- Animation style (see below for details)
    stages = "static",
    -- Render function for notifications. See notify-render()
    render = "minimal",
    -- Default timeout for notifications
    timeout = 5000,
    -- For stages that change opacity this is treated as the highlight behind the window
    -- Set this to either a highlight group, an RGB hex value e.g. "#000000" or a function returning an RGB code for dynamic values
    background_colour = "Normal",
    -- Minimum width for notification windows
    minimum_width = 50,
    -- Icons for the different levels
    icons = {
        ERROR = "",
        WARN = "",
        INFO = "",
        DEBUG = "",
        TRACE = "✎",
    },
})

local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Set header
dashboard.section.header.val = {
    "                                                     ",
    "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
    "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
    "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
    "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
    "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
    "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
    "                                                     ",
}

-- Set menu
dashboard.section.buttons.val = {
    dashboard.button( "e", "  > New file" , ":ene <BAR> startinsert <CR>"),
    dashboard.button( "f", "  > Find file", ":Telescope find_files<CR>"),
    dashboard.button( "r", "  > Recent"   , ":Telescope oldfiles<CR>"),
    dashboard.button( "s", "  > Settings" , ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"),
    dashboard.button( "q", "  > Quit NVIM", ":qa<CR>"),
}

-- Send config to alpha
alpha.setup(dashboard.opts)

-- Disable folding on alpha buffer
vim.cmd([[
    autocmd FileType alpha setlocal nofoldenable
]])



vim.cmd [[let g:signify_sign_add = '+']]
vim.cmd [[let g:signify_sign_delete = '-']]
vim.cmd [[let g:signify_sign_change = '?']]

vim.cmd [[let g:indentLine_setConceal = 1]]

vim.cmd [[set completeopt=menu,menuone]]
vim.cmd [[let g:cursorhold_updatetime = 100]]

vim.cmd [[colorscheme xresources]]

-- color tweaking
-- vim.cmd [[highlight WinSeparator gui=NONE guibg=NONE guifg=#0C0C14 cterm=NONE ctermbg=NONE ctermfg=None]]
-- vim.cmd [[highlight VertSplit gui=NONE guibg=NONE guifg=None cterm=NONE ctermbg=NONE ctermfg=gray]]
-- vim.cmd [[highlight link TelescopeBorder Constant]]
-- vim.cmd [[hi Normal guibg=NONE ctermbg=NONE]]
--
-- vim.cmd [[hi ModeMsg cterm=bold gui=bold guifg=#8577D9 guibg=NONE]]
-- vim.cmd [[hi LineNr guifg=#414160]]
-- vim.cmd [[hi EndOfBuffer guifg=black ctermfg=black]]
-- vim.cmd [[hi NvimTreeNormal guifg=#8677D9]]
-- vim.cmd [[highlight link NotifyINFOBorder Normal]]
--
-- vim.cmd [[highlight NotifyINFOBorder  guifg=#8677D9]]
-- vim.cmd [[highlight NotifyINFOTitle   guifg=#8677D9]]
-- vim.cmd [[highlight NotifyINFOBody    guifg=#8677D9]]
-- vim.cmd [[highlight NotifyINFOIcon    guifg=#8677D9]]
--
-- vim.cmd [[highlight NotifyERRORBorder guifg=#FF7AB2]]
-- vim.cmd [[highlight NotifyERRORTitle  guifg=#FF7AB2]]
-- vim.cmd [[highlight NotifyERRORBody   guifg=#FF7AB2]]
-- vim.cmd [[highlight NotifyERRORIcon   guifg=#FF7AB2]]
--
-- vim.cmd [[hi Normal guifg=#000000 guibg=NONE]]
--
-- --vim.cmd [[let g:indentLine_defaultGroup = 'NonText']]
-- --vim.cmd [[let g:indentLine_setColors = 1]]
--
-- vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = borderColor })
--
--
-- vim.cmd [[hi Cursor guifg=#000000 ctermfg=black]]
-- vim.cmd [[hi CursorLine guibg=None]]
-- vim.cmd [[hi CursorLineNR ctermfg=black guifg=#5D5DAF]]
-- vim.cmd [[hi TabLineFill gui=NONE]]
-- vim.cmd[[highlight Search ctermbg=0 guibg=#444444]]
-- vim.cmd[[highlight Visual ctermbg=0 guibg=#444444]]
-- vim.cmd[[highlight Todo   ctermbg=0 guifg=#df73ff]]
-- vim.cmd[[highlight StatusLine ctermbg=0 guibg=Normal]]
-- vim.cmd[[highlight StatusLineNC ctermbg=0 guibg=#444444]]
-- vim.cmd[[highlight Visual ctermbg=0 guibg=#444444]]

--vim.cmd[[hi Normal guibg=none ctermbg=none]]

-- hi Folded guibg=none ctermbg=none
-- hi NonText guibg=none ctermbg=none
-- hi SpecialKey guibg=none ctermbg=none
-- hi VertSplit guibg=none ctermbg=none
-- hi SignColumn guibg=none ctermbg=none]]


