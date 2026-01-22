-- VimTeX configuration
-- https://github.com/lervag/vimtex

-- Set the PDF viewer to use (macOS uses Skim or Preview)
-- Options: 'skim', 'zathura', 'general' (for Preview.app)
vim.g.vimtex_view_method = 'skim' -- Use Skim if installed, otherwise use Preview

-- If Skim is not installed, fall back to macOS Preview
vim.g.vimtex_view_general_viewer = 'open'
vim.g.vimtex_view_general_options = '-a Preview'

-- Compiler settings
-- Ensure both latexmk and TeX binaries can be found
vim.env.PATH = vim.fn.expand('~/.local/bin') .. ':' .. '/Library/TeX/texbin' .. ':' .. vim.env.PATH

vim.g.vimtex_compiler_method = 'latexmk'
vim.g.vimtex_compiler_latexmk = {
	options = {
		'-pdf',
		'-verbose',
		'-file-line-error',
		'-synctex=1',
		'-interaction=nonstopmode',
	},
}

-- Enable quickfix to show compilation errors
vim.g.vimtex_quickfix_mode = 1

-- Don't open quickfix automatically on warnings (only errors)
vim.g.vimtex_quickfix_open_on_warning = 0

-- Keymaps (these are in addition to the default VimTeX keymaps)
-- Default VimTeX keymaps you can use:
-- \ll - Start continuous compilation
-- \lv - View PDF
-- \lc - Clean auxiliary files
-- \lk - Stop compilation
-- \le - Show compilation errors

-- Additional custom keymaps
vim.keymap.set('n', '<leader>lc', '<cmd>VimtexCompile<cr>', { desc = 'Compile LaTeX' })
vim.keymap.set('n', '<leader>lv', '<cmd>VimtexView<cr>', { desc = 'View PDF' })
vim.keymap.set('n', '<leader>lt', '<cmd>VimtexTocToggle<cr>', { desc = 'Toggle TOC' })
vim.keymap.set('n', '<leader>lk', '<cmd>VimtexStop<cr>', { desc = 'Stop compilation' })
vim.keymap.set('n', '<leader>le', '<cmd>VimtexErrors<cr>', { desc = 'Show errors' })

-- ============================================================================
-- Citations Setup (cmp-vimtex + telescope-bibtex)
-- ============================================================================
-- Two ways to insert citations:
--
-- 1. AUTO-COMPLETION (cmp-vimtex):
--    - Type \cite{ in insert mode
--    - Completion menu appears automatically with bibliography entries
--    - Use Tab/Shift-Tab to navigate, Space to confirm
--
-- 2. TELESCOPE PICKER (telescope-bibtex):
--    - Press <leader>lb in normal mode
--    - Opens searchable telescope window with all citations
--    - Type to fuzzy search by author, title, year
--    - Press Enter to insert citation at cursor
--
-- REQUIREMENTS:
--    - .bib file in same directory as your .tex file
--    - Add to .tex preamble:
--      \usepackage[backend=biber,style=numeric]{biblatex}
--      \addbibresource{yourfile.bib}
--    - Add \printbibliography where you want bibliography to appear
--    - Cite works with \cite{citation_key} in your document
--
-- See example.bib in ~/.config/nvim/luasnippets/ for .bib file format examples
-- ============================================================================

-- Telescope-bibtex setup for citation picker
local ok, telescope = pcall(require, 'telescope')
if ok then
	telescope.load_extension('bibtex')
	-- <leader>lb - Browse and insert citations via telescope picker
	vim.keymap.set('n', '<leader>lb', function()
		require('telescope').extensions.bibtex.bibtex({
			search_keys = { 'author', 'title', 'year' },
		})
	end, { desc = 'Browse citations' })
end
