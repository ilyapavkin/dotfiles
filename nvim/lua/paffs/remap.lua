vim.g.mapleader = " "

function Map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

local function disableArrows(mode)
  Map(mode, '<Up>', '<Nop>')
  Map(mode, '<Down>', '<Nop>')
  Map(mode, '<Left>', '<Nop>')
  Map(mode, '<Right>', '<Nop>')
end

disableArrows("n")
disableArrows("c")
disableArrows("v")
--disableArrows("i")


--vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("", "<ESC>u", "<cmd>nohlsearch<CR>")

-- window navigation
Map("n", "<C-h>", "<C-w>h")
Map("n", "<C-j>", "<C-w>j")
Map("n", "<C-k>", "<C-w>k")
Map("n", "<C-l>", "<C-w>l")

-- terminal
Map("t", "<C-h>", "<cmd>wincmd h<CR>")
Map("t", "<C-j>", "<cmd>wincmd j<CR>")
Map("t", "<C-k>", "<cmd>wincmd k<CR>")
Map("t", "<C-l>", "<cmd>wincmd l<CR>")

-- move vis block:
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- down 
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv") -- up
Map("v", "<", "<gv") -- tab left
Map("i", "<S-Tab>", "<cmd><gv<CR>") -- tab left
Map("v", ">", ">gv") -- tab right
