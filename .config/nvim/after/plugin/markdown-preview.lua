-- Markdown Preview configuration
-- https://github.com/iamcco/markdown-preview.nvim

vim.g.mkdp_port = '9999'
vim.g.mkdp_open_to_the_world = 1
vim.g.mkdp_echo_preview_url = 1

local function add_pid(result, seen, pid)
	if pid:match("^%d+$") and not seen[pid] and pid ~= tostring(vim.fn.getpid()) then
		seen[pid] = true
		table.insert(result, pid)
	end
end

local function mkdp_pids()
	local port = tostring(vim.g.mkdp_port or "")
	local result = {}
	local seen = {}

	if port ~= "" and vim.fn.executable("lsof") == 1 then
		for _, pid in ipairs(vim.fn.systemlist({ "lsof", "-nP", "-tiTCP:" .. port, "-sTCP:LISTEN" })) do
			local details = table.concat(vim.fn.systemlist({ "lsof", "-p", pid }), "\n")
			if details:find("markdown-preview.nvim/app", 1, true) then
				add_pid(result, seen, pid)
			end
		end
	end

	if vim.fn.executable("pgrep") == 1 then
		for _, pid in ipairs(vim.fn.systemlist({ "pgrep", "-f", "markdown-preview.nvim/app" })) do
			add_pid(result, seen, pid)
		end
	elseif vim.fn.executable("ps") == 1 then
		for _, line in ipairs(vim.fn.systemlist({ "ps", "-axo", "pid=,command=" })) do
			local pid, command = line:match("^%s*(%d+)%s+(.*)$")
			if pid and command and command:find("markdown-preview.nvim/app", 1, true) then
				add_pid(result, seen, pid)
			end
		end
	end

	return result
end

local function kill_stale_mkdp_processes()
	for _, pid in ipairs(mkdp_pids()) do
		local kill = (vim.uv or vim.loop).kill
		pcall(kill, tonumber(pid), 15)
	end
end

local function restart_markdown_preview(bufnr)
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end

	kill_stale_mkdp_processes()

	vim.defer_fn(function()
		if not vim.api.nvim_buf_is_valid(bufnr) then
			return
		end

		kill_stale_mkdp_processes()
		vim.api.nvim_buf_call(bufnr, function()
			-- Reset markdown-preview.nvim's script-local RPC channel state after
			-- killing the old server. Calling its stop path can crash when the
			-- previous node process failed during startup.
			pcall(vim.cmd.runtime, "autoload/mkdp/util.vim")
			pcall(vim.cmd.runtime, "autoload/mkdp/rpc.vim")
			pcall(vim.fn["mkdp#util#open_preview_page"])
			vim.b.MarkdownPreviewToggleBool = 1
		end)
	end, 200)
end

local function install_restart_command(bufnr)
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end

	vim.api.nvim_buf_create_user_command(bufnr, "MarkdownPreview", function()
		restart_markdown_preview(bufnr)
	end, { force = true })
end

vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
	group = vim.api.nvim_create_augroup("markdown_preview_restart_command", { clear = true }),
	callback = function(args)
		local bufnr = args.buf
		if vim.tbl_contains(vim.g.mkdp_filetypes or { "markdown" }, vim.bo[bufnr].filetype) then
			vim.schedule(function()
				install_restart_command(bufnr)
			end)
		end
	end,
})

-- Run preview as a fresh restart instead of toggling onto stale server state.
vim.keymap.set("n", "<leader>im", "<cmd>MarkdownPreview<cr>", { desc = "Restart markdown preview" })
