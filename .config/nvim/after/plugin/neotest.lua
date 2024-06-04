-- the below helper functions are useful if your env requires the tests
-- to be run from the root directory. as is the case in context-call-server
local function dir_exists(path)
    local handle = vim.loop.fs_opendir(path, nil, 1)
    if handle then
        vim.loop.fs_closedir(handle)
        return true
    end
    return false
end

local function find_project_root()
    local cwd = vim.loop.cwd()
    local root = cwd

    while true do
        if dir_exists(root .. '/.git') then
            return root
        end
        local parent = vim.fn.fnamemodify(root, ":h")
        if parent == root then -- Reached the filesystem root
            break
        end
        root = parent
    end

    return cwd -- Fallback to current directory if no .git is found
end
require("neotest").setup({
	adapters = {
		require("neotest-python")({
			runner = 'pytest',
			dap = { justMyCode = false },
			python = ".venv/bin/python",
			args = function()
				local project_root = find_project_root();
				return { "--rootdir=" .. project_root, "--log-level", "DEBUG" }
			end,
		}),
		require("neotest-zig"),
		require("neotest-deno"),
	}
})
-- run ALL the tests without a debugger 
vim.keymap.set('n', '<Leader>ttn', function()
	local project_root = find_project_root();
	require("neotest").run.run({vim.fn.expand("%"), cwd = project_root, suite = true})
end)

-- run just the tests in this file without a debugger 
vim.keymap.set('n', '<Leader>tfn', function()
	local project_root = find_project_root();
	require("neotest").run.run({vim.fn.expand("%"), cwd = project_root, stdout = true, stderr = true})
end)

-- run just the MARKED tests without a debugger 
vim.keymap.set('n', '<Leader>tmn', function()
	local project_root = find_project_root();
	require("neotest").summary.run_marked({vim.fn.expand("%"), cwd = project_root})
end)

-- run ALL the tests with a debugger 
vim.keymap.set('n', '<Leader>ttd', function()
	local project_root = find_project_root();
	require("neotest").run.run({vim.fn.expand("%"), cwd = project_root, suite = true, strategy = "dap"})
end)

-- run just the tests in this file with a debugger 
vim.keymap.set('n', '<Leader>tfd', function()
	local project_root = find_project_root();
	require("neotest").run.run({vim.fn.expand("%"), cwd = project_root, strategy = "dap"})
end)

-- run just the MARKED tests with a debugger 
vim.keymap.set('n', '<Leader>tmd', function()
	local project_root = find_project_root();
	require("neotest").summary.run_marked({vim.fn.expand("%"), cwd = project_root, suite = true, strategy = "dap"})
end)

vim.keymap.set('n', '<Leader>ts', function()
	require("neotest").run.stop()
end)

-- toggle the summary panel 
vim.keymap.set('n', '<Leader>tos', function()
	require("neotest").summary.toggle()
end)

-- toggle the output panel 
vim.keymap.set('n', '<Leader>top', function()
	require("neotest").output_panel.toggle()
end)

-- clear the output panel 
vim.keymap.set('n', '<Leader>toc', function()
	require("neotest").output_panel.clear()
end)


-- you can run 
-- :Neotest output-panel
-- to open the output-panel and have a look at the test results
-- you can also run
-- :Neotest summary
-- to open the summary panel and have a look at the results per test 
-- then you can mark the tests you want to run with m
-- you can run specific tests per line using r
-- you can debug specific tests per line using d
-- you can debug all the marked tests by pressing D
-- etc.
