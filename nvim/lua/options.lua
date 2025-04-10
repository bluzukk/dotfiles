require "nvchad.options"

local cmd = vim.cmd

local o = vim.o
o.cursorlineopt ='both' -- to enable cursorline!

-- vim.cmd([[vimtex_compiler_method = 'latexrun']])

cmd("set list")
cmd([[match errorMsg /\s\+$/]])

-- Disable autowrap
cmd("set nowrap")
cmd("set formatoptions-=t")


-- cmd("autocmd BufWritePost *.md make")

-- Remove trailing space on save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})
