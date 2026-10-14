vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Неиспользуемые language providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

local o = vim.opt

-- Номера строк
o.number = true
o.relativenumber = true

-- Отступы
o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true

-- Поиск
o.ignorecase = true
o.smartcase = true

-- Интерфейс
o.signcolumn = "yes:2"
o.showmode = true

-- Скроллинг
o.scrolloff = 4
o.sidescrolloff = 8

-- Не переносить длинные строки
o.wrap = false

-- Русскоязычная раскладка
o.langmap =
    "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ," ..
    "фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz"

-- Окна
o.splitright = true
o.splitbelow = true

o.completeopt = { "menuone", "noselect", "popup" }
o.undofile = true
