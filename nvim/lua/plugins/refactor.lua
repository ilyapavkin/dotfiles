return {
	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		lazy = false,
		opts = {},
		config = function()
			vim.keymap.set("x", "<leader>re", ":Refactor extract ")
			vim.keymap.set("x", "<leader>rf", ":Refactor extract_to_file ")

			vim.keymap.set("x", "<leader>rv", ":Refactor extract_var ")

			vim.keymap.set({ "n", "x" }, "<leader>ri", ":Refactor inline_var")

			vim.keymap.set("n", "<leader>rI", ":Refactor inline_func")

			vim.keymap.set("n", "<leader>rb", ":Refactor extract_block")
			vim.keymap.set("n", "<leader>rbf", ":Refactor extract_block_to_file")

			vim.keymap.set("n", "<leader>rn", function()
				vim.api.nvim_create_autocmd({ "CmdlineEnter" }, {
					callback = function()
						local key = vim.api.nvim_replace_termcodes("<C-f>", true, false, true)
						vim.api.nvim_feedkeys(key, "c", false)
						vim.api.nvim_feedkeys("0", "n", false)
						return true
					end,
				})
				vim.lsp.buf.rename()
			end)
		end,
	},
}
