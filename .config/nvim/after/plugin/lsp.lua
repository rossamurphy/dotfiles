local lsp_zero = require('lsp-zero')

lsp_zero.preset({ name = 'recommended', set_lsp_keymaps = false })

lsp_zero.on_attach(function(client, bufnr)
	-- see :help lsp-zero-keybindings
	-- to learn the available actions
	lsp_zero.default_keymaps({ buffer = bufnr })
end)

require('mason').setup({})
require('mason-lspconfig').setup({
	-- Replace the language servers listed here
	-- with the ones you want to install
	ensure_installed = { 'rust_analyzer', 'ruff', 'lua_ls', 'eslint', 'gopls', 'jsonls', 'marksman', 'pyright', 'taplo', 'terraformls', 'yamlls' },
	handlers = {
		lsp_zero.default_setup,

		function(server_name)
			require('lspconfig')[server_name].setup({})
		end,

		pyright = function()
			require('lspconfig').pyright.setup({
				settings = {
					pyright = {
						-- Using Ruff's import organizer
						disableOrganizeImports = true,
					},
					python = {
						pythonPath = vim.fn.exepath("python"),
						analysis = {
							-- Ignore all files for analysis to exclusively use Ruff for linting
							ignore = { '*' },
						},
					}
				},
			})
		end,

		ruff = function()
			require('lspconfig').ruff.setup({
				settings = {
					ruff = {
						configurationPreference = "filesystemFirst"
					},
				},
			})
		end,
	},
})

local function get_poetry_venv_info()
	local handle = io.popen("poetry env info --executable")
	local venv_path = nil
	if handle then
		venv_path = handle:read("*a")
		handle:close()
	end
	if venv_path then
		return venv_path
	end
	return nil
end

-- I was getting Import could not be resolved errors and I thought
-- it was due to pyright using the pyenv virtual environment rather
-- than the poetry virtual environment. So i tried this. it didn't
-- solve the issue. the issue is fixed by doing poetry run nvim
-- instead of just nvim.
-- commenting this out now for posterity
--
-- local venv_path = get_poetry_venv_info()
-- if venv_path then
--     require('lspconfig').pyright.setup({
--         on_attach = lsp_zero.on_attach,
--         settings = {
--             python = {
--                 analysis = {
--                     autoSearchPaths = true,
--                     useLibraryCodeForTypes = true,
--                 },
--                 venvPath = venv_path,
--             },
--         },
--     })
-- 	print("Poetry virtual environment found at " .. venv_path)
-- else
--     print("Poetry virtual environment not found.")
-- end





local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

local cmp_mappings = lsp_zero.defaults.cmp_mappings({
	['<C-b>'] = cmp.mapping.select_prev_item(cmp_select),
	['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
})


cmp.setup({
	mapping = {
		['<space>'] = cmp.mapping.confirm({ select = false }),
	},
	enabled = function()
		return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
				or require("cmp_dap").is_dap_buffer()
	end
})

cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
	sources = {
		{ name = "dap" },
	},
})

lsp_zero.on_attach(function(client, bufnr)
	local opts = { buffer = bufnr, remap = false }
	vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
	vim.keymap.set("n", "<F2>", function() vim.lsp.buf.rename() end, opts)
	vim.keymap.set("n", "<leader>b", function() vim.lsp.buf.definition() end, opts)
	vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
	vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
	vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
	vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
	vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
	vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
	vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
end)


lsp_zero.set_sign_icons({
	error = '✘',
	warn = '▲',
	hint = '⚑',
	info = '»'
})

require('lspconfig').lua_ls.setup(lsp_zero.nvim_lua_ls())

lsp_zero.setup()
