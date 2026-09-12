local map = vim.keymap.set

-- Русская раскладка в Insert mode
map("i", "<C-х>", "<C-[>", { silent = true })
map("i", "<C-г>", "<C-G>u<C-U>", { silent = true })
map("i", "<C-ц>", "<C-G>u<C-W>", { silent = true })

-- Explorer
map("n", "<C-n>", function()
  Snacks.explorer.reveal()
end, { desc = "Reveal file in explorer" })

-- Buffers
map("n", "<leader>;", function()
  Snacks.picker.buffers({
    sort_lastused = true,
    current = false,
  })
end, { desc = "Recent buffers" })

-- System clipboard
map({ "n", "x" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
map({ "n", "x" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })

map("n", "<leader>cp", function()
  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
  vim.fn.setreg("+", path)
end, { desc = "Copy relative file path" })

-- TreeSJ
map("n", "<leader>j", "<cmd>TSJToggle<cr>", { desc = "Toggle split/join" })
