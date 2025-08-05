return {
  "stevearc/conform.nvim",
  opts = {
    -- This is the recommended way to set up format on save.
    -- The default in LazyVim is to format on save.
    format_on_save = {
      lsp_format = "fallback",
      timeout_ms = 500,
    },

    -- Define your formatters for each file type
    formatters_by_ft = {
      lua = { "stylua" },
      rust = { "rustfmt" },
      go = { "goimports", "gofmt" },

      -- For javascript, you can use a sub-list to run the first available formatter
      javascript = { { "prettierd", "prettier" } },
      javascriptreact = { { "prettierd", "prettier" } },
      typescript = { { "prettierd", "prettier" } },
      typescriptreact = { { "prettierd", "prettier" } },

      -- This preserves your dynamic Python formatter logic.
      -- It now uses conform's built-in `ruff_fix` and `ruff_format`.
      python = function(bufnr)
        if require("conform").get_formatter_info("ruff_format", bufnr).available then
          return { "ruff_fix", "ruff_format" }
        else
          return { "isort", "black" }
        end
      end,

      -- You can keep your universal formatters
      ["*"] = { "codespell" },
      ["_"] = { "trim_whitespace" },
    },

    -- You no longer need the large custom `formatters` table for `ruff`.
    -- `ruff_fix` and `ruff_format` are built into conform.nvim.
    -- If you need other custom formatters, you would define them here.
    formatters = {},
  },
}
