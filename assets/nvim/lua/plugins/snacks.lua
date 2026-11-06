vim.pack.add({
  "https://github.com/folke/snacks.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
})

local diagnostic_icons = require("config.icons").diagnostics

require("snacks").setup({
  input = { enabled = true },
  picker = {
    enabled = true,
    icons = {
      diagnostics = diagnostic_icons,
    },
  },
  git = { enabled = true },
  scope = { enabled = true },
  indent = {
    enabled = true,
    indent = { enabled = false },
    scope = { enabled = true },
    chunk = {
      enabled = true,
      char = {
        arrow = "─",
        corner_top = "╭",
        corner_bottom = "╰"
      },
    },
  },
  styles = {
    snacks_image = {
      relative = "editor",
      row = 0,
      col = -1,
    },
  },
  image = {
    enabled = true,
    doc = {
      inline = false,
      float = true,
      max_width = 20,
      max_height = 20,
    },
  },
  notifier = {
    enabled = true,
    icons = {
      error = diagnostic_icons.Error,
      warn = diagnostic_icons.Warn,
      info = diagnostic_icons.Info,
    },
  },
})

vim.api.nvim_create_autocmd("LspProgress", {
  callback = function(ev)
    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    vim.notify(vim.lsp.status(), "info", {
      id = "lsp_progress",
      title = "LSP Progress",
      opts = function(notif)
        notif.icon = ev.data.params.value.kind == "end" and " "
            or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})

vim.keymap.set("n", "<leader><space>", function() Snacks.picker.smart() end, { desc = "Smart Find Files" })
vim.keymap.set("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fc", function() Snacks.picker.colorschemes() end, { desc = "Colorschemes" })
vim.keymap.set("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", function() Snacks.picker.grep() end, { desc = "Grep" })
vim.keymap.set("n", "<leader>fp", function() Snacks.picker.projects() end, { desc = "Projects" })
vim.keymap.set("n", "<leader>fd", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" })

vim.keymap.set("n", "<leader>gd", function() Snacks.picker.git_diff() end, { desc = "Git Diff (Hunks)" })
vim.keymap.set("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit" })

vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Goto Definition" })
vim.keymap.set("n", "gr", function() Snacks.picker.lsp_references() end, { nowait = true, desc = "References" })
vim.keymap.set("n", "gi", function() Snacks.picker.lsp_implementations() end, { desc = "Goto Implementation" })
vim.keymap.set("n", "<leader>fs", function() Snacks.picker.lsp_symbols() end, { desc = "LSP Symbols" })

vim.keymap.set("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
vim.keymap.set("n", "<leader>bdo", function() Snacks.bufdelete.other() end, { desc = "Delete All Other Buffers" })
vim.keymap.set("n", "<leader>bda", function() Snacks.bufdelete.all() end, { desc = "Delete All Buffers" })
