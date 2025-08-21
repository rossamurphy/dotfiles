return {
  "hrsh7th/nvim-cmp",
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    local cmp = require("cmp")

    -- The `mapping` table below will be merged with LazyVim's defaults.
    opts.mapping = vim.tbl_extend("force", opts.mapping, {
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          -- If the completion window is visible, select the next item
          cmp.select_next_item()
        else
          -- Otherwise, fall back to the default Tab behavior (like indentation)
          fallback()
        end
      end, { "i", "s" }),

      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          -- If the completion window is visible, select the previous item
          cmp.select_prev_item()
        else
          -- Otherwise, fall back to the default Shift-Tab behavior
          fallback()
        end
      end, { "i", "s" }),

      -- Use <Space> to confirm the selected completion
      [" "] = cmp.mapping.confirm({ select = true }),
    })

    -- NOTE: By default, <CR> (Enter) also confirms completion.
    -- If you want ONLY <Space> to confirm, uncomment the line below:
    -- opts.mapping["<CR>"] = nil

    return opts
  end,
}
