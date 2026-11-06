vim.pack.add({ "https://github.com/catppuccin/nvim" })
vim.pack.add({ "https://github.com/0x96f-org/0x96f.nvim" })

require("catppuccin").setup({
  transparent_background = true,
  float = {
    transparent = true,
  },
  no_bold = true,
  no_italic = true,
  custom_highlights = function(colors)
    return {
      SnacksIndentScope = { fg = colors.pink },
      SnacksIndentChunk = { fg = colors.pink },
    }
  end,
})

vim.cmd.colorscheme "catppuccin-mocha"
