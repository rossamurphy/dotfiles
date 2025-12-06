vim.keymap.set('n', '<Leader>cop', function()
	vim.cmd("Copilot panel")
end)

-- Disable automatic suggestions - only show when manually triggered
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true

-- Disable Copilot for certain filetypes
vim.g.copilot_filetypes = {
	["markdown"] = false,
	["vimwiki"] = false,
	["wiki"] = false
}

-- Completely disable automatic triggers
vim.cmd([[
  augroup DisableCopilotAutoTrigger
    autocmd!
    autocmd InsertEnter * let b:copilot_enabled = v:false
  augroup END
]])

-- Only enable Copilot when explicitly requested
vim.g.copilot_enabled = false

-- Manual trigger for suggestions (Alt+\) - enables and suggests
vim.keymap.set("i", "<M-\\>", function()
  vim.b.copilot_enabled = true
  vim.cmd("call copilot#Suggest()")
end, { silent = true })

-- Cycle through suggestions (Alt+] and Alt+[)
vim.api.nvim_set_keymap("i", "<M-]>", '<Plug>(copilot-next)', { silent = true })
vim.api.nvim_set_keymap("i", "<M-[>", '<Plug>(copilot-previous)', { silent = true })

-- Dismiss suggestions
vim.api.nvim_set_keymap("i", "<C-]>", '<Plug>(copilot-dismiss)', { silent = true })

-- Use Alt-Tab to accept Copilot suggestions
vim.cmd([[
  imap <silent><script><expr> <M-Tab> copilot#Accept("\<CR>")
]])
