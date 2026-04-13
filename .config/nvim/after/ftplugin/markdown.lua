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

-- Conceal-aware formatting: wraps lines based on visible width,
-- so markdown links like [text](url) only count the width of "text".
local function visible_width(str)
  -- Replace markdown links [text](url) with just the text
  local result = str:gsub("%[([^%]]+)%]%(([^%)]+)%)", "%1")
  -- Replace image links ![alt](url) with just the alt
  result = result:gsub("!%[([^%]]*)]%(([^%)]+)%)", "%1")
  return vim.fn.strdisplaywidth(result)
end

local function tokenize(text)
  local tokens = {}
  local pos = 1
  local len = #text

  while pos <= len do
    -- Skip spaces, track them
    if text:sub(pos, pos) == " " then
      pos = pos + 1
    else
      -- Try to match a markdown link starting here: [text](url)
      -- Also handles ![alt](url)
      local link_start = pos
      local prefix = ""
      if text:sub(pos, pos) == "!" and text:sub(pos + 1, pos + 1) == "[" then
        prefix = "!"
        pos = pos + 1
      end

      if text:sub(pos, pos) == "[" then
        local bracket_end = text:find("%]", pos + 1)
        if bracket_end and text:sub(bracket_end + 1, bracket_end + 1) == "(" then
          local paren_end = text:find("%)", bracket_end + 2)
          if paren_end then
            local raw = text:sub(link_start, paren_end)
            table.insert(tokens, raw)
            pos = paren_end + 1
            goto continue
          end
        end
        -- Not a valid link, fall through to plain word
        pos = link_start
      else
        pos = link_start
      end

      -- Plain word: consume until space
      local word_start = pos
      while pos <= len and text:sub(pos, pos) ~= " " do
        -- If we hit a [ that starts a link mid-word (e.g. "foo[bar](baz)"),
        -- consume the link as part of this token
        if text:sub(pos, pos) == "[" then
          local bracket_end = text:find("%]", pos + 1)
          if bracket_end and text:sub(bracket_end + 1, bracket_end + 1) == "(" then
            local paren_end = text:find("%)", bracket_end + 2)
            if paren_end then
              pos = paren_end + 1
              goto word_done
            end
          end
        end
        pos = pos + 1
      end
      ::word_done::
      table.insert(tokens, text:sub(word_start, pos - 1))

      ::continue::
    end
  end

  return tokens
end

local function extract_prefix(line)
  -- Match blockquote and/or list item prefixes
  -- e.g. "> ", "> - ", "  - ", "1. ", "> > "
  local prefix = line:match("^([%s>]*[%->%*%+]%s+)") -- list items
    or line:match("^([%s>]*%d+%.%s+)")                -- numbered lists
    or line:match("^([%s>]+)")                         -- blockquotes only
    or ""
  return prefix
end

local function is_new_paragraph(line)
  -- A line starts a new paragraph if it's:
  -- blank, a list item, a heading, or a blockquote start
  if line:match("^%s*$") then return true end
  if line:match("^%s*[%-%*%+]%s") then return true end
  if line:match("^%s*%d+%.%s") then return true end
  if line:match("^#") then return true end
  return false
end

local function wrap_paragraph(lines, tw)
  local output = {}
  local prefix = extract_prefix(lines[1] or "")
  local stripped = {}
  for _, line in ipairs(lines) do
    local p = extract_prefix(line)
    local content = line:sub(#p + 1)
    table.insert(stripped, content)
  end
  local text = table.concat(stripped, " "):gsub("%s+", " "):gsub("^%s+", "")

  if text == "" then
    return { prefix }
  end

  local tokens = tokenize(text)
  local prefix_vis_w = vim.fn.strdisplaywidth(prefix)
  local continuation = string.rep(" ", prefix_vis_w)
  local budget = tw - prefix_vis_w

  local current_raw = ""
  local current_vis_w = 0
  local is_first_line = true

  for _, token in ipairs(tokens) do
    local tok_vis_w = visible_width(token)

    if current_raw == "" then
      current_raw = token
      current_vis_w = tok_vis_w
    elseif current_vis_w + 1 + tok_vis_w > budget then
      local p = is_first_line and prefix or continuation
      table.insert(output, p .. current_raw)
      is_first_line = false
      current_raw = token
      current_vis_w = tok_vis_w
    else
      current_raw = current_raw .. " " .. token
      current_vis_w = current_vis_w + 1 + tok_vis_w
    end
  end

  if current_raw ~= "" then
    local p = is_first_line and prefix or continuation
    table.insert(output, p .. current_raw)
  end

  return output
end

local function wrap_lines(lines, tw)
  -- Split lines into separate paragraphs, wrap each independently
  local paragraphs = {}
  local current = {}

  for _, line in ipairs(lines) do
    if #current > 0 and is_new_paragraph(line) then
      table.insert(paragraphs, current)
      current = {}
    end
    table.insert(current, line)
  end
  if #current > 0 then
    table.insert(paragraphs, current)
  end

  local output = {}
  for _, para in ipairs(paragraphs) do
    local wrapped = wrap_paragraph(para, tw)
    for _, line in ipairs(wrapped) do
      table.insert(output, line)
    end
  end

  return output
end

vim.bo.formatexpr = "v:lua.MarkdownFormatExpr()"

function MarkdownFormatExpr()
  -- In insert mode, v:char is the typed character (non-empty).
  -- Fall back to Vim's built-in formatter which handles cursor
  -- positioning correctly during auto-wrap while typing.
  if vim.v.char ~= "" then
    return 1
  end

  local lnum = vim.v.lnum
  local count = vim.v.count
  local tw = vim.bo.textwidth
  if tw == 0 then tw = 70 end

  local end_lnum = lnum + count - 1
  local lines = vim.api.nvim_buf_get_lines(0, lnum - 1, end_lnum, false)

  local result = wrap_lines(lines, tw)
  vim.api.nvim_buf_set_lines(0, lnum - 1, end_lnum, false, result)

  -- Force treesitter to reparse so highlighting doesn't reference
  -- stale column positions from before the line change.
  local ok, parser = pcall(vim.treesitter.get_parser, 0)
  if ok and parser then
    parser:invalidate()
  end

  return 0
end
