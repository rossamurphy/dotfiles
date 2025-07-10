vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("i", "jj", '<Esc>', {})
vim.keymap.set("n", "J", '}', {})
vim.keymap.set("n", "K", '{', {})
vim.keymap.set("v", "J", '}', {})
vim.keymap.set("v", "K", '{', {})
vim.keymap.set("n", "<C-p>", 'ggVG', {})

-- when page downing and page upping, keep cursor in the middle
vim.keymap.set("n", "<C-d>", '<C-d>zz', {})
vim.keymap.set("n", "<C-u>", '<C-u>zz', {})

-- when searching, keep cursor in the middle
vim.keymap.set("n", "n", 'nzzzv', {})
vim.keymap.set("n", "N", 'Nzzzv', {})

vim.keymap.set("v", "<m-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<m-k>", ":m '<-2<CR>gv=gv")

-- paste over the word
vim.keymap.set("x", "<leader>p", "\"_dp")

-- copy into the mac copy and paste buffer
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

-- delete into void register (don't yank the thing you're deleting)
vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

-- switch projects using tmux, doesn't work
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "<leader>qmr", "<cmd>CellularAutomaton make_it_rain<CR>");

-- immediately drop you into replace all occurences of this word
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- make the bash file you are writing executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>so", "<cmd>so ~/.config/nvim/init.lua <CR>")

vim.keymap.set("n", "<C-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>")

vim.keymap.set("n", "<leader>4", "i# !#!#!#!#!#!#!#!#!#!#!#!<Esc>")
vim.keymap.set("n", "<leader>3", "i#<Esc>")
vim.keymap.set("n", "<leader>2", "i``````<Esc>hhi")


vim.keymap.set("n", "<leader>1", ":so ~/.config/nvim/init.lua <CR>")
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
