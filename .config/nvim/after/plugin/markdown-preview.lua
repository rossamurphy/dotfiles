-- Markdown Preview configuration
-- https://github.com/iamcco/markdown-preview.nvim

vim.g.mkdp_port = '9999'
vim.g.mkdp_open_to_the_world = 1
vim.g.mkdp_echo_preview_url = 1

-- Set up keymap to toggle markdown preview
vim.keymap.set("n", "<leader>im", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Toggle markdown preview" })
