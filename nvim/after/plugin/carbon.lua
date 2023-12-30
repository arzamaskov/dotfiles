-- Send selected content in Carbon
vim.keymap.set(
  'v',
  '<F9>',
  ':CarbonNowSh<CR>',
  { noremap = true, silent = true, desc = 'Send block of code to Carbon' }
)
