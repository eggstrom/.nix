local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.formatting.sql_formatter,
        null_ls.builtins.formatting.stylua,
    },
})
