-- Set PATH to include TeX binaries and local bin
vim.env.PATH = vim.fn.expand('~/.local/bin') .. ':' .. '/Library/TeX/texbin' .. ':' .. vim.env.PATH

-- Bootstrap lazy.nvim
require("rawdog.set")
require("rawdog.remap")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins from rawdog/plugins.lua
require("lazy").setup("rawdog.plugins")
require("oil").setup()
