-- Auto-install formatters via Mason
-- This ensures formatters are available across different environments

-- First ensure mason is loaded
local mason_ok, mason = pcall(require, "mason")
if not mason_ok then
	return
end

-- Load mason-registry to install formatters
local mason_registry = require("mason-registry")

-- List of formatters to ensure are installed
local formatters_to_install = {
	"ruff", -- Python linter and formatter
	"black", -- Python formatter
	"isort", -- Python import sorter
	"stylua", -- Lua formatter
	"prettier", -- JS/TS/CSS/HTML formatter
	"prettierd", -- Faster prettier daemon
	"gofmt", -- Go formatter
	"goimports", -- Go imports formatter
	"codespell", -- Spell checker for code
}

-- Function to check and install formatters
local function ensure_installed()
	for _, formatter in ipairs(formatters_to_install) do
		local package = mason_registry.get_package(formatter)
		if not package:is_installed() then
			vim.notify("Installing " .. formatter .. "...", vim.log.levels.INFO)
			package:install()
		end
	end
end

-- Check on startup
mason_registry.refresh(function()
	ensure_installed()
end)

-- Also add command to manually trigger installation
vim.api.nvim_create_user_command("MasonInstallFormatters", function()
	ensure_installed()
	vim.notify("Formatter installation triggered", vim.log.levels.INFO)
end, {})
