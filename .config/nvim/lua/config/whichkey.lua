require("config.plugins")

require("which-key").setup({
  delay = 200,
  icons = {
    mappings = false,
  },
  spec = {
    { "<leader>c", group = "Code", mode = { "n", "x" } },
    { "<leader>f", group = "Find" },
    { "<leader>g", group = "Git" },
    { "<leader>q", group = "Quickfix" },
    { "<leader>s", group = "Search" },
    { "<leader>x", group = "Diagnostics" },
  },
})
