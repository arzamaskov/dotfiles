-- [[ Install `lazy.nvim` plugin manager ]]
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)
require('lazy').setup({
  -- Speeding up
  { 'lewis6991/impatient.nvim' },
  { 'nvim-lua/plenary.nvim' },

  -- File Explorer
  -- { "stevearc/oil.nvim" },
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons', -- optional
    },
  },
  -- {
  --   "nvim-neo-tree/neo-tree.nvim",
  --   branch = "v3.x",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
  --     "MunifTanjim/nui.nvim",
  --     -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
  --   }
  -- },

  -- Search
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.4',
    dependencies = {
      'nvim-telescope/telescope-live-grep-args.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
    },
  },
  { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },

  -- Languages parser
  {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      local ts_update =
        require('nvim-treesitter.install').update { with_sync = true }
      ts_update()
    end,
    dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
  },

  { 'nvim-treesitter/nvim-treesitter-context' },

  -- Colorscheme
  {
    'rose-pine/neovim',
    as = 'rose-pine',
    config = function()
      vim.cmd 'colorscheme rose-pine'
    end,
  },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
  },

  { 'nvim-tree/nvim-web-devicons' },

  -- LSP plugins
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v1.x',
    dependencies = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-nvim-lua' },

      -- Snippets
      { 'L3MON4D3/LuaSnip' },
      { 'rafamadriz/friendly-snippets' },

      -- Formatter
      { 'mhartington/formatter.nvim' },
    },
  },

  -- Git plugins
  { 'tpope/vim-fugitive' },
  { 'lewis6991/gitsigns.nvim' },

  -- Better editing
  { 'tpope/vim-surround' },
  { 'tpope/vim-repeat' },
  { 'tpope/vim-unimpaired' },

  -- Additional syntax
  { 'jwalton512/vim-blade' },
  { 'blueyed/smarty.vim' },
  { 'tpope/vim-liquid' },

  -- Code statistics
  { 'wakatime/vim-wakatime' },

  -- Send selected content in Carbon
  { 'kristijanhusak/vim-carbon-now-sh' },

  -- Comments
  { 'numToStr/Comment.nvim' },

  -- Refactor plugins
  { 'windwp/nvim-spectre' },
  { 'ntpeters/vim-better-whitespace' },

  -- Annotation generator
  {
    'danymat/neogen',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
  },

  -- Displays a popup with possible key bindings
  {
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end,
  },

  -- Closing buffers
  { 'moll/vim-bbye' },

  -- Split block and join lines
  { 'Wansmer/treesj' },

  {
    'andymass/vim-matchup',
    setup = function()
      -- may set any options here
      vim.g.matchup_matchparen_offscreen = { method = 'popup' }
    end,
  },
  { 'pixelastic/vim-undodir-tree' },

  -- Undo tree
  { 'jiaoshijie/undotree' },

  -- Displays LSP symbols
  -- { "liuchengxu/vista.vim" },
  -- { "preservim/tagbar" },

  -- Colors highlighting
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  },
  {
    'projekt0n/github-nvim-theme',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require('github-theme').setup {}
    end,
  },
  {
    'Verf/deepwhite.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd [[colorscheme deepwhite]]
    end,
  },

  {
    'ronisbr/nano-theme.nvim',
    init = function()
      -- vim.o.background = 'light' -- or "dark".
    end,
  },
}, {
  dev = {
    path = '~/Develop/nvim-plugins',
    fallback = false,
  },
  ui = {
    icons = {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      source = '📄',
      start = '🚀',
      task = '📌',
    },
  },
})
