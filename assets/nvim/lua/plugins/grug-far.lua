vim.pack.add({ "https://github.com/MagicDuck/grug-far.nvim" })

require("grug-far").setup()

vim.keymap.set("n", "<leader>s", "<cmd>GrugFar<cr>", { desc = "Search/replace" })
