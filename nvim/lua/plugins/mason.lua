return {
	{
		"mason-org/mason.nvim",
		config = true,
		opts = {},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		config = true,
		opts = {
			ensure_installed = { "lua_ls", "cssls" },
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
