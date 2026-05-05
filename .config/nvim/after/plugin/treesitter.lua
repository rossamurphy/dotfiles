-- nvim-treesitter `main` branch: no `configs.setup`. Highlight and indent
-- are opted in per-buffer via FileType.

local enabled_filetypes = {
	"javascript", "typescript", "tsx", "dockerfile", "elixir",
	"gitignore", "go", "json", "ocaml", "svelte", "python", "rust",
	"c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline",
}

local indent_disabled = { python = true, c = true }

vim.api.nvim_create_autocmd("FileType", {
	pattern = enabled_filetypes,
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
		if not indent_disabled[vim.bo[args.buf].filetype] then
			vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})
