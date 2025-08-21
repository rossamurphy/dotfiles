-- if you are having issues..  please, for the love of God... just pip install debugpy into your venv

-- # DAP Virtual Text
require("nvim-dap-virtual-text").setup({
	enabled = true,
	enabled_commands = true,
	highlight_changed_variables = true,
	highlight_new_as_changed = false,
	show_stop_reason = true,
	commented = false,
	only_first_definition = true,
	all_references = false,
	filter_references_pattern = "<module",
	virt_text_pos = "eol",
	all_frames = false,
	virt_lines = false,
	virt_text_win_col = nil,
})

local dap = require("dap")

local dapui = require("dapui")

require("dapui").setup({
	icons = { expanded = "▾", collapsed = "▸" },
	mappings = {
		expand = { "<CR>", "<2-LeftMouse>" },
		open = "o",
		remove = "d",
		edit = "e",
		repl = "r",
		toggle = "t",
	},
	expand_lines = vim.fn.has("nvim-0.7"),
	layouts = {
		{
			elements = {
				-- Elements can be strings or table with id and size keys.
				{ id = "scopes", size = 0.25 },
				"breakpoints",
				"stacks",
				"watches",
			},
			size = 40,
			position = "left",
		},
		{
			elements = {
				{ id = "repl", size = 0.5 },
				-- do we really need the console?
				{ id = "console", size = 0.5 },
			},
			size = 10,
			position = "bottom",
		},
	},
	floating = {
		max_height = nil, -- These can be integers or a float between 0 and 1.
		max_width = nil, -- Floats will be treated as percentage of your screen.
		border = "rounded", -- Border style. Can be 'single', 'double' or 'rounded'
		mappings = {
			close = { "q", "<Esc>" },
		},
	},
	windows = { indent = 1 },
	render = {
		max_type_length = nil,
	},
})

dap.listeners.after.event_initialized["dapui_config"] = function()
	-- vim.cmd('tabfirst|tabnext')
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end

-- # Keymap
--
local buf_map = function(mode, lhs, rhs, opts)
	vim.api.nvim_set_keymap(mode, lhs, rhs, opts or {
		silent = true,
	})
end

require("dap").set_log_level("TRACE")
--

-- PYTHON
-- https://github.com/mfussenegger/nvim-dap-python/tree/d4400d075c21ed8fb8e8ac6a5ff56f58f6e93531
-- make a venv somewhere that has debugpy so that can run and attach to the process
-- require('dap-python').setup("~/.config/debugpy/venv/bin/python")
-- dap.adapters.python = {
--   type = 'executable';
--   command = 'python';
--   args = { '-m', 'debugpy.adapter'};
-- pythonPath = function()
-- 	return "./.venv/bin/python";
-- end,
-- }
--
require("dap-python").test_runner = "pytest"

-- example of how to select which path you want, using the vim selector ui
-- local selector = function()
--     return coroutine.create(function(dap_run_co)
--         local filepath = vim.fn.expand("%:p:.")
--         local modulepath = filepath:gsub("/", "."):gsub("%.py$","")
--         local items = {filepath, modulepath}
--         vim.ui.select(items, { label = 'foo> '}, function(choice)
--             coroutine.resume(dap_run_co, choice)
--         end)
--     end)
-- end

-- function for converting filename to modulename
local modulename = function()
	local filepath = vim.fn.expand("%:p:.")
	local modulename = filepath:gsub("/", "."):gsub("%.py$", "")
	-- for debugging, if it's not working on your end, uncomment the below
	-- print(string.format("inferred module name %s",modulename))
	return modulename
end

local function get_python_path()
	local venv_path = os.getenv("VIRTUAL_ENV")
	if venv_path then
		return venv_path .. "/bin/python"
	end

	-- Try common python locations
	local python_paths = {
		vim.fn.exepath("python3"),
		vim.fn.exepath("python"),
		"/usr/bin/python3",
		"/usr/local/bin/python3",
	}

	for _, path in ipairs(python_paths) do
		if vim.fn.executable(path) == 1 then
			return path
		end
	end

	return "python3" -- fallback
end

require("dap-python").setup(get_python_path())
table.insert(dap.configurations.python, {
	type = "python",
	request = "attach",
	name = "Attach to debugpy",
	host = "localhost",
	port = 5678,
	pathMappings = {
		{
			localRoot = vim.fn.getcwd(),
			remoteRoot = "/opt/shared", -- For your Docker setup later
		},
	},
})
-- For local testing, simpler version:
table.insert(dap.configurations.python, {
	type = "python",
	request = "attach",
	name = "Attach Local",
	host = "localhost",
	port = 5678,
})

table.insert(dap.configurations.python, {
	type = "python",
	request = "launch",
	name = "Vanilla Venv - As Module",
	module = modulename,
	cwd = "${workspaceFolder}",
})

require("dap-vscode-js").setup({
	node_path = "node",
	-- debugger_path = os.getenv('HOME') .. '/.DAP/vscode-js-debug',
	adapters = { "node2", "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
})

-- NODE
local exts = {
	"javascript",
	"typescript",
	"javascriptreact",
	"typescriptreact",
	-- using pwa-chrome
	"vue",
	"svelte",
}

for i, ext in ipairs(exts) do
	dap.configurations[ext] = {
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch Current File (pwa-node)",
			cwd = vim.fn.getcwd(),
			args = { "${file}" },
			sourceMaps = true,
			protocol = "inspector",
		},
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch Current File (pwa-node with ts-node)",
			cwd = vim.fn.getcwd(),
			runtimeArgs = { "--require", "ts-node/register" },
			runtimeExecutable = "node",
			args = { "${file}" },
			sourceMaps = true,
			console = "integratedTerminal",
			protocol = "inspector",
			skipFiles = { "<node_internals>/**", "node_modules/**" },
			resolveSourceMapLocations = {
				"${workspaceFolder}/**",
				"!**/node_modules/**",
			},
		},
		{
			type = "pwa-node",
			request = "launch",
			name = "NextJS (pwa-node)",
			cwd = vim.fn.getcwd(),
			runtimeExecutable = "node",
			file = vim.fn.getcwd() .. "/node_modules/next/dist/bin/next",
			protocol = "inspector",
			console = "integratedTerminal",
			skipFiles = { "<node_internals>/**", "node_modules/**" },
			sourceMaps = true,
			restart = true,
			env = { NODE_ENV = "development" },
			port = 9229,
			resolveSourceMapLocations = {
				"${workspaceFolder}/**",
				"!**/node_modules/**",
			},
		},
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch Current File (pwa-node with deno)",
			cwd = vim.fn.getcwd(),
			runtimeArgs = { "run", "--inspect-brk", "--allow-all", "${file}" },
			runtimeExecutable = "deno",
			attachSimplePort = 9229,
		},
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch Test Current File (pwa-node with jest)",
			cwd = vim.fn.getcwd(),
			runtimeArgs = { "${workspaceFolder}/node_modules/.bin/jest" },
			runtimeExecutable = "node",
			args = { "${file}", "--coverage", "false" },
			rootPath = "${workspaceFolder}",
			sourceMaps = true,
			console = "integratedTerminal",
			internalConsoleOptions = "neverOpen",
			skipFiles = { "<node_internals>/**", "node_modules/**" },
		},
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch Test Current File (pwa-node with vitest)",
			cwd = vim.fn.getcwd(),
			program = "${workspaceFolder}/node_modules/vitest/vitest.mjs",
			args = { "--inspect-brk", "--threads", "false", "run", "${file}" },
			autoAttachChildProcesses = true,
			smartStep = true,
			console = "integratedTerminal",
			skipFiles = { "<node_internals>/**", "node_modules/**" },
		},
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch Test Current File (pwa-node with deno)",
			cwd = vim.fn.getcwd(),
			runtimeArgs = { "test", "--inspect-brk", "--allow-all", "${file}" },
			runtimeExecutable = "deno",
			attachSimplePort = 9229,
		},
		{
			type = "pwa-chrome",
			request = "attach",
			name = "Attach Program (pwa-chrome = { port: 9222 })",
			program = "${file}",
			cwd = vim.fn.getcwd(),
			sourceMaps = true,
			port = 9222,
			webRoot = "${workspaceFolder}",
		},
	}
end

-- GLOBAL KEYMAPS
vim.fn.sign_define("DapBreakpoint", { text = "🚨", texthl = "", linehl = "", numhl = "Error" })
vim.fn.sign_define("DapLogPoint", { text = "🪵", texthl = "", linehl = "", numhl = "Error" })
vim.fn.sign_define("DapStopped", { text = "🎾", texthl = "", linehl = "", numhl = "" })

vim.keymap.set("n", "<F5>", function()
	require("dap").continue()
end)
vim.keymap.set("n", "<F8>", function()
	require("dap").step_over()
end)
vim.keymap.set("n", "<F9>", function()
	require("dap").step_into()
end)
vim.keymap.set("n", "<F10>", function()
	require("dap").step_out()
end)
-- now this is implemented by f3 via the persistent breakpoints plugin
-- vim.keymap.set('n', '<Leader>g', function() require('dap').toggle_breakpoint() end)
-- vim.keymap.set('n', '<Leader>G', function() require('dap').set_breakpoint() end)
vim.keymap.set("n", "<Leader>lp", function()
	require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end)
vim.keymap.set("n", "<Leader>dr", function()
	require("dap").repl.open()
end)
vim.keymap.set("n", "<Leader>dl", function()
	require("dap").run_last()
end)
vim.keymap.set("n", "<Leader>dc", function()
	require("dap").run_to_cursor()
end)

-- ooootra vez
vim.keymap.set("n", "<Leader>do", function()
	require("dap").restart()
end)
-- quit
vim.keymap.set("n", "<Leader>dd", function()
	require("dap").disconnect()
	dapui.close()
end)
vim.keymap.set("n", "<Leader>dq", function()
	dapui.close()
end)

vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
	require("dap.ui.widgets").hover()
end)
vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
	require("dap.ui.widgets").preview()
end)
vim.keymap.set("n", "<Leader>df", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.frames)
end)
vim.keymap.set("n", "<Leader>ds", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.scopes)
end)

require("cmp").setup({
	enabled = function()
		return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
	end,
})

require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
	sources = {
		{ name = "dap" },
	},
})

-- when you want to zoom in on a particular window in the debug ui, navigate to the window, and do:
-- :tab split
-- then, you can just gt back and forth.
-- and when you're done, just :q
