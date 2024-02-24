-- [[ Install `lazy.nvim` plugin manager ]]
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({

  -- Плагин для улучшения производительности загрузки Neovim
  { "lewis6991/impatient.nvim" },
  -- Вспомогательная библиотека Lua для разработки плагинов Neovim
  { "nvim-lua/plenary.nvim" },

  -- Плагин для отображения дерева файлов в Neovim
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      -- Опциональная зависимость для поддержки иконок
      "nvim-tree/nvim-web-devicons",
    },
  },

  -- Плагин для работы с Telescope - расширяемым плагином для поиска и навигации
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.4",
    dependencies = {
      "nvim-telescope/telescope-live-grep-args.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
  },

  -- Плагин для интеграции FZF с Telescope
  { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },

  -- Тема оформления Rose Pine для Neovim
  {
    "rose-pine/neovim",
    as = "rose-pine",
    config = function()
      vim.cmd("colorscheme rose-pine")
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
  },

  -- Плагин для настройки Lualine - легковесной статусной строки для Neovim
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", opt = true },
  },

  -- Плагин для работы с Git из Vim
  { "tpope/vim-fugitive" },

  -- Плагин для отображения изменений Git в редакторе Neovim
  { "lewis6991/gitsigns.nvim" },

  -- Плагин для удобной работы с обрамлением текста в Vim
  { "tpope/vim-surround" },

  -- Плагин для повторения последней операции в Vim с использованием '.'
  { "tpope/vim-repeat" },

  -- Плагин, добавляющий удобные команды для навигации и редактирования в Vim
  { "tpope/vim-unimpaired" },

  -- Плагин для подсветки синтаксиса Liquid шаблонов в Vim
  { "tpope/vim-liquid" },

  -- Плагин для отслеживания времени, проведенного в редакторе Neovim, с использованием Wakatime
  { "wakatime/vim-wakatime" },

  -- Плагин для быстрого добавления и удаления комментариев в Vim
  { "numToStr/Comment.nvim" },

  --- Плагин для автоматической настройки строки комментария на основе контекста в файле
  { "JoosepAlviste/nvim-ts-context-commentstring" },

  -- Плагин для поиска и замены в проекте в Neovim
  { "windwp/nvim-spectre" },

  -- Плагин для улучшения работы с пробелами и символами табуляции в Vim
  { "ntpeters/vim-better-whitespace" },

  -- phpDocumentor для Vim, автономная версия
  { "mikehaertl/pdv-standalone" },

  -- Плагин для удобного отображения клавишных комбинаций в Neovim
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      })
    end,
  },

  -- Плагин для быстрого закрытия буферов в Vim
  { "moll/vim-bbye" },

  -- Плагин для разделения/объединения блоков кода, таких как массивы, хэши, выражения, объекты, словари и т. д.
  { "Wansmer/treesj" },

  -- Плагин для улучшения работы с парными символами в Vim
  {
    "andymass/vim-matchup",
    setup = function()
      -- may set any options here
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },

  -- Плагин для удобного просмотра и управления деревом отмены в Vim
  { "pixelastic/vim-undodir-tree" },

  -- Плагин для создания древовидного представления истории отмены в Vim
  { "jiaoshijie/undotree" },

  -- Плагин для автоматического выделения цветовых значений в файле Neovim
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },

  -- Плагин для поддержки автодополнения и других возможностей для ЯП в Neovim
  { "neoclide/coc.nvim", branch = "release" },

  -- Плагин для исправления стиля кода на PHP с помощью PHP-CS-Fixer в Vim
  { "stephpy/vim-php-cs-fixer" },

  -- Плагин сниппетов для ускорения написания кода в Vim
  { "honza/vim-snippets" },

  -- Плагин для поддержки синтаксиса в Neovim с помощью Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    -- Обновление Treesitter при первом запуске
    run = function()
      local ts_update =
        require("nvim-treesitter.install").update({ with_sync = true })
      ts_update()
    end,
    -- Зависимость: плагин для автоматической настройки строки комментария на основе контекста
    requires = { "JoosepAlviste/nvim-ts-context-commentstring" },
  },

  -- Плагин для отображения контекста текущего содержимого буфера в Neovim
  { "nvim-treesitter/nvim-treesitter-context" },

  -- Плагин для отображения графа тегов в боковой панели.
  { "preservim/tagbar" },
}, {
  dev = {
    path = "~/Develop/nvim-plugins",
    fallback = false,
  },
  ui = {
    icons = {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      source = "📄",
      start = "🚀",
      task = "📌",
    },
  },
})
