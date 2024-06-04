vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"
vim.g.mapleader = " "

-- Move a line or a selection of lines down with Alt+j
vim.keymap.set('n', '<A-j>', ":m .+1<CR>==", {silent=true})
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", {silent=true})

-- Move a line or a selection of lines up with Alt+k
vim.keymap.set('n', '<A-k>', ":m .-2<CR>==", {silent=true})
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", {silent=true})

vim.opt.clipboard = "unnamedplus"
