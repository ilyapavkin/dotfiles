return {
	{
		"andythigpen/nvim-coverage",
		version = "*",
		config = function()
			local function find_lcov()
				local result = vim.fs.find("coverage/lcov.info", {
					upward = true,
					path = vim.fn.expand("%:p:h"),
					stop = vim.fn.systemlist("git rev-parse --show-toplevel")[1],
				})

				print(result[1])

				return result[1]
			end
			require("coverage").setup({
				auto_reload = true,
				commands = true, -- create commands
				highlights = {
					-- customize highlight groups created by the plugin
					covered = { fg = "#C3E88D" }, -- supports style, fg, bg, sp (see :h highlight-gui)
					uncovered = { fg = "#F07178" },
				},
				signs = {
					-- use your own highlight groups or text markers
					covered = { hl = "CoverageCovered", text = "▎" },
					uncovered = { hl = "CoverageUncovered", text = "▎" },
				},
				summary = {
					-- customize the summary pop-up
					min_coverage = 80.0, -- minimum coverage threshold (used for highlighting)
				},
				lang = {
					javascript = { coverage_file = find_lcov },
					typescript = { coverage_file = find_lcov },
					javascriptreact = { coverage_file = find_lcov },
					typescriptreact = { coverage_file = find_lcov },
				},
			})
		end,
	},
}
