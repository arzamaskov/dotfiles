require('treesj').setup {
  opts = { use_default_keymaps = false, max_join_length = 150 },
}
-- For use default preset and it work with dot
vim.keymap.set(
  'n',
  '<leader>j',
  require('treesj').toggle,
  { desc = 'Split or [J]oin the line' }
)
-- For extending default preset with `recursive = true`, but this doesn't work with dot
vim.keymap.set('n', '<leader>J', function()
  require('treesj').toggle { split = { recursive = true } }
end, { desc = 'Split or [J]oin line recursive' })
