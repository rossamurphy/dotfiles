local M = {}

local DEFAULT_WIDTH = 70

local function starts_with(text, pos, prefix)
	return text:sub(pos, pos + #prefix - 1) == prefix
end

local function display_width(text)
	return vim.fn.strdisplaywidth(text or "")
end

local function skip_space(text, pos)
	while pos <= #text and text:sub(pos, pos):match("%s") do
		pos = pos + 1
	end
	return pos
end

local function find_balanced(text, open_pos, open_char, close_char)
	local depth = 0
	local pos = open_pos
	while pos <= #text do
		local char = text:sub(pos, pos)
		if char == "\\" then
			pos = pos + 2
		elseif char == open_char then
			depth = depth + 1
			pos = pos + 1
		elseif char == close_char then
			depth = depth - 1
			if depth == 0 then
				return pos
			end
			pos = pos + 1
		else
			pos = pos + 1
		end
	end
	return nil
end

local function find_wiki_end(text, start_pos)
	local pos = start_pos + 2
	while pos <= #text - 1 do
		if text:sub(pos, pos) == "\\" then
			pos = pos + 2
		elseif starts_with(text, pos, "]]") then
			return pos + 1
		else
			pos = pos + 1
		end
	end
	return nil
end

local function split_unescaped_pipe(text)
	local pos = 1
	while pos <= #text do
		local char = text:sub(pos, pos)
		if char == "\\" then
			pos = pos + 2
		elseif char == "|" then
			return text:sub(1, pos - 1), text:sub(pos + 1)
		else
			pos = pos + 1
		end
	end
	return text, nil
end

local function parse_wiki_link(text, pos)
	if not starts_with(text, pos, "[[") then
		return nil
	end
	local end_pos = find_wiki_end(text, pos)
	if not end_pos then
		return nil
	end
	local body = text:sub(pos + 2, end_pos - 2)
	local destination, alias = split_unescaped_pipe(body)
	return {
		kind = "wiki",
		end_pos = end_pos,
		destination = destination,
		alias = alias,
		label = alias or destination,
	}
end

local function parse_markdown_link(text, pos)
	local image = false
	local bracket_pos = pos
	if starts_with(text, pos, "![") then
		image = true
		bracket_pos = pos + 1
	elseif text:sub(pos, pos) ~= "[" then
		return nil
	end

	local close_bracket = find_balanced(text, bracket_pos, "[", "]")
	if not close_bracket then
		return nil
	end

	local label = text:sub(bracket_pos + 1, close_bracket - 1)
	local after_label = skip_space(text, close_bracket + 1)

	if text:sub(after_label, after_label) == "(" then
		local close_paren = find_balanced(text, after_label, "(", ")")
		if close_paren then
			return {
				kind = image and "image" or "inline",
				end_pos = close_paren,
				label = label,
				destination = text:sub(after_label + 1, close_paren - 1),
			}
		end
	elseif text:sub(after_label, after_label) == "[" then
		local close_ref = find_balanced(text, after_label, "[", "]")
		if close_ref then
			return {
				kind = "reference",
				end_pos = close_ref,
				label = label,
			}
		end
	end

	return nil
end

local function parse_autolink(text, pos)
	if text:sub(pos, pos) ~= "<" then
		return nil
	end
	local end_pos = text:find(">", pos + 1, true)
	if not end_pos then
		return nil
	end
	local body = text:sub(pos + 1, end_pos - 1)
	if body:match("^%a[%w+.-]*:") then
		return { kind = "autolink", end_pos = end_pos, destination = body, label = body }
	end
	if body:match("^[%w._%%+-]+@[%w.-]+%.[%a][%a]+$") then
		return { kind = "email", end_pos = end_pos, destination = body, label = body }
	end
	return nil
end

local function render_markdown_link_config()
	local ok, state = pcall(require, "render-markdown.state")
	if not ok or type(state.get) ~= "function" then
		return nil
	end

	local ok_config, config = pcall(state.get, vim.api.nvim_get_current_buf())
	if not ok_config or not config or not config.link or config.link.enabled == false then
		return nil
	end
	return config.link
end

local function custom_icon(link_config, destination, fallback)
	if not destination or not link_config or type(link_config.custom) ~= "table" then
		return fallback
	end

	local best_icon = fallback
	local best_priority = -1
	for _, custom in pairs(link_config.custom) do
		local pattern = custom.pattern
		if pattern then
			local matches = false
			if custom.kind == "suffix" then
				matches = vim.endswith(destination, pattern)
			else
				matches = destination:find(pattern) ~= nil
			end
			if matches then
				local priority = custom.priority or #pattern
				if priority > best_priority then
					best_priority = priority
					best_icon = custom.icon or best_icon
				end
			end
		end
	end

	return best_icon
end

local function link_icon(kind, destination)
	local config = render_markdown_link_config()
	if not config then
		return ""
	end

	local icon = ""
	if kind == "wiki" then
		if not config.wiki or config.wiki.enabled == false then
			return ""
		end
		icon = config.wiki.icon or ""
	elseif kind == "image" then
		icon = config.image or ""
	elseif kind == "email" then
		icon = config.email or ""
	elseif kind == "inline" or kind == "autolink" then
		icon = config.hyperlink or ""
	end

	return custom_icon(config, destination, icon)
end

local entities = {
	["&nbsp;"] = " ",
	["&ensp;"] = " ",
	["&emsp;"] = " ",
	["&lt;"] = "<",
	["&gt;"] = ">",
	["&amp;"] = "&",
	["&quot;"] = '"',
}

local function parse_entity(text, pos)
	local semi = text:find(";", pos, true)
	if not semi or semi - pos > 10 then
		return nil
	end
	local entity = text:sub(pos, semi)
	local rendered = entities[entity]
	if rendered then
		return { end_pos = semi, text = rendered }
	end
	return nil
end

local function find_closing_delimiter(text, pos, delimiter)
	local search_from = pos + #delimiter
	while search_from <= #text do
		local found = text:find(delimiter, search_from, true)
		if not found then
			return nil
		end
		if text:sub(found - 1, found - 1) ~= "\\" then
			return found
		end
		search_from = found + #delimiter
	end
	return nil
end

local function parse_delimited(text, pos, delimiter)
	if not starts_with(text, pos, delimiter) then
		return nil
	end
	local close_pos = find_closing_delimiter(text, pos, delimiter)
	if not close_pos then
		return nil
	end
	local inner = text:sub(pos + #delimiter, close_pos - 1)
	if inner == "" or inner:match("^%s") or inner:match("%s$") then
		return nil
	end
	return {
		end_pos = close_pos + #delimiter - 1,
		text = inner,
	}
end

local render_inline

render_inline = function(text, depth)
	if depth > 8 then
		return text
	end

	local out = {}
	local pos = 1
	while pos <= #text do
		local wiki = parse_wiki_link(text, pos)
		if wiki then
			local config = render_markdown_link_config()
			local label = wiki.label
			if config and config.wiki and config.wiki.conceal_destination == false and wiki.alias then
				label = wiki.destination .. "|" .. wiki.alias
			end
			out[#out + 1] = link_icon("wiki", wiki.destination) .. render_inline(label, depth + 1)
			pos = wiki.end_pos + 1
			goto continue
		end

		local markdown_link = parse_markdown_link(text, pos)
		if markdown_link then
			local icon = link_icon(markdown_link.kind, markdown_link.destination)
			out[#out + 1] = icon .. render_inline(markdown_link.label, depth + 1)
			pos = markdown_link.end_pos + 1
			goto continue
		end

		local autolink = parse_autolink(text, pos)
		if autolink then
			out[#out + 1] = link_icon(autolink.kind, autolink.destination) .. autolink.label
			pos = autolink.end_pos + 1
			goto continue
		end

		local entity = parse_entity(text, pos)
		if entity then
			out[#out + 1] = entity.text
			pos = entity.end_pos + 1
			goto continue
		end

		local ticks = text:match("^`+", pos)
		if ticks then
			local close_pos = text:find(ticks, pos + #ticks, true)
			if close_pos then
				out[#out + 1] = text:sub(pos + #ticks, close_pos - 1)
				pos = close_pos + #ticks
				goto continue
			end
		end

		for _, delimiter in ipairs({ "==", "~~", "***", "___", "**", "__", "*", "_" }) do
			local delimited = parse_delimited(text, pos, delimiter)
			if delimited then
				out[#out + 1] = render_inline(delimited.text, depth + 1)
				pos = delimited.end_pos + 1
				goto continue
			end
		end

		local escaped = text:sub(pos + 1, pos + 1)
		if text:sub(pos, pos) == "\\" and escaped ~= "" and ("[]\\`*_{}()<>#+.!-"):find(escaped, 1, true) then
			out[#out + 1] = text:sub(pos + 1, pos + 1)
			pos = pos + 2
		else
			out[#out + 1] = text:sub(pos, pos)
			pos = pos + 1
		end

		::continue::
	end

	return table.concat(out)
end

function M.visible_text(text)
	return render_inline(text or "", 0)
end

function M.visible_width(text)
	return display_width(M.visible_text(text))
end

local function read_token(text, pos)
	local start_pos = pos
	while pos <= #text do
		if text:sub(pos, pos):match("%s") then
			break
		end

		local wiki = parse_wiki_link(text, pos)
		if wiki then
			pos = wiki.end_pos + 1
			goto continue
		end

		local markdown_link = parse_markdown_link(text, pos)
		if markdown_link then
			pos = markdown_link.end_pos + 1
			goto continue
		end

		local autolink = parse_autolink(text, pos)
		if autolink then
			pos = autolink.end_pos + 1
			goto continue
		end

		local ticks = text:match("^`+", pos)
		if ticks then
			local close_pos = text:find(ticks, pos + #ticks, true)
			if close_pos then
				pos = close_pos + #ticks
				goto continue
			end
		end

		pos = pos + 1

		::continue::
	end

	return text:sub(start_pos, pos - 1), pos
end

local function tokenize(text)
	local tokens = {}
	local pos = 1
	while pos <= #text do
		pos = skip_space(text, pos)
		if pos > #text then
			break
		end
		local token
		token, pos = read_token(text, pos)
		if token ~= "" then
			tokens[#tokens + 1] = token
		end
	end
	return tokens
end

local function split_quote_prefix(line)
	local prefix = ""
	local rest = line

	while true do
		local quote = rest:match("^(%s*>%s?)")
		if not quote then
			break
		end
		prefix = prefix .. quote
		rest = rest:sub(#quote + 1)
	end

	return prefix, rest
end

local function line_prefix(line)
	local quote_prefix, rest = split_quote_prefix(line)
	local consumed = ""
	local indent, marker = rest:match("^([ \t]*)([-+*][ \t]+)")
	if not marker then
		indent, marker = rest:match("^([ \t]*)(%d+[.)][ \t]+)")
	end

	if marker then
		consumed = indent .. marker
		local task = rest:sub(#consumed + 1):match("^(%[[ xX%-~!>]%][ \t]+)")
		if task then
			consumed = consumed .. task
		end
	end

	if consumed ~= "" then
		return {
			first = quote_prefix .. consumed,
			rest = quote_prefix .. string.rep(" ", display_width(consumed)),
			quote = quote_prefix,
			is_list = true,
		}
	end

	return {
		first = quote_prefix,
		rest = quote_prefix,
		quote = quote_prefix,
		is_list = false,
	}
end

local function strip_paragraph_prefix(line, prefix)
	if prefix.first ~= "" and starts_with(line, 1, prefix.first) then
		return line:sub(#prefix.first + 1)
	end
	if prefix.rest ~= "" and starts_with(line, 1, prefix.rest) then
		return line:sub(#prefix.rest + 1)
	end
	if prefix.quote ~= "" and starts_with(line, 1, prefix.quote) then
		return line:sub(#prefix.quote + 1):gsub("^%s+", "")
	end
	return line:gsub("^%s+", "")
end

local function is_blank(line)
	return line:match("^%s*$") ~= nil
end

local function unquoted_body(line)
	local _, rest = split_quote_prefix(line)
	return rest
end

local function is_wrappable_line(line)
	local body = unquoted_body(line)

	if body:match("^%s*#") then
		return false
	end
	if body:match("^%s*[%-%*_][%s%-%*_]*$") then
		return false
	end
	if body:match("^%s*%[.+%]:") then
		return false
	end
	if body:match("^%s*|") then
		return false
	end
	if body:match("^%s*</?%w") then
		return false
	end

	return true
end

local function fence_marker(line)
	return line:match("^%s*(```+)") or line:match("^%s*(~~~+)")
end

local function is_closing_fence(line, marker)
	if not marker then
		return false
	end
	local opener = marker:sub(1, 1)
	local candidate = line:match("^%s*([" .. opener .. "]+)")
	return candidate ~= nil and #candidate >= #marker
end

local function starts_new_paragraph(current, prefix)
	if prefix.is_list then
		return true
	end
	if current.prefix.quote ~= prefix.quote then
		return true
	end
	if current.prefix.is_list and prefix.quote ~= current.prefix.quote then
		return true
	end
	return false
end

local function paragraph_text(paragraph)
	local parts = {}
	for _, line in ipairs(paragraph.lines) do
		local part = strip_paragraph_prefix(line, paragraph.prefix)
		part = part:gsub("^%s+", ""):gsub("%s+$", "")
		if part ~= "" then
			parts[#parts + 1] = part
		end
	end
	return table.concat(parts, " "):gsub("%s+", " ")
end

local function wrap_paragraph(paragraph, width)
	local text = paragraph_text(paragraph)
	if text == "" then
		return paragraph.lines
	end

	local tokens = tokenize(text)
	if #tokens == 0 then
		return paragraph.lines
	end

	local output = {}
	local current = ""
	local current_width = 0
	local line_index = 1

	local function prefix_for_current_line()
		if line_index == 1 then
			return paragraph.prefix.first
		end
		return paragraph.prefix.rest
	end

	local function current_budget()
		local budget = width - display_width(prefix_for_current_line())
		return math.max(budget, 20)
	end

	local function flush()
		if current == "" then
			return
		end
		output[#output + 1] = prefix_for_current_line() .. current
		current = ""
		current_width = 0
		line_index = line_index + 1
	end

	for _, token in ipairs(tokens) do
		local token_width = M.visible_width(token)
		if current == "" then
			current = token
			current_width = token_width
		elseif current_width + 1 + token_width > current_budget() then
			flush()
			current = token
			current_width = token_width
		else
			current = current .. " " .. token
			current_width = current_width + 1 + token_width
		end
	end

	flush()
	return output
end

function M.wrap_lines(lines, width)
	width = width or DEFAULT_WIDTH
	local output = {}
	local current = nil
	local active_fence = nil
	local in_frontmatter = false

	local function flush()
		if not current then
			return
		end
		local wrapped = wrap_paragraph(current, width)
		for _, line in ipairs(wrapped) do
			output[#output + 1] = line
		end
		current = nil
	end

	for index, line in ipairs(lines) do
		if index == 1 and line:match("^%s*---%s*$") then
			flush()
			in_frontmatter = true
			output[#output + 1] = line
			goto continue
		end

		if in_frontmatter then
			output[#output + 1] = line
			if index > 1 and (line:match("^%s*---%s*$") or line:match("^%s*%.%.%.%s*$")) then
				in_frontmatter = false
			end
			goto continue
		end

		if active_fence then
			output[#output + 1] = line
			if is_closing_fence(line, active_fence) then
				active_fence = nil
			end
			goto continue
		end

		local marker = fence_marker(line)
		if marker then
			flush()
			active_fence = marker
			output[#output + 1] = line
			goto continue
		end

		if is_blank(line) or not is_wrappable_line(line) then
			flush()
			output[#output + 1] = line
			goto continue
		end

		local prefix = line_prefix(line)
		if current and starts_new_paragraph(current, prefix) then
			flush()
		end

		if not current then
			current = { prefix = prefix, lines = {} }
		end
		current.lines[#current.lines + 1] = line

		::continue::
	end

	flush()
	return output
end

function M.format_range(opts)
	opts = opts or {}
	local bufnr = opts.bufnr or 0
	local start_lnum = opts.start_lnum or 1
	local end_lnum = opts.end_lnum or vim.api.nvim_buf_line_count(bufnr)
	local width = opts.width or vim.bo[bufnr].textwidth
	if width == 0 then
		width = DEFAULT_WIDTH
	end

	local lines = vim.api.nvim_buf_get_lines(bufnr, start_lnum - 1, end_lnum, false)
	local wrapped = M.wrap_lines(lines, width)
	vim.api.nvim_buf_set_lines(bufnr, start_lnum - 1, end_lnum, false, wrapped)

	local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
	if ok and parser then
		parser:invalidate()
	end
end

function M.format_buffer()
	local view = vim.fn.winsaveview()
	M.format_range({ bufnr = 0 })
	vim.fn.winrestview(view)
end

function M.format_visual()
	local start_lnum = vim.fn.line("v")
	local end_lnum = vim.fn.line(".")
	if start_lnum > end_lnum then
		start_lnum, end_lnum = end_lnum, start_lnum
	end

	local view = vim.fn.winsaveview()
	M.format_range({ bufnr = 0, start_lnum = start_lnum, end_lnum = end_lnum })
	vim.fn.winrestview(view)
end

function M.formatexpr()
	if vim.v.char ~= "" or vim.fn.mode() ~= "n" then
		return 1
	end

	M.format_range({
		bufnr = 0,
		start_lnum = vim.v.lnum,
		end_lnum = vim.v.lnum + vim.v.count - 1,
	})
	return 0
end

return M
