-- LaTeX snippets for Markdown - only active inside $...$ or $$...$$
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

-- Check if cursor is between dollar signs (inline or display math)
local function in_mathzone()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local cursor_line = cursor[1] - 1  -- 0-indexed
	local cursor_col = cursor[2]
	local bufnr = vim.api.nvim_get_current_buf()

	-- Get all lines before cursor
	local lines_before = vim.api.nvim_buf_get_lines(bufnr, 0, cursor_line, false)
	local current_line = vim.api.nvim_buf_get_lines(bufnr, cursor_line, cursor_line + 1, false)[1] or ""

	-- Build text before cursor
	local before_cursor = table.concat(lines_before, "\n")
	if #before_cursor > 0 then
		before_cursor = before_cursor .. "\n"
	end
	before_cursor = before_cursor .. current_line:sub(1, cursor_col)

	-- Get all lines after cursor
	local total_lines = vim.api.nvim_buf_line_count(bufnr)
	local lines_after = vim.api.nvim_buf_get_lines(bufnr, cursor_line + 1, total_lines, false)
	local after_cursor = current_line:sub(cursor_col + 1)
	if #lines_after > 0 then
		after_cursor = after_cursor .. "\n" .. table.concat(lines_after, "\n")
	end

	-- Count $$ (display math - can span multiple lines)
	local _, before_double = before_cursor:gsub("%$%$", "")
	local _, after_double = after_cursor:gsub("%$%$", "")

	-- If we have odd $$ before and after, we're in display math
	if (before_double % 2 == 1) and (after_double % 2 == 1) then
		return true
	end

	-- For inline math ($...$), only check current line
	local before_line = current_line:sub(1, cursor_col)
	local after_line = current_line:sub(cursor_col + 1)
	local before_clean = before_line:gsub("%$%$", "")
	local after_clean = after_line:gsub("%$%$", "")
	local _, before_single = before_clean:gsub("%$", "")
	local _, after_single = after_clean:gsub("%$", "")

	-- If we have odd $ before and after on same line, we're in inline math
	return (before_single % 2 == 1) and (after_single % 2 == 1)
end

return {
	-- Math environments
	s("beg", {
		t("\\begin{"),
		i(1, "equation"),
		t({"}", "\t"}),
		i(2),
		t({"", "\\end{"}),
		f(function(args) return args[1][1] end, {1}),
		t("}"),
		i(0),
	}, { condition = in_mathzone }),

	s("eq", {
		t({"\\begin{equation}", "\t"}),
		i(1),
		t({"", "\\end{equation}"}),
		i(0),
	}, { condition = in_mathzone }),

	s("align", {
		t({"\\begin{align}", "\t"}),
		i(1),
		t({"", "\\end{align}"}),
		i(0),
	}, { condition = in_mathzone }),

	-- Fractions and common expressions
	s("frac", {
		t("\\frac{"),
		i(1),
		t("}{"),
		i(2),
		t("}"),
		i(0),
	}, { condition = in_mathzone }),

	s("//", {
		t("\\frac{"),
		i(1),
		t("}{"),
		i(2),
		t("}"),
		i(0),
	}, { condition = in_mathzone }),

	-- Integrals
	s("int", {
		t("\\int_{"),
		i(1, "a"),
		t("}^{"),
		i(2, "b"),
		t("} "),
		i(3),
		t(" d"),
		i(4, "x"),
		i(0),
	}, { condition = in_mathzone }),

	s("iinf", {
		t("\\int_{-\\infty}^{\\infty} "),
		i(1),
		t(" d"),
		i(2, "x"),
		i(0),
	}, { condition = in_mathzone }),

	-- Sums and products
	s("sum", {
		t("\\sum_{"),
		i(1, "i=1"),
		t("}^{"),
		i(2, "n"),
		t("} "),
		i(0),
	}, { condition = in_mathzone }),

	s("prod", {
		t("\\prod_{"),
		i(1, "i=1"),
		t("}^{"),
		i(2, "n"),
		t("} "),
		i(0),
	}, { condition = in_mathzone }),

	-- Limits
	s("lim", {
		t("\\lim_{"),
		i(1, "x \\to \\infty"),
		t("} "),
		i(0),
	}, { condition = in_mathzone }),

	-- Matrices
	s("bmat", {
		t({"\\begin{bmatrix}", "\t"}),
		i(1),
		t({"", "\\end{bmatrix}"}),
		i(0),
	}, { condition = in_mathzone }),

	s("pmat", {
		t({"\\begin{pmatrix}", "\t"}),
		i(1),
		t({"", "\\end{pmatrix}"}),
		i(0),
	}, { condition = in_mathzone }),

	s("mat", {
		t({"\\begin{matrix}", "\t"}),
		i(1),
		t({"", "\\end{matrix}"}),
		i(0),
	}, { condition = in_mathzone }),

	-- Vectors and norms
	s("vec", {
		t("\\vec{"),
		i(1),
		t("}"),
		i(0),
	}, { condition = in_mathzone }),

	s("norm", {
		t("\\|"),
		i(1),
		t("\\|"),
		i(0),
	}, { condition = in_mathzone }),

	s("abs", {
		t("|"),
		i(1),
		t("|"),
		i(0),
	}, { condition = in_mathzone }),

	-- Derivatives
	s("dd", {
		t("\\frac{d"),
		i(1),
		t("}{d"),
		i(2, "x"),
		t("}"),
		i(0),
	}, { condition = in_mathzone }),

	s("pd", {
		t("\\frac{\\partial "),
		i(1),
		t("}{\\partial "),
		i(2, "x"),
		t("}"),
		i(0),
	}, { condition = in_mathzone }),

	s("grad", {
		t("\\nabla "),
		i(1),
		i(0),
	}, { condition = in_mathzone }),

	-- Probability and expectation
	s("EE", {
		t("\\mathbb{E}"),
		t("["),
		i(1),
		t("]"),
		i(0),
	}, { condition = in_mathzone }),

	s("PP", {
		t("\\mathbb{P}"),
		t("("),
		i(1),
		t(")"),
		i(0),
	}, { condition = in_mathzone }),

	s("prob", {
		t("P("),
		i(1),
		t(")"),
		i(0),
	}, { condition = in_mathzone }),

	-- Common sets
	s("RR", {
		t("\\mathbb{R}"),
		i(0),
	}, { condition = in_mathzone }),

	s("NN", {
		t("\\mathbb{N}"),
		i(0),
	}, { condition = in_mathzone }),

	s("ZZ", {
		t("\\mathbb{Z}"),
		i(0),
	}, { condition = in_mathzone }),

	s("QQ", {
		t("\\mathbb{Q}"),
		i(0),
	}, { condition = in_mathzone }),

	-- Subscripts and superscripts
	s("__", {
		t("_{"),
		i(1),
		t("}"),
		i(0),
	}, { condition = in_mathzone }),

	s("^^", {
		t("^{"),
		i(1),
		t("}"),
		i(0),
	}, { condition = in_mathzone }),

	-- Greek letters (common in ML)
	s("alpha", { t("\\alpha") }, { condition = in_mathzone }),
	s("beta", { t("\\beta") }, { condition = in_mathzone }),
	s("gamma", { t("\\gamma") }, { condition = in_mathzone }),
	s("delta", { t("\\delta") }, { condition = in_mathzone }),
	s("epsilon", { t("\\epsilon") }, { condition = in_mathzone }),
	s("theta", { t("\\theta") }, { condition = in_mathzone }),
	s("lambda", { t("\\lambda") }, { condition = in_mathzone }),
	s("mu", { t("\\mu") }, { condition = in_mathzone }),
	s("sigma", { t("\\sigma") }, { condition = in_mathzone }),
	s("phi", { t("\\phi") }, { condition = in_mathzone }),
	s("omega", { t("\\omega") }, { condition = in_mathzone }),

	-- Argmax, argmin
	s("argmax", {
		t("\\argmax_{"),
		i(1),
		t("} "),
		i(0),
	}, { condition = in_mathzone }),

	s("argmin", {
		t("\\argmin_{"),
		i(1),
		t("} "),
		i(0),
	}, { condition = in_mathzone }),

	-- Text in math mode
	s("text", {
		t("\\text{"),
		i(1),
		t("}"),
		i(0),
	}, { condition = in_mathzone }),

	-- Bold text in math mode
	s("mathbf", {
		t("\\mathbf{"),
		i(1),
		t("}"),
		i(0),
	}, { condition = in_mathzone }),

	s("bf", {
		t("\\mathbf{"),
		i(1),
		t("}"),
		i(0),
	}, { condition = in_mathzone }),

	-- Roman text in math mode
	s("mathrm", {
		t("\\mathrm{"),
		i(1),
		t("}"),
		i(0),
	}, { condition = in_mathzone }),

	s("rm", {
		t("\\mathrm{"),
		i(1),
		t("}"),
		i(0),
	}, { condition = in_mathzone }),

	-- Cases
	s("cases", {
		t({"\\begin{cases}", "\t"}),
		i(1),
		t({"", "\\end{cases}"}),
		i(0),
	}, { condition = in_mathzone }),
}
