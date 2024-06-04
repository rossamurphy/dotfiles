require("catppuccin").setup({
	flavour = "mocha", -- latte, frappe, macchiato, mocha
	background = {        -- :h background
		light = "latte",
		dark = "mocha",
	},
	transparent_background = false, -- disables setting the background color.
	show_end_of_buffer = false,    -- shows the '~' characters after the end of buffers
	term_colors = false,           -- sets terminal colors (e.g. `g:terminal_color_0`)
	dim_inactive = {
		enabled = false,             -- dims the background color of inactive window
		shade = "dark",
		percentage = 0.15,           -- percentage of the shade to apply to the inactive window
	},
	no_italic = false,             -- Force no italic
	no_bold = false,               -- Force no bold
	no_underline = false,          -- Force no underline
	styles = {                     -- Handles the styles of general hi groups (see `:h highlight-args`):
		comments = { "italic" },     -- Change the style of comments
		conditionals = { "italic" },
		loops = {},
		functions = {},
		keywords = {},
		strings = {},
		variables = {},
		numbers = {},
		booleans = {},
		properties = {},
		types = {},
		operators = {},
	},
	color_overrides = {
		mocha = {
			rosewater = "#efc9c2",
			flamingo = "#ebb2b2",
			pink = "#f2a7de",
			mauve = "#b889f4",
			red = "#ea7183",
			maroon = "#ea838c",
			peach = "#f39967",
			yellow = "#eaca89",
			green = "#96d382",
			teal = "#78cec1",
			sky = "#91d7e3",
			sapphire = "#68bae0",
			blue = "#739df2",
			lavender = "#a0a8f6",
			text = "#b5c1f1",
			subtext1 = "#a6b0d8",
			subtext0 = "#959ec2",
			overlay2 = "#848cad",
			overlay1 = "#717997",
			overlay0 = "#63677f",
			surface2 = "#505469",
			surface1 = "#3e4255",
			surface0 = "#2c2f40",
			-- background is base
			base = "#1E2127",
			mantle = "#141620",
			crust = "#0e0f16",
	},},
	custom_highlights = function(colors)
		return {
			CopilotSuggestion = { fg = colors.flamingo },
			NvimDapVirtualText = { fg = colors.flamingo }
		}
	end
	,
	integrations = {
		cmp = true,
		gitsigns = true,
		nvimtree = true,
		treesitter = true,
		notify = false,
		mini = false,
		dap = true,
		dap_ui = true,
		telescope = {
			enabled = true, style="nvchad" },
		-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
	},
})

-- setup must be called before loading
vim.cmd.colorscheme "catppuccin";
