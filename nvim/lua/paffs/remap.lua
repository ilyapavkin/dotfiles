local function disableArrows(mode)
  vim.keymap.set(mode, "<Up>", "<Nop>", {noremap = true, silent = true})
  vim.keymap.set(mode, "<Down>", "<Nop>", {noremap = true, silent = true})
  vim.keymap.set(mode, "<Left>", "<Nop>", {noremap = true, silent = true})
  vim.keymap.set(mode, "<Right>", "<Nop>", {noremap = true, silent = true})
end

disableArrows("n")
disableArrows("c")
disableArrows("v")
--disableArrows("i")

vim.g.mapleader = " "
--vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)


