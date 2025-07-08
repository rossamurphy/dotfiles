return {
	-- Core plugins
	"jpalardy/vim-slime",
	"williamboman/mason.nvim",
	"christoomey/vim-tmux-navigator",

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" }
	},

	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup()
		end,
	},

	{
		"pwntester/octo.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("octo").setup({
				suppress_missing_scope = {
					projects_v2 = true,
				}
			})
		end
	},

	"vimwiki/vimwiki",
	"tpope/vim-dotenv",
	"tpope/vim-dadbod",

	{
		"kristijanhusak/vim-dadbod-completion",
		ft = { "sql", "mysql", "plsql" }
	},

	"nvim-neotest/nvim-nio",

	{
		"kristijanhusak/vim-dadbod-ui",
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
		end,
	},

	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {}
	},

	"sindrets/diffview.nvim",
	"nvim-tree/nvim-web-devicons",

	-- Debug plugins
	{
		"mxsdev/nvim-dap-vscode-js",
		dependencies = { "mfussenegger/nvim-dap" }
	},

	{
		"microsoft/vscode-js-debug",
		lazy = true,
		build = "npm install -g --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out"
	},

	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.2",
		dependencies = { "nvim-lua/plenary.nvim" }
	},

	"folke/neodev.nvim",
	"Weissle/persistent-breakpoints.nvim",

	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-python",
			"markemmons/neotest-deno",
			"lawrence-laz/neotest-zig",
		}
	},

	{
		"jackMort/ChatGPT.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim"
		}
	},

	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"mfussenegger/nvim-dap-python",
			"theHamsta/nvim-dap-virtual-text"
		}
	},

	-- Neo-tree with minimal configuration
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
		},
		lazy = false, -- neo-tree will lazily load itself
		---@module "neo-tree"
		---@type neotree.Config?
		opts = {
			-- fill any relevant options here
		},
	},
	"FotiadisM/tabset.nvim",
	-- Colorschemes
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000
	},

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate"
	},

	"nvim-treesitter/playground",
	"theprimeagen/harpoon",
	"mbbill/undotree",
	"eandrju/cellular-automaton.nvim",
	"github/copilot.vim",

	{
		"phaazon/hop.nvim",
		branch = "v2",
		config = function()
			require("hop").setup { keys = "etovxqpdygfblzhckisuran" }
		end
	},

	"tpope/vim-fugitive",
	"ellisonleao/gruvbox.nvim",
	"JoosepAlviste/nvim-ts-context-commentstring",

	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end
	},

	-- LSP Configuration
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v2.x",
		dependencies = {
			-- LSP Support
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",

			-- Autocompletion
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
			"rcarriga/cmp-dap",
		}
	},
}
