require("conform").setup({
	-- Map of filetype to formatters
	formatters_by_ft = {
		lua = { "stylua" },
		go = { "goimports", "gofmt" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		python = function(bufnr)
			if require("conform").get_formatter_info("ruff_format", bufnr).available then
				return { "ruff_format" }
			else
				return { "isort", "black" }
			end
		end,
		["*"] = { "codespell" },
		["_"] = { "trim_whitespace" },
	},
	format_on_save = function(bufnr)
		-- Disable autoformat on save if no formatters are available
		local available = require("conform").list_formatters(bufnr)
		if #available == 0 then
			return nil
		end
		return {
			lsp_format = "fallback",
			timeout_ms = 500,
		}
	end,
	format_after_save = {
		lsp_format = "fallback",
	},
	log_level = vim.log.levels.ERROR,
	notify_on_error = false, -- Set to false to avoid annoying errors
	formatters = {
		ruff_format = {
			command = "ruff",
			args = {
				"format",
				"--stdin-filename",
				"$FILENAME",
				"-",
			},
			stdin = true,
			cwd = require("conform.util").root_file({ "pyproject.toml", "ruff.toml", ".ruff.toml" }),
			require_cwd = false, -- Don't require cwd to be found
		},
	},
})

-- Add a command to check formatter status
vim.api.nvim_create_user_command("ConformStatus", function()
	local formatters = require("conform").list_formatters(0)
	if #formatters == 0 then
		vim.notify("No formatters available for this filetype", vim.log.levels.WARN)
	else
		local names = vim.tbl_map(function(f)
			return f.name
		end, formatters)
		vim.notify("Available formatters: " .. table.concat(names, ", "), vim.log.levels.INFO)
	end
end, {})
