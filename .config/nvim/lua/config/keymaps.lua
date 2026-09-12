local bind = vim.keymap.set
local opts = { silent = true }

-- Русская раскладка
bind("i", "<C-х>", "<C-[>", opts)
bind("i", "<C-г>", "<C-G>u<C-U>", opts)
bind("i", "<C-ц>", "<C-G>u<C-W>", opts)

-- Показать текущий файл в Explorer
bind("n", "<C-n>", function()
  Snacks.explorer.reveal()
end, { desc = "Reveal file in explorer" })

-- Последние буферы
bind("n", "<leader>;", function()
  Snacks.picker.buffers({
    sort_lastused = true,
    current = false,
  })
end, { desc = "Recent buffers" })

-- Системный буфер обмена
bind({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
bind({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })
