-- LuaSnip configuration
local luasnip = require("luasnip")

-- Load snippets from ~/.config/nvim/luasnippets/
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/luasnippets/" })

-- Basic settings
luasnip.config.set_config({
	history = true,
	updateevents = "TextChanged,TextChangedI",
	enable_autosnippets = false,
})

-- Note: Keybindings are handled in cmp.lua
-- Tab/Shift+Tab work for both completion menu navigation AND snippet jumping
