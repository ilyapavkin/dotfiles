function ColorMyPencils(color)
  color = color or "rose-pine"
  vim.cmd.colorscheme(color)

--  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
--  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ColorMyPencils()

-- Define the custom highlight group
-- bg sets the background color (e.g., a shade of blue: "#ADD8E6")
-- fg sets the foreground/text color (e.g., black: "#000000")
-- vim.api.nvim_set_hl(0, "YankHighlight", { bg = "#ADD8E6", fg = "#000000" })

