return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "v0.2.1",
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- optional but recommended
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-telescope/telescope-ui-select.nvim",
		},
		lazy = false,
		config = function()
			require("telescope").setup()
			-- require("telescope").setup({
			-- extensions = {
			-- 	["ui-select"] = {
			-- 		require("telescope.themes").get_dropdowm({
			-- 			-- todo:
			-- 		}),
			-- 	},
			-- },
			-- })
			require("telescope").load_extension("ui-select")

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
			vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Telescope find files in git" })
			vim.keymap.set("n", "<leader>fs", function()
				builtin.grep_string({ search = vim.fn.input("Grep > ") })
			end, { desc = "Telescope grep string" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
			vim.keymap.set("n", "<leader>vh", builtin.help_tags, { desc = "Telescope help tags" })
			-- vim.keymap.set("n", "<leader>fe", builtin.file_browser, { desc = "Telescope file browser" })
			vim.keymap.set("n", "<leader>ca", function()
				vim.lsp.buf.code_action({ apply = true })
			end, { desc = "Telescope code actions" })
			vim.keymap.set("n", "<leader>td", ":TodoTelescope<CR>", { desc = "Telescope todo" })
		end,
	},
}
