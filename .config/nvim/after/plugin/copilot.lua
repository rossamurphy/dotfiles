vim.keymap.set('n', '<Leader>cop', function()
	vim.cmd("Copilot panel")
end)

vim.g.copilot_no_tab_map = true;
vim.api.nvim_set_keymap("i", "<M-Tab>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

vim.g.copilot_filetypes = {
 ["markdown"] = false,
	["vimwiki"] = false,
 ["wiki"] = false
}


-- if you want to use tab but already have tab mapped
--
-- acceptance is now alt tab
--
-- call copilot by pressing alt \
-- cycle through suggestions with alt ] and alt [ (forward and back)
-- accept by tab
