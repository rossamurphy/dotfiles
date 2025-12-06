local cmp = require("cmp")

cmp.setup({
	enabled = function()
		return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" 
			or require("cmp_dap").is_dap_buffer()
	end,
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "path" },
	}, {
		{ name = "buffer" },
	}),
	mapping = {
		["<Tab>"] = cmp.mapping(function(fallback)
			local luasnip = require("luasnip")
			-- If completion menu is visible, navigate it (takes priority)
			if cmp.visible() then
				cmp.select_next_item()
			-- If we're in a snippet, jump to next placeholder
			elseif luasnip.jumpable(1) then
				luasnip.jump(1)
			else
				fallback()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			local luasnip = require("luasnip")
			-- If completion menu is visible, navigate it (takes priority)
			if cmp.visible() then
				cmp.select_prev_item()
			-- If we're in a snippet, jump to previous placeholder
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),

		-- Space confirms/expands the selected item
		[" "] = cmp.mapping(function(fallback)
			if cmp.visible() and cmp.get_selected_entry() then
				cmp.confirm({ select = false })
			else
				fallback()
			end
		end, { "i", "s" }),
	}
})

cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
	sources = {
		{ name = "dap" },
	},
})

cmp.setup.filetype("lua", {
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" },
		{ name = "path" },
	}, {
		{ name = "buffer" },
	}),
})

-- Helper function to check if we're in math zone (for markdown)
local function is_in_mathzone(ctx)
	local cursor_line = ctx.cursor.line
	local cursor_col = ctx.cursor.col
	local bufnr = vim.api.nvim_get_current_buf()

	-- Get all lines before cursor
	local lines_before = vim.api.nvim_buf_get_lines(bufnr, 0, cursor_line, false)
	local current_line = vim.api.nvim_buf_line_count(bufnr) > cursor_line and
		vim.api.nvim_buf_get_lines(bufnr, cursor_line, cursor_line + 1, false)[1] or ""

	-- Build text before cursor
	local before_cursor = table.concat(lines_before, "\n")
	if #before_cursor > 0 then
		before_cursor = before_cursor .. "\n"
	end
	before_cursor = before_cursor .. current_line:sub(1, cursor_col - 1)

	-- Get all lines after cursor
	local total_lines = vim.api.nvim_buf_line_count(bufnr)
	local lines_after = vim.api.nvim_buf_get_lines(bufnr, cursor_line + 1, total_lines, false)
	local after_cursor = current_line:sub(cursor_col)
	if #lines_after > 0 then
		after_cursor = after_cursor .. "\n" .. table.concat(lines_after, "\n")
	end

	-- Count $$ (display math - can span multiple lines)
	local _, before_double = before_cursor:gsub("%$%$", "")
	local _, after_double = after_cursor:gsub("%$%$", "")

	-- If we have odd $$ before and after, we're in display math
	if (before_double % 2 == 1) and (after_double % 2 == 1) then
		return true
	end

	-- For inline math ($...$), only check current line
	local before_line = current_line:sub(1, cursor_col - 1)
	local after_line = current_line:sub(cursor_col)
	local before_clean = before_line:gsub("%$%$", "")
	local after_clean = after_line:gsub("%$%$", "")
	local _, before_single = before_clean:gsub("%$", "")
	local _, after_single = after_clean:gsub("%$", "")

	-- If we have odd $ before and after on same line, we're in inline math
	return (before_single % 2 == 1) and (after_single % 2 == 1)
end

-- Create a wrapper for all markdown sources that checks math zone
local function markdown_source_filter(source_name)
	return function(entry, ctx)
		-- Check the actual source name from the entry, not the parameter
		local actual_source = entry.source.name
		local in_math = is_in_mathzone(ctx)

		-- Check if this is a luasnip source
		local is_luasnip = actual_source == "luasnip"

		-- Check if this is an obsidian source
		local is_obsidian = actual_source and actual_source:lower():match("obsidian") ~= nil

		-- Debug logging (remove after testing)
		-- vim.notify(string.format("Source: %s, InMath: %s, Showing: %s", actual_source or "nil", tostring(in_math), tostring((in_math and is_luasnip) or (not in_math and not is_luasnip))))

		if in_math then
			-- In math zone: only show luasnip, hide everything else
			return is_luasnip
		else
			-- Outside math zone: show everything EXCEPT luasnip
			return not is_luasnip
		end
	end
end

-- Dynamic source list that changes based on cursor position
local markdown_sources_math = cmp.config.sources({
	{ name = "luasnip", priority = 1000 },
})

local markdown_sources_normal = cmp.config.sources({
	{ name = "nvim_lsp" },
	{ name = "path" },
	{ name = "obsidian" },
	{ name = "obsidian_new" },
	{ name = "obsidian_tags" },
})

cmp.setup.filetype("markdown", {
	completion = {
		autocomplete = {
			require('cmp.types').cmp.TriggerEvent.TextChanged,
		},
		completeopt = 'menu,menuone,noselect',
	},
	performance = {
		debounce = 0,
		throttle = 0,
	},
	sources = markdown_sources_normal,  -- Default to normal sources
})

-- Dynamically switch sources based on math zone
vim.api.nvim_create_autocmd({ "TextChangedI", "CursorMovedI" }, {
	pattern = "*.md",
	callback = function()
		local cursor = vim.api.nvim_win_get_cursor(0)
		local ctx = {
			cursor = {
				line = cursor[1] - 1,
				col = cursor[2] + 1,
			}
		}

		local in_math = is_in_mathzone(ctx)
		local current_sources = in_math and markdown_sources_math or markdown_sources_normal

		-- Update buffer-local sources
		require('cmp').setup.buffer({
			sources = current_sources
		})
	end,
})

cmp.setup.filetype("tex", {
	completion = {
		autocomplete = {
			require('cmp.types').cmp.TriggerEvent.TextChanged,
		},
		completeopt = 'menu,menuone,noselect',
	},
	performance = {
		debounce = 0,
		throttle = 0,
	},
	sources = cmp.config.sources({
		{ name = "luasnip", priority = 1000 },
		{ name = "vimtex" },
		{ name = "nvim_lsp" },
		{ name = "path" },
	}, {
		{ name = "buffer" },
	}),
})
