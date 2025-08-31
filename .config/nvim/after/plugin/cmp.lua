local cmp = require("cmp")

cmp.setup({
	enabled = function()
		return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" 
			or require("cmp_dap").is_dap_buffer()
	end,
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "path" },
	}, {
		{ name = "buffer" },
	}),
	mapping = {
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end, { "i", "s" }),

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
