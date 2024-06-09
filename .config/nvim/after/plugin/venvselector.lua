require 'venv-selector'.setup {function()
	return {
		'linux-cultist/venv-selector.nvim',
		dependencies = { 'neovim/nvim-lspconfig', 'nvim-telescope/telescope.nvim', 'mfussenegger/nvim-dap-python' },
		config = function()
			require('venv-selector').setup {
				dap_enabled = true;
				parents = 0;
				-- Your options go here
				-- name = "venv",
				-- auto_refresh = false
			}
		end,
	  keys = {
    -- Keymap to open VenvSelector to pick a venv.
    { '<leader>vs', '<cmd>VenvSelect<cr>' },
    -- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
    { '<leader>vc', '<cmd>VenvSelectCached<cr>' },
  },
	}
end
}

