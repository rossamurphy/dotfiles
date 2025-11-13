local builtin = require('telescope.builtin')
local actions = require('telescope.actions.mt')
local default_opts = {noremap = true}

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fa', "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>", default_opts)
vim.keymap.set('n', '<leader>fw', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fw', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fc', builtin.command_history, {})
vim.keymap.set('n', '<leader>fl', builtin.lsp_references, {})
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>ft', builtin.treesitter, {})
vim.keymap.set('n', '<leader>fgf', builtin.git_files, {})
vim.keymap.set('n', '<leader>fgc', builtin.git_commits, {})
vim.keymap.set('n', '<leader>fgb', builtin.git_branches, {})


vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({search = vim.fn.input("Grep me baby one more time > ")});
end)

require('telescope').setup({
  pickers = {
    git_branches = {
      mappings = {
        i = { ["<cr>"] = require('telescope.actions').git_switch_branch },
      },
    },
  },
  extensions = {
    bibtex = {
      -- Depth for the *.bib file search (search parent directories)
      depth = 2,
      -- Custom format for citation label
      custom_formats = {},
      -- Format to use for citation label.
      -- Options: 'plain', 'markdown', 'latex'
      format = 'latex',
      -- Use global .bib file search
      global_files = {},
      -- Context awareness: reads \addbibresource from current .tex file
      context = true,
      context_fallback = true,
    },
  },
})
