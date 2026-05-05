-- Set PATH to include TeX binaries and local bin
vim.env.PATH = vim.fn.expand('~/.local/bin') .. ':' .. '/Library/TeX/texbin' .. ':' .. vim.env.PATH

-- Bootstrap lazy.nvim
require("rawdog.set")
require("rawdog.remap")

-- Compat shim for plugins (telescope.nvim, etc.) that still call the
-- nvim-treesitter `master` API. `configs` is gone on `main`, so preload a
-- stub. `parsers` exists but lacks the legacy methods telescope expects;
-- the real module is augmented after lazy loads (see end of file).
package.preload["nvim-treesitter.configs"] = function()
	return {
		is_enabled = function(_, lang, _)
			if not lang or lang == "" then return false end
			return pcall(vim.treesitter.language.add, lang)
		end,
		get_module = function(name)
			if name == "highlight" then
				return { additional_vim_regex_highlighting = false }
			end
			return {}
		end,
	}
end

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

-- Augment nvim-treesitter.parsers with legacy methods telescope.nvim's
-- previewer expects (ft_to_lang, get_parser, has_parser). Done after lazy
-- so we patch the real `main`-branch module in place rather than shadow it.
do
	local ok, parsers = pcall(require, "nvim-treesitter.parsers")
	if ok and type(parsers) == "table" then
		parsers.ft_to_lang = parsers.ft_to_lang or function(ft)
			return vim.treesitter.language.get_lang(ft) or ft
		end
		parsers.get_parser = parsers.get_parser or function(bufnr, lang)
			local p_ok, p = pcall(vim.treesitter.get_parser, bufnr, lang)
			return p_ok and p or nil
		end
		parsers.has_parser = parsers.has_parser or function(lang)
			return pcall(vim.treesitter.language.add, lang)
		end
	end
end
