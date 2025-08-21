-- This file is located at ~/.config/nvim/after/plugin/lsp.lua

-- First, make sure the necessary plugins are available
local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then
  return
end

local cmp_status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_status_ok then
  return
end

local function focus_hover()
  vim.lsp.buf.hover()
  -- This is a robust way to find and focus the hover window
  -- that works on older Neovim versions.
  for _, winid in ipairs(vim.api.nvim_list_wins()) do
    local bufnr = vim.api.nvim_win_get_buf(winid)
    -- LSP hover windows are typically 'nofile' buffers. This is how we find it.
    if vim.bo[bufnr].buftype == "nofile" then
      vim.api.nvim_set_current_win(winid)
      return
    end
  end
end

-- This on_attach function defines your keymaps
-- It will run once for each language server that starts
local on_attach = function(client, bufnr)
  local nmap = function(keys, func, desc)
    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
  end

  -- All your requested keymaps
  nmap("<leader>b", vim.lsp.buf.definition, "Go to Definition")
  nmap("<leader>vd", vim.diagnostic.open_float, "View Diagnostics")
  nmap("gI", vim.lsp.buf.implementation, "Go to Implementation")
  nmap("gD", vim.lsp.buf.type_definition, "Go to Type Definition")
  nmap("<leader>vk", vim.lsp.buf.hover, "Hover Docs")
  nmap("<leader>vK", focus_hover, "Hover Docs (Focus)")
  nmap("<leader>rn", vim.lsp.buf.rename, "Rename")
  nmap("<leader>ca", vim.lsp.buf.code_action, "Code Action")
end

-- The list of servers to configure
local servers = {
  "lua_ls",
  "pyright",
  "rust_analyzer",
  "vtsls",
  "eslint",
}

-- Get the default capabilities for autocompletion
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Loop through the servers and configure them with lspconfig
for _, server_name in ipairs(servers) do
  lspconfig[server_name].setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end
