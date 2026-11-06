vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/mks-h/treesitter-autoinstall.nvim" },
})

require("treesitter-autoinstall").setup()
