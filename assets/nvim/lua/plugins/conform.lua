vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

require("conform").setup({
  formatters_by_ft = {
    javascript = { "oxfmt" },
    javascriptreact = { "oxfmt" },
    typescript = { "oxfmt" },
    typescriptreact = { "oxfmt" },
    json = { "oxfmt" },
    vue = { "oxfmt" },
    python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
    ocaml = { "ocamlformat" },
  },
  format_on_save = {
    lsp_format = "fallback",
  },
})
