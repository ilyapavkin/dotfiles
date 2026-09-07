vim.g.mapleader = " "

function Map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

local function disableArrows(mode)
	Map(mode, "<Up>", "<Nop>")
	Map(mode, "<Down>", "<Nop>")
	Map(mode, "<Left>", "<Nop>")
	Map(mode, "<Right>", "<Nop>")
end

disableArrows("n")
disableArrows("c")
disableArrows("v")
--disableArrows("i")

--vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("", "<ESC>u", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-f>", "<C-f>zz")
vim.keymap.set("n", "<C-b>", "<C-b>zz")

-- window navigation
Map("n", "<M-h>", "<C-w>h")
Map("n", "<M-j>", "<C-w>j")
Map("n", "<M-k>", "<C-w>k")
Map("n", "<M-l>", "<C-w>l")
vim.opt.splitright = true
vim.opt.splitbelow = true
Map("n", "<M-S-'>", "<cmd>sp .<CR>")
Map("n", "<M-S-5>", ":vsplit .<CR>")

-- terminal
Map("t", "<M-h>", "<cmd>wincmd h<CR>")
Map("t", "<M-j>", "<cmd>wincmd j<CR>")
Map("t", "<M-k>", "<cmd>wincmd k<CR>")
Map("t", "<M-l>", "<cmd>wincmd l<CR>")

-- move vis block:
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- down
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv") -- up
Map("v", "<", "<gv") -- tab left
Map("v", ">", ">gv") -- tab right

-- yank/put outside
Map("v", "<C-S-c>", "+y")
Map("v", "<C-S-v>", "+p")

-- Panic
Map("n", "<leader>qqq", ":bd|e#|bd#")
