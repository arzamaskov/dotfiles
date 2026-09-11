-- System clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p', { desc = 'Paste from system clipboard' })

-- Buffers
vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<cr>', { desc = 'Delete buffer' })

-- Search
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<cr>', { desc = 'Clear search highlight' })

-- File tree
vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<cr>', {
  desc = 'Toggle file tree',
})

vim.keymap.set('n', '<C-n>', '<cmd>NvimTreeFindFile<cr>', {
  desc = 'Reveal current file in tree',
})
