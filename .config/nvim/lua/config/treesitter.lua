local treesitter = require('nvim-treesitter')

treesitter.install({ 'go' })

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'go' },
  callback = function()
    vim.treesitter.start()
  end,
})

