vim.pack.add({
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
})

local diagnostic_icons = require("config.icons").diagnostics

require("lualine").setup({
  options = {
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
  },
  sections = {
    lualine_b = {
      { "branch", icon = "" },
      { "diff" },
      {
        "diagnostics",
        symbols = {
          error = diagnostic_icons.Error,
          warn = diagnostic_icons.Warn,
          info = diagnostic_icons.Info,
          hint = diagnostic_icons.Hint,
        },
      }
    },
    lualine_x = { "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "" }
  }
})
