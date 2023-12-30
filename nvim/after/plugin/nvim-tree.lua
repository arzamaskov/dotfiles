-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
require('nvim-tree').setup()

-- OR setup with some options
require('nvim-tree').setup {
  sort_by = 'case_sensitive',
  view = {
    width = 50,
  },
  renderer = {
    group_empty = true,
  },
  git = {
    enable = true,
    show_on_dirs = true,
    show_on_open_dirs = true,
    disable_for_dirs = {},
    timeout = 400,
    cygwin_support = false,
  },
  filters = {
    dotfiles = true,
  },
}
