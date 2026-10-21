return {
	{
		"mason-org/mason.nvim",
		dependencies = {
			"artemave/workspace-diagnostics.nvim",
		},
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
			servers = {
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" },
							},
						},
					},
				},
			},
		},
		config = function(_, opts)
			require("mason").setup()
			for server, config in pairs(opts.servers) do
				vim.lsp.config(server, config)
				vim.lsp.enable(server)
			end
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		config = true,
		opts = {
			ensure_installed = { "lua_ls", "cssls", "eslint" },
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		config = true,
		opts = {},
		dependencies = {
			"neovim/nvim-lspconfig",
		},
	},
}
