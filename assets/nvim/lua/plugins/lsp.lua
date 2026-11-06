vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/folke/lazydev.nvim",
})

require("lazydev").setup({
  library = {
    { path = "${3rd}/luv/library", words = { "vim%uv" } },
  },
})

local vue_language_server_path = vim.fn.stdpath("data") ..
    "/mason/packages/vue-language-server/node_modules/@vue/language-server"

local vue_plugin = {
  name = "@vue/typescript-plugin",
  location = vue_language_server_path,
  languages = { "vue" },
  configNamespace = "typescript",
}

vim.lsp.config("ts_ls", {
  init_options = {
    plugins = { vue_plugin },
  },
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
  root_markers = { "package.json" },
  single_file_support = false,
})

vim.lsp.config("tailwindcss", {
  capabilities = {
    textDocument = {
      completion = {
        dynamicRegistration = false,
      },
    },
  },
})

vim.lsp.config("oxlint", {
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "json",
    "vue",
    "astro",
    "svelte",
  },
  settings = {
    typeAware = true,
  },
})

vim.lsp.config("pyright", {
  settings = {
    pyright = {
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        ignore = { "*" },
      },
    },
  },
})

vim.lsp.enable({
  "lua_ls",
  "ts_ls",
  "tailwindcss",
  "vue_ls",
  "oxlint",
  "ruff",
  "pyright",
  "ocamllsp",
  "gleam"
})

local diagnostic_icons = require("config.icons").diagnostics

vim.diagnostic.config({
  virtual_text = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = diagnostic_icons.Error,
      [vim.diagnostic.severity.WARN] = diagnostic_icons.Warn,
      [vim.diagnostic.severity.INFO] = diagnostic_icons.Info,
      [vim.diagnostic.severity.HINT] = diagnostic_icons.Hint,
    },
  },
})
