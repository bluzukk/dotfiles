-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

local time
local profile_info
local should_profile = false
if should_profile then
  local hrtime = vim.loop.hrtime
  profile_info = {}
  time = function(chunk, start)
    if start then
      profile_info[chunk] = hrtime()
    else
      profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
    end
  end
else
  time = function(chunk, start) end
end

local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end
  if threshold then
    table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
  end

  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/bluzuk/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/bluzuk/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/bluzuk/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/bluzuk/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/bluzuk/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  Colorizer = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/Colorizer",
    url = "https://github.com/chrisbra/Colorizer"
  },
  ["Comment.nvim"] = {
    config = { "\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fComment\frequire\0" },
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/Comment.nvim",
    url = "https://github.com/numToStr/Comment.nvim"
  },
  ["FixCursorHold.nvim"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/FixCursorHold.nvim",
    url = "https://github.com/antoinemadec/FixCursorHold.nvim"
  },
  LuaSnip = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["auto-pairs"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/auto-pairs",
    url = "https://github.com/jiangmiao/auto-pairs"
  },
  ["bullets.vim"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/bullets.vim",
    url = "https://github.com/dkarter/bullets.vim"
  },
  catppuccin = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/catppuccin",
    url = "https://github.com/catppuccin/nvim"
  },
  chadtree = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/chadtree",
    url = "https://github.com/ms-jpq/chadtree"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-lua"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/cmp-nvim-lua",
    url = "https://github.com/hrsh7th/cmp-nvim-lua"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  cmp_luasnip = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip"
  },
  ["copilot.vim"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/copilot.vim",
    url = "https://github.com/github/copilot.vim"
  },
  ["dashboard-nvim"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/dashboard-nvim",
    url = "https://github.com/glepnir/dashboard-nvim"
  },
  edge = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/edge",
    url = "https://github.com/sainnhe/edge"
  },
  ["friendly-snippets"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/friendly-snippets",
    url = "https://github.com/rafamadriz/friendly-snippets"
  },
  indentLine = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/indentLine",
    url = "https://github.com/Yggdroot/indentLine"
  },
  inkpot = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/inkpot",
    url = "https://github.com/ciaranm/inkpot"
  },
  ["kanagawa.nvim"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/kanagawa.nvim",
    url = "https://github.com/rebelot/kanagawa.nvim"
  },
  ["limelight.vim"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/limelight.vim",
    url = "https://github.com/junegunn/limelight.vim"
  },
  ["lsp-zero.nvim"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/lsp-zero.nvim",
    url = "https://github.com/VonHeikemen/lsp-zero.nvim"
  },
  ["lualine.nvim"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/lualine.nvim",
    url = "https://github.com/nvim-lualine/lualine.nvim"
  },
  ["markdown-preview.nvim"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/markdown-preview.nvim",
    url = "https://github.com/iamcco/markdown-preview.nvim"
  },
  ["mason-lspconfig.nvim"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/mason-lspconfig.nvim",
    url = "https://github.com/williamboman/mason-lspconfig.nvim"
  },
  ["mason.nvim"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/mason.nvim",
    url = "https://github.com/williamboman/mason.nvim"
  },
  ["neovim-session-manager"] = {
    config = { "\27LJ\2\nù\3\0\0\n\0\20\0 6\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0029\1\3\0015\3\n\0\18\6\0\0009\4\4\0006\a\5\0009\a\6\a9\a\a\a'\t\b\0B\a\2\2'\b\t\0B\4\4\2=\4\v\0036\4\0\0'\6\f\0B\4\2\0029\4\r\0049\4\14\4=\4\15\0034\4\0\0=\4\16\0035\4\17\0=\4\18\0034\4\0\0=\4\19\3B\1\2\1K\0\1\0\29autosave_ignore_buftypes\30autosave_ignore_filetypes\1\2\0\0\14gitcommit\25autosave_ignore_dirs\18autoload_mode\16LastSession\17AutoloadMode\27session_manager.config\17sessions_dir\1\0\6\18path_replacer\a__\20max_path_length\3P\29autosave_only_in_session\2\31autosave_ignore_not_normal\2\26autosave_last_session\2\19colon_replacer\a++\rsessions\tdata\fstdpath\afn\bvim\bnew\nsetup\20session_manager\17plenary.path\frequire\0" },
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/neovim-session-manager",
    url = "https://github.com/Shatur/neovim-session-manager"
  },
  nerdcommenter = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/nerdcommenter",
    url = "https://github.com/scrooloose/nerdcommenter"
  },
  ["noice.nvim"] = {
    config = { "\27LJ\2\n­\2\0\0\5\0\n\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\4\0005\4\3\0=\4\5\3=\3\a\0025\3\b\0=\3\t\2B\0\2\1K\0\1\0\fpresets\1\0\5\19lsp_doc_border\1\15inc_rename\1\26long_message_to_split\2\20command_palette\1\18bottom_search\2\blsp\1\0\0\roverride\1\0\0\1\0\0031vim.lsp.util.convert_input_to_markdown_lines\2 cmp.entry.get_documentation\2\"vim.lsp.util.stylize_markdown\2\nsetup\nnoice\frequire\0" },
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/noice.nvim",
    url = "https://github.com/folke/noice.nvim"
  },
  ["nui.nvim"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/nui.nvim",
    url = "https://github.com/MunifTanjim/nui.nvim"
  },
  ["nvim-cmp"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-cokeline"] = {
    config = { "\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\rcokeline\frequire\0" },
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/nvim-cokeline",
    url = "https://github.com/noib3/nvim-cokeline"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-notify"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/nvim-notify",
    url = "https://github.com/rcarriga/nvim-notify"
  },
  ["nvim-scrollbar"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/nvim-scrollbar",
    url = "https://github.com/petertriho/nvim-scrollbar"
  },
  ["nvim-tree.lua"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/nvim-tree.lua",
    url = "https://github.com/nvim-tree/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["papercolor-theme"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/papercolor-theme",
    url = "https://github.com/NLKNguyen/papercolor-theme"
  },
  playground = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/playground",
    url = "https://github.com/nvim-treesitter/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  purify = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/purify",
    url = "https://github.com/kyoz/purify"
  },
  pywal = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/pywal",
    url = "https://github.com/AlphaTechnolog/pywal.nvim"
  },
  ["rainbow_parentheses.vim"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/rainbow_parentheses.vim",
    url = "https://github.com/junegunn/rainbow_parentheses.vim"
  },
  shadotheme = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/shadotheme",
    url = "https://github.com/Shadorain/shadotheme"
  },
  ["space-vim-theme"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/space-vim-theme",
    url = "https://github.com/liuchengxu/space-vim-theme"
  },
  spaceduck = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/spaceduck",
    url = "https://github.com/pineapplegiant/spaceduck"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["todo-comments.nvim"] = {
    config = { "\27LJ\2\n?\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\18todo-comments\frequire\0" },
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/todo-comments.nvim",
    url = "https://github.com/folke/todo-comments.nvim"
  },
  ["tokyonight.nvim"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/tokyonight.nvim",
    url = "https://github.com/folke/tokyonight.nvim"
  },
  ["vCoolor.vim"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/vCoolor.vim",
    url = "https://github.com/KabbAmine/vCoolor.vim"
  },
  vim = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/vim",
    url = "https://github.com/dracula/vim"
  },
  ["vim-abolish"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/vim-abolish",
    url = "https://github.com/tpope/vim-abolish"
  },
  ["vim-closetag"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/vim-closetag",
    url = "https://github.com/alvan/vim-closetag"
  },
  ["vim-easy-align"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/vim-easy-align",
    url = "https://github.com/junegunn/vim-easy-align"
  },
  ["vim-journal"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/vim-journal",
    url = "https://github.com/junegunn/vim-journal"
  },
  ["vim-moonfly-colors"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/vim-moonfly-colors",
    url = "https://github.com/bluz71/vim-moonfly-colors"
  },
  ["vim-signify"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/vim-signify",
    url = "https://github.com/mhinz/vim-signify"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/vim-surround",
    url = "https://github.com/tpope/vim-surround"
  },
  ["vim-transparent"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/vim-transparent",
    url = "https://github.com/tribela/vim-transparent"
  },
  ["vim-vice"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/vim-vice",
    url = "https://github.com/bcicen/vim-vice"
  },
  vimtex = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/vimtex",
    url = "https://github.com/lervag/vimtex"
  },
  ["wal.vim"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/wal.vim",
    url = "https://github.com/dylanaraps/wal.vim"
  },
  ["which-key.nvim"] = {
    config = { "\27LJ\2\nt\0\0\3\0\a\0\0156\0\0\0009\0\1\0+\1\2\0=\1\2\0006\0\0\0009\0\1\0)\1,\1=\1\3\0006\0\4\0'\2\5\0B\0\2\0029\0\6\0004\2\0\0B\0\2\1K\0\1\0\nsetup\14which-key\frequire\15timeoutlen\ftimeout\6o\bvim\0" },
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/which-key.nvim",
    url = "https://github.com/folke/which-key.nvim"
  },
  ["xresources-nvim"] = {
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/xresources-nvim",
    url = "https://github.com/nekonako/xresources-nvim"
  },
  ["zen-mode.nvim"] = {
    config = { "\27LJ\2\n^\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\foptions\1\0\0\1\0\1\17cursorcolumn\1\nsetup\rzen-mode\frequire\0" },
    loaded = true,
    path = "/home/bluzuk/.local/share/nvim/site/pack/packer/start/zen-mode.nvim",
    url = "https://github.com/folke/zen-mode.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: todo-comments.nvim
time([[Config for todo-comments.nvim]], true)
try_loadstring("\27LJ\2\n?\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\18todo-comments\frequire\0", "config", "todo-comments.nvim")
time([[Config for todo-comments.nvim]], false)
-- Config for: zen-mode.nvim
time([[Config for zen-mode.nvim]], true)
try_loadstring("\27LJ\2\n^\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\foptions\1\0\0\1\0\1\17cursorcolumn\1\nsetup\rzen-mode\frequire\0", "config", "zen-mode.nvim")
time([[Config for zen-mode.nvim]], false)
-- Config for: noice.nvim
time([[Config for noice.nvim]], true)
try_loadstring("\27LJ\2\n­\2\0\0\5\0\n\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\4\0005\4\3\0=\4\5\3=\3\a\0025\3\b\0=\3\t\2B\0\2\1K\0\1\0\fpresets\1\0\5\19lsp_doc_border\1\15inc_rename\1\26long_message_to_split\2\20command_palette\1\18bottom_search\2\blsp\1\0\0\roverride\1\0\0\1\0\0031vim.lsp.util.convert_input_to_markdown_lines\2 cmp.entry.get_documentation\2\"vim.lsp.util.stylize_markdown\2\nsetup\nnoice\frequire\0", "config", "noice.nvim")
time([[Config for noice.nvim]], false)
-- Config for: neovim-session-manager
time([[Config for neovim-session-manager]], true)
try_loadstring("\27LJ\2\nù\3\0\0\n\0\20\0 6\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0029\1\3\0015\3\n\0\18\6\0\0009\4\4\0006\a\5\0009\a\6\a9\a\a\a'\t\b\0B\a\2\2'\b\t\0B\4\4\2=\4\v\0036\4\0\0'\6\f\0B\4\2\0029\4\r\0049\4\14\4=\4\15\0034\4\0\0=\4\16\0035\4\17\0=\4\18\0034\4\0\0=\4\19\3B\1\2\1K\0\1\0\29autosave_ignore_buftypes\30autosave_ignore_filetypes\1\2\0\0\14gitcommit\25autosave_ignore_dirs\18autoload_mode\16LastSession\17AutoloadMode\27session_manager.config\17sessions_dir\1\0\6\18path_replacer\a__\20max_path_length\3P\29autosave_only_in_session\2\31autosave_ignore_not_normal\2\26autosave_last_session\2\19colon_replacer\a++\rsessions\tdata\fstdpath\afn\bvim\bnew\nsetup\20session_manager\17plenary.path\frequire\0", "config", "neovim-session-manager")
time([[Config for neovim-session-manager]], false)
-- Config for: nvim-cokeline
time([[Config for nvim-cokeline]], true)
try_loadstring("\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\rcokeline\frequire\0", "config", "nvim-cokeline")
time([[Config for nvim-cokeline]], false)
-- Config for: which-key.nvim
time([[Config for which-key.nvim]], true)
try_loadstring("\27LJ\2\nt\0\0\3\0\a\0\0156\0\0\0009\0\1\0+\1\2\0=\1\2\0006\0\0\0009\0\1\0)\1,\1=\1\3\0006\0\4\0'\2\5\0B\0\2\0029\0\6\0004\2\0\0B\0\2\1K\0\1\0\nsetup\14which-key\frequire\15timeoutlen\ftimeout\6o\bvim\0", "config", "which-key.nvim")
time([[Config for which-key.nvim]], false)
-- Config for: Comment.nvim
time([[Config for Comment.nvim]], true)
try_loadstring("\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fComment\frequire\0", "config", "Comment.nvim")
time([[Config for Comment.nvim]], false)

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
