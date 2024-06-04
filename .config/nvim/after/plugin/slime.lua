vim.keymap.set("n","<leader>e",function() vim.cmd("SlimeSend") end)
-- this for some reason only works if you rewrite the above command as the below command
-- I would really really love to know why
--
-- set mark and return to the mark
vim.keymap.set("v","<leader>e","ma :SlimeSend<CR> 'a")

vim.g.slime_target = "tmux"

vim.g.slime_dont_ask_default = 1
vim.g.slime_python_ipython = 1

vim.g.slime_cell_delimiter = "# %%"
vim.g.ipython_cell_delimit_cells_by = 'tags'
vim.g.ipython_cell_tag = "# %%"

vim.keymap.set("i", "kkk", "# %%<CR>");

vim.cmd('let g:slime_default_config = {"socket_name": get(split($TMUX, ","), 0), "target_pane": "{top-right}"}')

