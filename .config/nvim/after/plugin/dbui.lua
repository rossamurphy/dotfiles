vim.g.db_ui_default_query = 'select * from "{table}" limit 10'
vim.g.db_ui_save_location = '~/.config/db_ui/db_ui_queries'
vim.g.db_ui_dotenv_variable_prefix = "DB_UI_"
vim.g.db_ui_winwidth = 100
vim.api.nvim_set_keymap('n', '<leader>dbt', ':DBUIToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dbw', ':let g:db_ui_winwidth = input("Enter a winwidth: ")<CR>', { noremap = true, silent = true })

