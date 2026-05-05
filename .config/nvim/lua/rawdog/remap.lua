vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("i", "jj", "<Esc>", {})
vim.keymap.set({ "i", "c" }, "<M-3>", "#", { desc = "Insert #" })
vim.keymap.set("n", "J", "}", {})
vim.keymap.set("n", "K", "{", {})
vim.keymap.set("v", "J", "}", {})
vim.keymap.set("v", "K", "{", {})
vim.keymap.set("n", "<C-p>", "ggVG", {})

-- when page downing and page upping, keep cursor in the middle
vim.keymap.set("n", "<C-d>", "<C-d>zz", {})
vim.keymap.set("n", "<C-u>", "<C-u>zz", {})

-- when searching, keep cursor in the middle
vim.keymap.set("n", "n", "nzzzv", {})
vim.keymap.set("n", "N", "Nzzzv", {})

vim.keymap.set("v", "<m-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<m-k>", ":m '<-2<CR>gv=gv")

-- paste over the word
vim.keymap.set("x", "<leader>p", '"_dp')

-- copy into the mac copy and paste buffer
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')
local function yank_excel(lines)
	local items = {}

	for _, line in ipairs(lines) do
		line = line:gsub("\r", ""):gsub("\t", " ")
		line = vim.trim(line)

		if line ~= "" then
			if line:match("^[-*+]%s+") or line:match("^%d+[.)]%s+") or #items == 0 then
				table.insert(items, line)
			else
				items[#items] = items[#items] .. " " .. line
			end
		end
	end

	local text = table.concat(items, "\n"):gsub('"', '""')
	text = '"' .. text .. '"'
	vim.fn.setreg("+", text, "c")
end

vim.api.nvim_create_user_command("YankExcel", function(opts)
	local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)
	yank_excel(lines)
end, { range = true })

vim.keymap.set("x", "<leader>Y", ":YankExcel<CR>", { desc = "Yank to clipboard without line breaks" })

-- delete into void register (don't yank the thing you're deleting)
vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set("v", "<leader>d", '"_d')

-- switch projects using tmux, doesn't work
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

vim.keymap.set("n", "<leader>qmr", "<cmd>CellularAutomaton make_it_rain<CR>")

-- immediately drop you into replace all occurrences of this word
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- make the bash file you are writing executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>so", "<cmd>so ~/.config/nvim/init.lua <CR>")

-- because some terminal emulators send ctrl-h as backspace (read Blink on iPad)
vim.keymap.set("n", "<BS>", ":wincmd h<CR>")
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>")

vim.keymap.set("n", "<leader>4", "i# !#!#!#!#!#!#!#!#!#!#!#!<Esc>")
vim.keymap.set("n", "<leader>3", "i#<Esc>")
vim.keymap.set("n", "<leader>5", "i``````<Esc>hhi")

vim.keymap.set("n", "<leader>2", function()
	local day = tonumber(os.date("%d"))
	local suffix
	if day % 100 >= 11 and day % 100 <= 13 then
		suffix = "th"
	elseif day % 10 == 1 then
		suffix = "st"
	elseif day % 10 == 2 then
		suffix = "nd"
	elseif day % 10 == 3 then
		suffix = "rd"
	else
		suffix = "th"
	end
	local date_str = string.format("%d%s %s, %s", day, suffix, os.date("%B"), os.date("%Y"))
	vim.api.nvim_put({ date_str }, "c", true, true)
end, { desc = "Insert today's date (e.g. 5th May, 2026)" })

vim.keymap.set("n", "<leader>1", ":so ~/.config/nvim/init.lua <CR>")
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- being able to split vim windows similar to how I split tmux windows
vim.keymap.set("n", "<C-w>|", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", '<C-w>"', "<C-w>s", { desc = "Split window horizontally" })
