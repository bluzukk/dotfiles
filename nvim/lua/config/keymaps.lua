-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.g.vimtex_view_method = "mupdf"
vim.g.vimtex_compiler_method = "latexrun"

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- VimTex
vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>wincmd p<CR>")
vim.keymap.set({ "n", "v" }, "<F25>", "<cmd>VimtexTocToggle<CR>")
vim.keymap.set({ "n", "v" }, "<F26>", "<cmd>SessionManager load_session<CR>")

-- LSP
vim.keymap.set("n", "<F7>", "<cmd>LspStop<CR><cmd>echo 'Stopped LSP =('<CR>")
vim.keymap.set("n", "<F8>", "<cmd>LspStart<CR><cmd>echo 'Started LSP :)' <CR>")

-- VSplit Settings / Resize
vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>wincmd p<CR>")
vim.keymap.set({ "n", "v" }, "<C-Left>", "<cmd>2winc <<CR>")
vim.keymap.set({ "n", "v" }, "<C-Right>", "<cmd>2winc ><CR>")

-- NvimTree
vim.keymap.set({ "n", "v", "i" }, "<F1>", "<cmd>Neotree<CR>")

-- ZenMode
vim.keymap.set("n", "<F5>", "<cmd>ZenMode<CR>")

-- xd
vim.keymap.set("n", "<C-s>", "<cmd>w<CR>")
vim.keymap.set("n", "<F12>", "<cmd>Mason<CR>")
vim.keymap.set("n", "<F11>", "<cmd>Masonlog<CR>")

vim.keymap.set({ "n", "v" }, "<Tab>", "<cmd>bnext<CR>")
vim.keymap.set({ "n", "v" }, "<C-Tab>", "<cmd>split<CR>")

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Telescope
-- local builtin = require("telescope.")
-- vim.keymap.set("n", "<leader>fg", builtin.find_files, {})
-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
-- vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
