--- @brief
---
--- https://github.com/hrsh7th/vscode-langservers-extracted
---
--- `vscode-eslint-language-server` is a linting engine for JavaScript / Typescript.
--- It can be installed via `npm`:
---
--- ```sh
--- npm i -g vscode-langservers-extracted
--- ```
---
--- The default `on_attach` config provides the `LspEslintFixAll` command that can be used to format a document on save:
--- ```lua
--- local base_on_attach = vim.lsp.config.eslint.on_attach
--- vim.lsp.config("eslint", {
---   on_attach = function(client, bufnr)
---     if not base_on_attach then return end
---
---     base_on_attach(client, bufnr)
---     vim.api.nvim_create_autocmd("BufWritePre", {
---       buffer = bufnr,
---       command = "LspEslintFixAll",
---     })
---   end,
--- })
--- ```
---
--- See [vscode-eslint](https://github.com/microsoft/vscode-eslint/blob/55871979d7af184bf09af491b6ea35ebd56822cf/server/src/eslintServer.ts#L216-L229) for configuration options.
---
--- Messages handled in lspconfig: `eslint/openDoc`, `eslint/confirmESLintExecution`, `eslint/probeFailed`, `eslint/noLibrary`
---
--- Additional messages you can handle: `eslint/noConfig`
---
--- ### Monorepo support
---
--- `vscode-eslint-language-server` supports monorepos by default. It will automatically find the config file corresponding to the package you are working on. You can use different configs in different packages.
--- This works without the need of spawning multiple instances of `vscode-eslint-language-server`.
--- You can use a different version of ESLint in each package, but it is recommended to use the same version of ESLint in all packages. The location of the ESLint binary will be determined automatically.
---
--- /!\ When using flat config files, you need to use them across all your packages in your monorepo, as it's a global setting for the server.
-- Install vscode-eslint-language-server
return {
  cmd = { '/usr/bin/node', vim.fn.exepath('vscode-eslint-language-server'), '--stdio' },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "graphql" },
	root_markers = { ".eslintrc", ".eslintrc.js", ".eslintrc.json", "eslint.config.js", "eslint.config.mjs" },
	settings = {
		validate = "on",
		packageManager = vim.NIL,
		useESLintClass = false,
		experimental = { useFlatConfig = false },
		codeActionOnSave = { enable = false, mode = "all" },
		format = false,
		quiet = false,
		onIgnoredFiles = "off",
		options = {},
		rulesCustomizations = {},
		run = "onType",
		problems = { shortenToSingleLine = false },
		nodePath = "",
		workingDirectory = { mode = "location" },
		codeAction = {
			disableRuleComment = { enable = true, location = "separateLine" },
			showDocumentation = { enable = true },
		},
	},
	before_init = function(params, config)
		-- Set the workspace folder setting for correct search of tsconfig.json files etc.
		config.settings.workspaceFolder = {
			uri = params.rootPath,
			name = vim.fn.fnamemodify(params.rootPath, ":t"),
		}
	end,
	---@type table<string, lsp.Handler>
	handlers = {
		["eslint/openDoc"] = function(_, params)
			vim.ui.open(params.url)
			return {}
		end,
		["eslint/probeFailed"] = function()
			vim.notify("LSP[eslint]: Probe failed.", vim.log.levels.WARN)
			return {}
		end,
		["eslint/noLibrary"] = function()
			vim.notify("LSP[eslint]: Unable to load ESLint library.", vim.log.levels.WARN)
			return {}
		end,
		["eslint/confirmESLintExecution"] = function(_, result)
			if not result then
				return
			end
			return 4 -- approved
		end,
	},
}
