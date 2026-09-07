return {
	{
		"tris203/precognition.nvim",
		dependencies = { "chrisgrieser/nvim-spider" },
		opts = {
			showBlankVirtLine = false,
			hints = {
				Caret = { text = "^", prio = 0 },
				Dollar = { text = "$", prio = 0 },
				MatchingPair = { text = "%", prio = 0 },
				Zero = { text = "0", prio = 0 },
				w = { text = "w", prio = 0 },
				b = { text = "b", prio = 0 },
				e = { text = "e", prio = 0 },
				W = { text = "W", prio = 0 },
				B = { text = "B", prio = 0 },
				E = { text = "E", prio = 0 },
			},
		},
		keys = {
			{ "<leader>??", ":Precognition toggle<CR>", mode = { "n" } },
		},
	},
	{
		"chrisgrieser/nvim-spider",
		keys = {
			{ "w", "<cmd>lua require('spider').motion('w')<CR>", mode = { "n", "o", "x" } },
			{ "e", "<cmd>lua require('spider').motion('e')<CR>", mode = { "n", "o", "x" } },
			{ "b", "<cmd>lua require('spider').motion('b')<CR>", mode = { "n", "o", "x" } },
			{ "ge", "<cmd>lua require('spider').motion('ge')<CR>", mode = { "n", "o", "x" } },
			{ "<C-f>", "<Esc>l<cmd>lua require('spider').motion('w')<CR>i", mode = { "i" } },
			{ "<C-b>", "<Esc><cmd>lua require('spider').motion('b')<CR>i", mode = { "i" } },
		},
		lazy = true,
	},
}
