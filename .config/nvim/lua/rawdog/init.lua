require('rawdog.remap')
require('rawdog.set')
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.mdx",
	command = "set filetype=markdown", -- Set filetype to mdx
})
