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

cmp.setup.filetype("markdown", {
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "path" },
		-- Obsidian.nvim provides its own completion source
	}),
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
		{ name = "nvim_lsp" },
		{ name = "path" },
	}, {
		{ name = "buffer" },
	}),
})
