vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.clipboard = "unnamedplus"

vim.opt.mouse = "a"

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.termguicolors = true

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.g.mapleader = " "

-- Save
vim.keymap.set("n", "<leader>w", ":w<CR>")

-- Quit
vim.keymap.set("n", "<leader>q", ":q<CR>")

-- Save and quit
vim.keymap.set("n", "<leader>x", ":x<CR>")

-- Better window movement
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")