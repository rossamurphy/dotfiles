-- Auto-install formatters and linters with Mason
require("mason").setup()

-- This ensures formatters and tools are installed
local registry = require("mason-registry")

local ensure_installed = {
	"ruff",     -- Python formatter and linter
	"black",    -- Python formatter (fallback)
	"isort",    -- Python import sorter (fallback)
	"stylua",   -- Lua formatter
	"prettier", -- JS/TS/JSON formatter
	"prettierd", -- Faster prettier daemon
	"goimports", -- Go imports formatter
	"gofmt",    -- Go formatter
	"codespell", -- Spell checker for code
}

registry.refresh(function()
	for _, tool in ipairs(ensure_installed) do
		local p = registry.get_package(tool)
		if not p:is_installed() then
			p:install()
		end
	end
end)
