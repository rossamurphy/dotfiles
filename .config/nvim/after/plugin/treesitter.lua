require 'nvim-treesitter.configs'.setup {
	-- A list of parser names, or "all" (the five listed parsers should always be installed)
	ensure_installed = { "javascript", "dockerfile", "elixir", "gitignore", "go", "json", "ocaml", "svelte", "typescript", "python", "rust", "c", "lua", "vim", "vimdoc", "query", "tsx", "markdown", "markdown_inline", "tsx" },

	indent = {
		enable = true,
		disable = { 'python', 'c' }
	},

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parsers when entering buffer
	-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
	auto_install = true,

	highlight = {
		enable = true,
		-- requested by catpuccin
		-- https://github.com/catppuccin/nvim?tab=readme-ov-file
		additional_vim_regex_highlighting = false
	},
}
