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

vim.opt.termguicolors = false
-- https://github.com/mobile-shell/mosh/issues/928

-- having this ON, means that when do line up (say using k),
-- the screen also moves such to always keep the top 8 lines visible
-- prime recommended this. I'm not sure I like it
-- vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"
vim.g.mapleader = " "

-- Move a line or a selection of lines down with Alt+j
vim.keymap.set('n', '<A-j>', ":m .+1<CR>==", { silent = true })
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { silent = true })

-- Move a line or a selection of lines up with Alt+k
vim.keymap.set('n', '<A-k>', ":m .-2<CR>==", { silent = true })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { silent = true })

-- for vimwiki
vim.cmd("filetype plugin on")
vim.cmd("syntax on")
vim.g.vimwiki_map_prefix = '<Leader>e'
