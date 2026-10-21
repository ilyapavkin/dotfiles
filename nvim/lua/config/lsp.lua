vim.lsp.enable({
  "lua_ls",
--  "ts_ls",
  "cssls",
--  "eslint"
})

vim.opt.updatetime = 500

local function close_info_popups()
  pcall(function()
    require("blink.cmp").hide()
  end)

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_config(win).relative ~= "" then
      vim.api.nvim_win_close(win, true)
    end
  end
end

local function cycle_info_popups()
  local states = { "completion", "hover", "signature", "off" }
  local state_key = "info_popup_state_insert"
  vim.b[state_key] = (vim.b[state_key] or 0) % #states + 1
  local state = states[vim.b[state_key]]

  close_info_popups()

  if state == "completion" then
    require("blink.cmp").show({ initial_selected_item_idx = 1 })
  elseif state == "hover" then
    vim.lsp.buf.hover()
  elseif state == "signature" then
    vim.lsp.buf.signature_help()
  end
end

local function toggle_auto_hover()
  vim.b.info_hover_enabled = vim.b.info_hover_enabled == false
  close_info_popups()
end

vim.api.nvim_create_autocmd("CursorHold", {
  desc = "Show LSP hover information",
  callback = function(args)
    if vim.api.nvim_get_current_buf() ~= args.buf or vim.api.nvim_get_mode().mode ~= "n" then
      return
    end

    for _, client in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
      if client.server_capabilities.documentHighlightProvider then
        vim.lsp.buf.document_highlight()
        break
      end
    end

    if vim.b.info_hover_enabled ~= false then
      vim.lsp.buf.hover()
    end
  end,
})

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
  desc = "Clear LSP reference highlights",
  callback = function(args)
    if vim.api.nvim_get_current_buf() == args.buf then
      vim.lsp.buf.clear_references()
    end
  end,
})

vim.keymap.set("n", "<C-Space>", toggle_auto_hover, {
  desc = "Toggle automatic LSP hover",
  silent = true,
})

vim.keymap.set("i", "<C-Space>", cycle_info_popups, {
  desc = "Cycle completion, hover, signature help, off",
  silent = true,
})

vim.diagnostic.config({
--  virtual_lines = true,
  virtual_text = true,
  underline = true,
  update_in_insert = true,
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "ErrorMsg",
      [vim.diagnostic.severity.WARN] = "WarningMsg",
    },
  },
})
