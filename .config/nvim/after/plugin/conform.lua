require("conform").setup({
	-- Map of filetype to formatters
	formatters_by_ft = {
		lua = { "stylua" },
		-- Conform will run multiple formatters sequentially
		go = { "goimports", "gofmt" },
		-- Use a sub-list to run only the first available formatter
		javascript = { "prettierd", "prettier", stop_after_first = true },
		-- You can use a function here to determine the formatters dynamically
		python = function(bufnr)
			if require("conform").get_formatter_info("ruff_format", bufnr).available then
				-- TODO - check for ruff_lint_fix also
				return { "ruff_lint_fix", "ruff_format" }
			else
				return { "isort", "black" }
			end
		end,
		-- Use the "*" filetype to run formatters on all filetypes.
		["*"] = { "codespell" },
		-- Use the "_" filetype to run formatters on filetypes that don't
		-- have other formatters configured.
		["_"] = { "trim_whitespace" },
	},
	-- If this is set, Conform will run the formatter on save.
	-- It will pass the table to conform.format().
	-- This can also be a function that returns the table.
	format_on_save = {
		-- I recommend these options. See :help conform.format for details.
		lsp_format = "fallback",
		timeout_ms = 500,
	},
	-- If this is set, Conform will run the formatter asynchronously after save.
	-- It will pass the table to conform.format().
	-- This can also be a function that returns the table.
	format_after_save = {
		lsp_format = "fallback",
	},
	-- Set the log level. Use `:ConformInfo` to see the location of the log file.
	log_level = vim.log.levels.ERROR,
	-- Conform will notify you when a formatter errors
	notify_on_error = true,
	-- Custom formatters and overrides for built-in formatters
	formatters = {
		ruff_format = {
			-- This can be a string or a function that returns a string.
			-- When defining a new formatter, this is the only field that is required
			command = "ruff",
			-- A list of strings, or a function that returns a list of strings
			-- Return a single string instead of a list to run the command in a shell
			args = {
				'format',
				'--stdin-filename',
				'$FILENAME',
				"-"
			},
			-- If the formatter supports range formatting, create the range arguments here
			range_args = function(self, ctx)
				return { "--line-start", ctx.range.start[1], "--line-end", ctx.range["end"][1] }
			end,
			-- Send file contents to stdin, read new contents from stdout (default true)
			-- When false, will create a temp file (will appear in "$FILENAME" args). The temp
			-- file is assumed to be modified in-place by the format command.
			stdin = true,
			-- A function that calculates the directory to run the command in
			cwd = require("conform.util").root_file({ "pyproject.toml", "ruff.toml", ".ruff.toml", ".editorconfig",
				"package.json" }),
			-- When cwd is not found, don't run the formatter (default false)
			require_cwd = true,
			-- When stdin=false, use this template to generate the temporary file that gets formatted
			-- When returns false, the formatter will not be used
			condition = function(self, ctx)
				return vim.fs.basename(ctx.filename) ~= "README.md"
			end,
			-- Set to false to disable merging the config with the base definition
			inherit = false,
		},
		ruff_lint_fix = {
			-- This can be a string or a function that returns a string.
			-- When defining a new formatter, this is the only field that is required
			command = "ruff",
			-- A list of strings, or a function that returns a list of strings
			-- Return a single string instead of a list to run the command in a shell
			args = {
				'check',
				'--fix',
				'--exit-zero',
				'--stdin-filename',
				'$FILENAME',
				'-',
			},
			-- If the formatter supports range formatting, create the range arguments here
			range_args = function(self, ctx)
				return { "--line-start", ctx.range.start[1], "--line-end", ctx.range["end"][1] }
			end,
			-- Send file contents to stdin, read new contents from stdout (default true)
			-- When false, will create a temp file (will appear in "$FILENAME" args). The temp
			-- file is assumed to be modified in-place by the format command.
			stdin = true,
			-- A function that calculates the directory to run the command in
			cwd = require("conform.util").root_file({ "pyproject.toml", "ruff.toml", ".ruff.toml", ".editorconfig",
				"package.json" }),
			-- When cwd is not found, don't run the formatter (default false)
			require_cwd = true,
			-- When stdin=false, use this template to generate the temporary file that gets formatted
			-- When returns false, the formatter will not be used
			condition = function(self, ctx)
				return vim.fs.basename(ctx.filename) ~= "README.md"
			end,
			-- Set to false to disable merging the config with the base definition
			inherit = false,
		},
		-- These can also be a function that returns the formatter
		other_formatter = function(bufnr)
			return {
				command = "my_cmd",
			}
		end,
	},
})
