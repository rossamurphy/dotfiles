-- LaTeX snippets for ML/AI research
-- These ONLY work in .tex files

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

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
	}),

	s("eq", {
		t({"\\begin{equation}", "\t"}),
		i(1),
		t({"", "\\end{equation}"}),
		i(0),
	}),

	s("align", {
		t({"\\begin{align}", "\t"}),
		i(1),
		t({"", "\\end{align}"}),
		i(0),
	}),

	-- Fractions and common expressions
	s("frac", {
		t("\\frac{"),
		i(1),
		t("}{"),
		i(2),
		t("}"),
		i(0),
	}),

	s("//", {
		t("\\frac{"),
		i(1),
		t("}{"),
		i(2),
		t("}"),
		i(0),
	}),

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
	}),

	s("iinf", {
		t("\\int_{-\\infty}^{\\infty} "),
		i(1),
		t(" d"),
		i(2, "x"),
		i(0),
	}),

	-- Sums and products
	s("sum", {
		t("\\sum_{"),
		i(1, "i=1"),
		t("}^{"),
		i(2, "n"),
		t("} "),
		i(0),
	}),

	s("prod", {
		t("\\prod_{"),
		i(1, "i=1"),
		t("}^{"),
		i(2, "n"),
		t("} "),
		i(0),
	}),

	-- Limits
	s("lim", {
		t("\\lim_{"),
		i(1, "x \\to \\infty"),
		t("} "),
		i(0),
	}),

	-- Matrices
	s("bmat", {
		t({"\\begin{bmatrix}", "\t"}),
		i(1),
		t({"", "\\end{bmatrix}"}),
		i(0),
	}),

	s("pmat", {
		t({"\\begin{pmatrix}", "\t"}),
		i(1),
		t({"", "\\end{pmatrix}"}),
		i(0),
	}),

	s("mat", {
		t({"\\begin{matrix}", "\t"}),
		i(1),
		t({"", "\\end{matrix}"}),
		i(0),
	}),

	-- Vectors and norms
	s("vec", {
		t("\\vec{"),
		i(1),
		t("}"),
		i(0),
	}),

	s("norm", {
		t("\\|"),
		i(1),
		t("\\|"),
		i(0),
	}),

	s("abs", {
		t("|"),
		i(1),
		t("|"),
		i(0),
	}),

	-- Derivatives
	s("dd", {
		t("\\frac{d"),
		i(1),
		t("}{d"),
		i(2, "x"),
		t("}"),
		i(0),
	}),

	s("pd", {
		t("\\frac{\\partial "),
		i(1),
		t("}{\\partial "),
		i(2, "x"),
		t("}"),
		i(0),
	}),

	s("grad", {
		t("\\nabla "),
		i(1),
		i(0),
	}),

	-- Probability and expectation
	s("EE", {
		t("\\mathbb{E}"),
		t("["),
		i(1),
		t("]"),
		i(0),
	}),

	s("PP", {
		t("\\mathbb{P}"),
		t("("),
		i(1),
		t(")"),
		i(0),
	}),

	s("prob", {
		t("P("),
		i(1),
		t(")"),
		i(0),
	}),

	-- Common sets
	s("RR", {
		t("\\mathbb{R}"),
		i(0),
	}),

	s("NN", {
		t("\\mathbb{N}"),
		i(0),
	}),

	s("ZZ", {
		t("\\mathbb{Z}"),
		i(0),
	}),

	s("QQ", {
		t("\\mathbb{Q}"),
		i(0),
	}),

	-- Subscripts and superscripts
	s("__", {
		t("_{"),
		i(1),
		t("}"),
		i(0),
	}),

	s("^^", {
		t("^{"),
		i(1),
		t("}"),
		i(0),
	}),

	-- Greek letters (common in ML)
	s("alpha", { t("\\alpha") }),
	s("beta", { t("\\beta") }),
	s("gamma", { t("\\gamma") }),
	s("delta", { t("\\delta") }),
	s("epsilon", { t("\\epsilon") }),
	s("theta", { t("\\theta") }),
	s("lambda", { t("\\lambda") }),
	s("mu", { t("\\mu") }),
	s("sigma", { t("\\sigma") }),
	s("phi", { t("\\phi") }),
	s("omega", { t("\\omega") }),

	-- Argmax, argmin
	s("argmax", {
		t("\\argmax_{"),
		i(1),
		t("} "),
		i(0),
	}),

	s("argmin", {
		t("\\argmin_{"),
		i(1),
		t("} "),
		i(0),
	}),

	-- Text in math mode
	s("text", {
		t("\\text{"),
		i(1),
		t("}"),
		i(0),
	}),

	-- Bold text in math mode
	s("mathbf", {
		t("\\mathbf{"),
		i(1),
		t("}"),
		i(0),
	}),

	s("bf", {
		t("\\mathbf{"),
		i(1),
		t("}"),
		i(0),
	}),

	-- Roman text in math mode
	s("mathrm", {
		t("\\mathrm{"),
		i(1),
		t("}"),
		i(0),
	}),

	s("rm", {
		t("\\mathrm{"),
		i(1),
		t("}"),
		i(0),
	}),

	-- Cases
	s("cases", {
		t({"\\begin{cases}", "\t"}),
		i(1),
		t({"", "\\end{cases}"}),
		i(0),
	}),
}
