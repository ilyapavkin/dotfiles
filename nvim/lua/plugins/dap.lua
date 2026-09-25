return {
	-- Debug Adapter Protocol
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			-- DAP UI
			{
				"rcarriga/nvim-dap-ui",
				dependencies = {
					"nvim-neotest/nvim-nio",
				},
				config = function()
					local dap = require("dap")
					local dapui = require("dapui")

					dapui.setup()

					-- Open UI when debugging starts
					dap.listeners.after.event_initialized["dapui_config"] = function()
						dapui.open()
					end

					-- Close UI when debugging ends
					dap.listeners.before.event_terminated["dapui_config"] = function()
						dapui.close()
					end

					dap.listeners.before.event_exited["dapui_config"] = function()
						dapui.close()
					end
				end,

				keys = {
					{
						"<leader>du",
						function()
							require("dapui").toggle()
						end,
						desc = "Toggle DAP UI",
					},
					{
						"<leader>de",
						function()
							require("dapui").eval()
						end,
						mode = { "n", "v" },
						desc = "Evaluate expression",
					},
				},
			},

			-- Inline variable values
			{
				"theHamsta/nvim-dap-virtual-text",
				config = function()
					require("nvim-dap-virtual-text").setup({
						enabled = true,
						enabled_commands = true,

						highlight_changed_variables = true,
						highlight_new_as_changed = false,

						show_stop_reason = true,

						commented = false,

						only_first_definition = true,
						all_references = false,

						virt_text_pos = "eol",

						all_frames = false,
						virt_lines = false,
					})
				end,
			},
		},

		keys = {
			{
				"<F5>",
				function()
					require("dap").continue()
				end,
				desc = "Debug: Continue",
			},
			{
				"<F10>",
				function()
					require("dap").step_over()
				end,
				desc = "Debug: Step over",
			},
			{
				"<F11>",
				function()
					require("dap").step_into()
				end,
				desc = "Debug: Step into",
			},
			{
				"<F12>",
				function()
					require("dap").step_out()
				end,
				desc = "Debug: Step out",
			},
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Debug: Toggle breakpoint",
			},
			{
				"<leader>dB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "Debug: Conditional breakpoint",
			},
			{
				"<leader>dr",
				function()
					require("dap").repl.open()
				end,
				desc = "Debug: REPL",
			},
			{
				"<leader>dq",
				function()
					require("dap").terminate()
				end,
				desc = "Debug: Terminate",
			},
		},

		config = function()
			local dap = require("dap")

			-- Breakpoint signs
			vim.fn.sign_define("DapBreakpoint", {
				text = "●",
				texthl = "DiagnosticSignError",
				linehl = "",
				numhl = "",
			})

			vim.fn.sign_define("DapBreakpointCondition", {
				text = "◆",
				texthl = "DiagnosticSignWarn",
				linehl = "",
				numhl = "",
			})

			vim.fn.sign_define("DapStopped", {
				text = "▶",
				texthl = "DiagnosticSignInfo",
				linehl = "DapStoppedLine",
				numhl = "",
			})

			vim.api.nvim_set_hl(0, "DapStoppedLine", {
				link = "Visual",
			})
		end,
	},
}
