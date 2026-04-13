-- This file is located at ~/.config/nvim/after/plugin/lsp.lua

local cmp_status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_status_ok then
	return
end

local function focus_hover()
	vim.lsp.buf.hover()
	for _, winid in ipairs(vim.api.nvim_list_wins()) do
		local bufnr = vim.api.nvim_win_get_buf(winid)
		if vim.bo[bufnr].buftype == "nofile" then
			vim.api.nvim_set_current_win(winid)
			return
		end
	end
end

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local bufnr = args.buf
		local nmap = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
		end

		nmap("<leader>b", vim.lsp.buf.definition, "Go to Definition")
		nmap("<leader>vd", vim.diagnostic.open_float, "View Diagnostics")
		nmap("gI", vim.lsp.buf.implementation, "Go to Implementation")
		nmap("gD", vim.lsp.buf.type_definition, "Go to Type Definition")
		nmap("<leader>vk", vim.lsp.buf.hover, "Hover Docs")
		nmap("<leader>vK", focus_hover, "Hover Docs (Focus)")
		nmap("<leader>rn", vim.lsp.buf.rename, "Rename")
		nmap("<leader>ca", vim.lsp.buf.code_action, "Code Action")
	end,
})

vim.lsp.config("*", {
	capabilities = cmp_nvim_lsp.default_capabilities(),
})

vim.lsp.enable({
	"lua_ls",
	"pyright",
	"rust_analyzer",
	"vtsls",
	"eslint",
	"gopls",
})
