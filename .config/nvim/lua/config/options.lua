-- Не синхронизируем регистры Vim с системным clipboard
vim.opt.clipboard = ""

-- Русская раскладка в Normal mode
vim.opt.langmap =
  "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz"

vim.opt.wrap = true
vim.opt.cursorline = false
vim.o.winborder = "single"

-- Показываем ~ после конца файла
local fillchars = vim.opt.fillchars:get()
fillchars.eob = "~"
vim.opt.fillchars = fillchars

-- LazyVim / plugins
vim.g.lazyvim_php_lsp = "intelephense"
vim.g.snacks_animate = false
