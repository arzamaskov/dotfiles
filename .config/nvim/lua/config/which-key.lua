local wk = require('which-key')

wk.setup({
  preset = 'classic',
  delay = 200,

  icons = {
    mappings = false,
  },
})

wk.add({
  { '<leader>b', group = 'buffer' },
  { '<leader>c', group = 'code' },
  { '<leader>f', group = 'file/find' },
  { '<leader>s', group = 'search' },
})
