local fzf = require('config.fzf')

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

-- Fuzzy finder
vim.keymap.set('n', '<leader><space>', fzf.files, {
  desc = 'Find files',
})

vim.keymap.set('n', '<leader>fR', fzf.recent_files, {
  desc = 'Recent files in project',
})

vim.keymap.set('n', '<leader>;', fzf.buffers, {
  desc = 'Buffers',
})

vim.keymap.set('n', '<leader>/', fzf.live_grep, {
  desc = 'Search project',
})

vim.keymap.set('n', '<leader>fw', fzf.grep_word, {
  desc = 'Search word under cursor',
})

-- Gitsigns
vim.keymap.set('n', ']h', function()
  require('gitsigns').nav_hunk('next')
end, { desc = 'Next Git hunk' })

vim.keymap.set('n', '[h', function()
  require('gitsigns').nav_hunk('prev')
end, { desc = 'Previous Git hunk' })
