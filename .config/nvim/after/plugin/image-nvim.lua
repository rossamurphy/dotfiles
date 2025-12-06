-- https://github.com/3rd/image.nvim
--
-- Filename: ~/github/dotfiles-latest/neovim/nvim-lazyvim/lua/plugins/image-nvim.lua
-- ~/github/dotfiles-latest/neovim/nvim-lazyvim/lua/plugins/image-nvim.lua

-- For dependencies see
-- `~/github/dotfiles-latest/neovim/nvim-lazyvim/README.md`
--
-- -- Uncomment the following 2 lines if you use the local luarocks installation
-- -- Leave them commented to instead use `luarocks.nvim`
-- -- instead of luarocks.nvim
-- Notice that in the following 2 commands I'm using luaver
-- package.path = package.path
--   .. ";"
--   .. vim.fn.expand("$HOME")
--   .. "/.luaver/luarocks/3.11.0_5.1/share/lua/5.1/magick/?/init.lua"
-- package.path = package.path
--   .. ";"
--   .. vim.fn.expand("$HOME")
--   .. "/.luaver/luarocks/3.11.0_5.1/share/lua/5.1/magick/?.lua"
--
-- -- Here I'm not using luaver, but instead installed lua and luarocks directly through
-- -- homebrew
-- package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua"
-- package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua"

require("image").setup({
	backend = "kitty",
	kitty_method = "normal",
	integrations = {
		-- Notice these are the settings for markdown files
		markdown = {
			enabled = true,
			clear_in_insert_mode = false,
			-- Set this to false if you don't want to render images coming from
			-- a URL
			download_remote_images = true,
			-- Change this if you would only like to render the image where the
			-- cursor is at
			-- I set this to true, because if the file has way too many images
			-- it will be laggy and will take time for the initial load
			only_render_image_at_cursor = false,
			-- markdown extensions (ie. quarto) can go here
			filetypes = { "markdown", "vimwiki" },
		},
		neorg = {
			enabled = true,
			clear_in_insert_mode = false,
			download_remote_images = true,
			only_render_image_at_cursor = false,
			filetypes = { "norg" },
		},
		-- This is disabled by default
		-- Detect and render images referenced in HTML files
		-- Make sure you have an html treesitter parser installed
		-- ~/github/dotfiles-latest/neovim/nvim-lazyvim/lua/plugins/treesitter.lua
		html = {
			enabled = true,
		},
		-- This is disabled by default
		-- Detect and render images referenced in CSS files
		-- Make sure you have a css treesitter parser installed
		-- ~/github/dotfiles-latest/neovim/nvim-lazyvim/lua/plugins/treesitter.lua
		css = {
			enabled = true,
		},
	},
	max_width = nil,
	max_height = nil,
	max_width_window_percentage = nil,

	-- This is what I changed to make my images look smaller, like a
	-- thumbnail, the default value is 50
	-- max_height_window_percentage = 20,
	max_height_window_percentage = 40,

	-- toggles images when windows are overlapped
	window_overlap_clear_enabled = false,
	window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },

	-- auto show/hide images when the editor gains/looses focus
	editor_only_render_when_focused = true,

	-- auto show/hide images in the correct tmux window
	-- In the tmux.conf add `set -g visual-activity off`
	tmux_show_only_in_active_window = true,

	-- render image files as images when opened
	hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
})

-- Keymap to delete image file under cursor using trash
vim.keymap.set("n", "<leader>id", function()
	-- Get the current line
	local line = vim.api.nvim_get_current_line()
	-- Match markdown image syntax: ![alt](path)
	local image_path = line:match("!%[.-%]%((.-)%)")

	if image_path then
		-- If path is relative, make it absolute from the current file's directory
		if not image_path:match("^/") then
			local current_file_dir = vim.fn.expand("%:p:h")
			image_path = current_file_dir .. "/" .. image_path
		end

		-- Check if file exists before trying to delete
		if vim.fn.filereadable(image_path) == 1 then
			-- Get the directory containing the image
			local image_dir = vim.fn.fnamemodify(image_path, ":h")

			-- Delete the image file
			local result = vim.fn.system({ "trash", image_path })
			local exit_code = vim.v.shell_error

			if exit_code == 0 then
				vim.notify("Deleted image: " .. image_path)
				-- Delete the line with the image reference
				vim.api.nvim_del_current_line()

				-- Check if the directory is now empty and delete it if so
				local dir_contents = vim.fn.readdir(image_dir)
				if #dir_contents == 0 then
					vim.fn.delete(image_dir, "d")
					vim.notify("Deleted empty directory: " .. image_dir)
				end
			else
				vim.notify("Failed to delete image: " .. result, vim.log.levels.ERROR)
			end
		else
			vim.notify("Image file not found: " .. image_path, vim.log.levels.WARN)
		end
	else
		vim.notify("No image reference on current line")
	end
end, { desc = "Delete image under cursor and line" })
