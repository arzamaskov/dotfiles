-- Отключаем unnamedplus
vim.opt.clipboard = ""

-- Русская раскладка в Normal mode
vim.o.langmap =
  "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz"

-- Перенос длинных строк
vim.opt.wrap = true

-- PHP / Laravel
vim.g.lazyvim_php_lsp = "intelephense"

-- Отключаем анимацию
vim.g.snacks_animate = false

-- Отключаем подсветку текущей строки
vim.opt.cursorline = false

-- Обводка для всех всплывающих окон
vim.o.winborder = "single"

local fillchars = vim.opt.fillchars:get()
fillchars.eob = "~"
vim.opt.fillchars = fillchars
