-- Set target width for gq and <Leader>fm wrapping.
vim.opt_local.textwidth = 70

vim.opt_local.wrap = false
vim.opt_local.linebreak = false
vim.opt_local.breakindent = true

-- Optional: Show a visual guide at 70 characters
vim.opt_local.colorcolumn = "70"

-- Format options for better text flow
vim.opt_local.formatoptions:append("c") -- Auto-wrap comments
vim.opt_local.formatoptions:append("q") -- Allow formatting with gq
vim.opt_local.formatoptions:remove("l") -- Don't break already long lines
vim.opt_local.formatoptions:remove("t") -- Built-in auto-wrap counts concealed markdown syntax.

vim.opt_local.formatexpr = "v:lua.require'rawdog.markdown_visible_wrap'.formatexpr()"

local auto_wrap_group = vim.api.nvim_create_augroup("RawdogMarkdownAutoWrap" .. vim.api.nvim_get_current_buf(), {
	clear = true,
})

vim.api.nvim_create_autocmd("InsertCharPre", {
	group = auto_wrap_group,
	buffer = 0,
	callback = function()
		require("rawdog.markdown_visible_wrap").track_insert_char()
	end,
})

vim.api.nvim_create_autocmd("TextChangedI", {
	group = auto_wrap_group,
	buffer = 0,
	callback = function(args)
		local bufnr = args.buf
		vim.schedule(function()
			if vim.api.nvim_buf_is_valid(bufnr) then
				require("rawdog.markdown_visible_wrap").auto_wrap_insert({ bufnr = bufnr })
			end
		end)
	end,
})

vim.keymap.set("n", "<Leader>fm", function()
	require("rawdog.markdown_visible_wrap").format_buffer()
end, { buffer = true, desc = "Format markdown by visible width" })

vim.keymap.set("v", "<Leader>fm", function()
	require("rawdog.markdown_visible_wrap").format_visual()
end, { buffer = true, desc = "Format markdown selection by visible width" })
