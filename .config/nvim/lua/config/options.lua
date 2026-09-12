-- Отключаем unnamedplus
vim.opt.clipboard = ""

-- Русская раскладка в Normal mode
vim.o.langmap =
  "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz"

-- Перенос длинных строк
vim.opt.wrap = true

-- Вертикальная граница длины строки
vim.opt.colorcolumn = "80"

-- PHP / Laravel
vim.g.lazyvim_php_lsp = "intelephense"

-- Отключаем анимацию
vim.g.snacks_animate = false
