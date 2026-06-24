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

local reported_image_errors = {}

local function first_error_line(err)
	return tostring(err):gsub("\r", ""):match("([^\n]*)") or tostring(err)
end

local function notify_image_error(path, err)
	local message = first_error_line(err)
	local key = tostring(path) .. "\n" .. message
	if reported_image_errors[key] then
		return
	end
	reported_image_errors[key] = true

	vim.schedule(function()
		local label = path and vim.fn.fnamemodify(tostring(path), ":t") or "image"
		vim.notify("image.nvim skipped " .. label .. ": " .. message, vim.log.levels.WARN)
	end)
end

local function is_image_processing_error(err)
	local message = tostring(err)
	return message:find("magick:", 1, true)
		or message:find("ImageMagick", 1, true)
		or message:find("convert timed out", 1, true)
		or message:find("identify ", 1, true)
		or message:find("Failed to convert", 1, true)
		or message:find("Failed to get dimensions", 1, true)
end

do
	local magick_cli = require("image/processors/magick_cli")
	local original_convert_to_png = magick_cli.convert_to_png
	local svg_font

	local function readable(path)
		return path and path ~= "" and vim.fn.filereadable(path) == 1
	end

	local function fallback_svg_font()
		if svg_font ~= nil then
			return svg_font
		end

		if readable(vim.env.IMAGE_NVIM_MAGICK_FONT) then
			svg_font = vim.env.IMAGE_NVIM_MAGICK_FONT
			return svg_font
		end

		for _, path in ipairs({
			"/System/Library/Fonts/Supplemental/Arial.ttf",
			"/System/Library/Fonts/Supplemental/Helvetica.ttf",
			"/System/Library/Fonts/Helvetica.ttc",
			"/System/Library/Fonts/SFNS.ttf",
			"/System/Library/Fonts/SFNSMono.ttf",
		}) do
			if readable(path) then
				svg_font = path
				return svg_font
			end
		end

		svg_font = false
		return nil
	end

	local function close_magick_handles(handle, stderr)
		if stderr and not stderr:is_closing() then
			stderr:read_stop()
			stderr:close()
		end
		if handle and not handle:is_closing() then
			handle:close()
		end
	end

	local function magick(args, timeout_ms, failure_message)
		local done = false
		local exit_code = nil
		local stderr = vim.loop.new_pipe()
		local stderr_output = ""
		local handle

		handle = vim.loop.spawn("magick", {
			args = args,
			stdio = { nil, nil, stderr },
			hide = true,
		}, function(code)
			exit_code = code
			done = true
		end)

		if not handle then
			if stderr and not stderr:is_closing() then
				stderr:close()
			end
			error("image.nvim: failed to start magick")
		end

		vim.loop.read_start(stderr, function(err, data)
			assert(not err, err)
			if data then
				stderr_output = stderr_output .. data
			end
		end)

		local success = vim.wait(timeout_ms, function()
			return done
		end, 10)

		if not success then
			if handle and not handle:is_closing() then
				handle:kill("sigterm")
			end
			close_magick_handles(handle, stderr)
			error(failure_message .. " timed out")
		end

		close_magick_handles(handle, stderr)

		if exit_code ~= 0 then
			error(stderr_output ~= "" and stderr_output or failure_message)
		end
	end

	magick_cli.convert_to_png = function(path, output_path)
		local actual_format = magick_cli.get_format(path)
		if actual_format ~= "svg" and actual_format ~= "xml" then
			return original_convert_to_png(path, output_path)
		end

		local font = fallback_svg_font()
		if not font then
			return original_convert_to_png(path, output_path)
		end

		local out_path = output_path or path:gsub("%.[^.]+$", ".png")
		magick({ "-font", font, path, "png:" .. out_path }, 10000, "Failed to convert SVG to PNG")
		return out_path
	end
end

require("image").setup({
	backend = "kitty",
	kitty_method = "normal",
	debug = { enabled = true, level = "debug", file_path = "/tmp/image.nvim.log", format = "compact" },
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
			-- Obsidian writes image links relative to the vault root, not the
			-- note's directory. Walk up looking for `.obsidian/` and resolve
			-- from there; fall back to image.nvim's default for non-vault files.
			resolve_image_path = function(document_path, image_path, fallback)
				local first = image_path:sub(1, 1)
				if first == "/" or first == "~" then
					return fallback(document_path, image_path)
				end
				local dir = vim.fn.fnamemodify(document_path, ":p:h")
				while dir and dir ~= "/" and dir ~= "" do
					if vim.fn.isdirectory(dir .. "/.obsidian") == 1 then
						return dir .. "/" .. image_path
					end
					local parent = vim.fn.fnamemodify(dir, ":h")
					if parent == dir then break end
					dir = parent
				end
				return fallback(document_path, image_path)
			end,
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

-- Workaround for image.nvim race: the markdown integration registers two
-- BufWinEnter autocmds, both schedule render() in rapid succession. Each
-- render() calls from_file() which creates a new Image, but state.images[id]
-- isn't populated until the *backend* renders. Before that completes the
-- second render() runs, creates a fresh Image with a new internal_id, and
-- its render path clears the first (deleting the just-transmitted i=N from
-- kitty) and places a different internal_id that was never transmitted —
-- so kitty has nothing to display. Dedupe by populating state.images at
-- creation time. The same hook wraps render() to skip stale images whose
-- extmark moved beyond the current buffer line count; otherwise image.nvim can
-- call screenpos() with an invalid line during TextChanged.
do
	local image_module = require("image.image")
	local original_from_file = image_module.from_file

	local function row_is_in_buffer(instance)
		if not instance or not instance.buffer or not instance.geometry then
			return true
		end

		local y = instance.geometry.y
		if type(y) ~= "number" then
			return true
		end

		local ok, is_valid = pcall(vim.api.nvim_buf_is_valid, instance.buffer)
		if not ok or not is_valid then
			return false
		end

		local line_count_ok, line_count = pcall(vim.api.nvim_buf_line_count, instance.buffer)
		if not line_count_ok then
			return false
		end

		return y >= 0 and y < line_count
	end

	local function clear_stale_image(instance)
		pcall(function()
			instance:clear(true)
		end)
	end

	local function wrap_render(instance)
		if not instance or instance._rawdog_render_guard then
			return instance
		end

		local original_render = instance.render
		instance.render = function(self, geometry)
			local previous_geometry = self.geometry
			if geometry then
				self.geometry = vim.tbl_deep_extend("force", self.geometry or {}, geometry)
			end

			if not row_is_in_buffer(self) then
				clear_stale_image(self)
				return
			end

			self.geometry = previous_geometry
			local ok, err = pcall(original_render, self, geometry)
			if not ok then
				if tostring(err):find("E966: Invalid line number", 1, true) then
					clear_stale_image(self)
					return
				end
				if is_image_processing_error(err) then
					notify_image_error(self.original_path or self.path, err)
					clear_stale_image(self)
					return
				end
				error(err)
			end
		end
		instance._rawdog_render_guard = true

		return instance
	end

	image_module.from_file = function(path, options, state)
		local ok, instance = pcall(original_from_file, path, options, state)
		if not ok then
			if is_image_processing_error(instance) then
				notify_image_error(path, instance)
				return nil
			end
			error(instance)
		end
		if instance and instance.id and not state.images[instance.id] then
			state.images[instance.id] = instance
		end
		return wrap_render(instance)
	end
end

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
