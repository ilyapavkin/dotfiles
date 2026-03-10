local local_plugins = {
	{
		"99",
		dir = "~/code/99",
		config = function()
			local _99 = require("99")
			_99.setup({
				provider = _99.Providers.QwenCLIProvider,
				show_in_flight_requests = true,
				md_files = {
					"AGENTS.md",
				},
				-- completion = {
				-- 	custom_rules = {
				-- 		"~/skills/",
				-- 	},
				-- 	source = "blink",
				-- },
				model = "qwen-coder-plus",
			})
			vim.keymap.set("n", "<leader>9s", function()
				_99.search()
			end, { desc = "99 search" })
			vim.keymap.set("v", "<leader>9vv", function()
				_99.visual()
			end, { desc = "99 visual" })
			vim.keymap.set("v", "<leader>9vp", function()
				_99.visual_prompt()
			end, { desc = "99 visual prompt" })
			vim.keymap.set("n", "<leader>9x", function()
				_99.stop_all_requests()
			end, { desc = "99 stop all" })
			vim.keymap.set("n", "<leader>9i", function()
				_99.info()
			end, { desc = "99 info" })
			vim.keymap.set("n", "<leader>9l", function()
				_99.view_logs()
			end, { desc = "99 view logs" })
			vim.keymap.set("n", "<leader>9n", function()
				_99.next_request_logs()
			end)
			vim.keymap.set("n", "<leader>9p", function()
				_99.prev_request_logs()
			end)
		end,
	},
}

return local_plugins
