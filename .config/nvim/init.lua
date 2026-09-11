vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('config.options')

-- Install and load plugins first.
require('config.plugins')

-- Configure plugins.
require('config.colorscheme')
require('config.nvim-tree')
require('config.fzf')
require('config.treesitter')
require('config.gitsigns')
require('config.lsp')

-- Keymaps may depend on configured plugins.
require('config.keymaps')
require('config.which-key')
