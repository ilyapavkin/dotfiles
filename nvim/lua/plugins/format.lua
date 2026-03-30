return {
	{
		"stevearc/conform.nvim",
		opts = {},
		config = function()
			require("conform").setup({
				format_on_save = {
					timeout_ms = 500,
					lsp_format = "fallback",
				},
				formatters_by_ft = {
					c = { "clang-format" },
					cpp = { "clang-format" },
					lua = { "stylua" },
					go = { "gofmt" },
					javascript = { "prettierd", "eslint_d" },
					javascriptreact = { "prettierd", "eslint_d" },
					typescript = { "prettierd", "eslint_d" },
					typescriptreact = { "prettierd", "eslint_d" },
					json = { "prettierd", "eslint_d" },
				},
				formatters = {
					["clang-format"] = {
						prepend_args = { "-style=file", "-fallback-style=LLVM" },
					},
				},
			})

			vim.keymap.set("n", "<leader>f", function()
				require("conform").format({ bufnr = 0 })
			end)
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
	{
		"m4xshen/autoclose.nvim",
		opts = {
			disabled_filetypes = { "text", "markdown" },
		},
	},
}
