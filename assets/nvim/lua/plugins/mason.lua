vim.pack.add({
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
})

require("mason").setup()
require("mason-tool-installer").setup({
  ensure_installed = {
    "lua-language-server",
    "typescript-language-server",
    "tailwindcss-language-server",
    "vue-language-server",
    "oxlint",
    "oxfmt",
    "ruff",
    "pyright",
    "ocaml-lsp",
    "ocamlformat",
  },
  auto_update = false,
})
