-- Set text width for auto-wrapping
vim.opt_local.textwidth = 70

-- Enable visual wrapping
vim.opt_local.wrap = true
vim.opt_local.linebreak = true   -- Break at word boundaries, not mid-word
vim.opt_local.breakindent = true -- Maintain indentation on wrapped lines

-- Optional: Show a visual guide at 70 characters
vim.opt_local.colorcolumn = "70"

-- Format options for better text flow
vim.opt_local.formatoptions:append("t") -- Auto-wrap text using textwidth
vim.opt_local.formatoptions:append("c") -- Auto-wrap comments
vim.opt_local.formatoptions:append("q") -- Allow formatting with gq
vim.opt_local.formatoptions:remove("l") -- Don't break already long lines
