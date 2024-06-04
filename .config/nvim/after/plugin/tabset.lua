require("tabset").setup({
    defaults = {
        tabwidth = 4,
        expandtab = true
    },
    languages = {
        mdx = {
            tabwidth = 2,
            expandtab = true
        },
        make = {
            tabwidth = 4,
						-- expandtab false means use tabs
            expandtab = false
        },
        go = {
            tabwidth = 4,
            expandtab = false
        },
        lua = {
            tabwidth = 2,
            expandtab = false
        },
        {
            filetypes = {"javascript", "typescript", "javascriptreact", "typescriptreact"},
            config = {
                tabwidth = 2
            },
						expandtab = true
        },
        {
            filetypes = {"markdown","json", "yaml"},
            config = {
                tabwidth = 2
            }
        }
    }
})
