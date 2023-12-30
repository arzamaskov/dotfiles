vim.keymap.set(
  'n',
  '<leader>pr',
  "<cmd>lua require('spectre').open_visual({select_word=true})<CR>",
  {
    silent = true,
    noremap = true,
    desc = 'Spectre: open visual toolbar with current word',
  }
)
vim.keymap.set(
  'v',
  '<leader>pr',
  "<cmd>lua require('spectre').open_visual()<CR>",
  { silent = true, noremap = true, desc = 'Spectre: open visual toolbar' }
)
