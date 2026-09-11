vim.lsp.config('gopls', {
  cmd = { 'gopls' },

  filetypes = {
    'go',
    'gomod',
    'gowork',
  },

  root_markers = {
    'go.work',
    'go.mod',
    '.git',
  },
})

vim.diagnostic.config({
  virtual_text = false,
  underline = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = 'E',
      [vim.diagnostic.severity.WARN] = 'W',
      [vim.diagnostic.severity.INFO] = 'I',
      [vim.diagnostic.severity.HINT] = 'H',
    },
  },
})

vim.lsp.config('lua_ls', {
  cmd = { 'lua-language-server' },

  filetypes = {
    'lua',
  },

  root_dir = function(bufnr, on_dir)
    local file = vim.api.nvim_buf_get_name(bufnr)
    local config_dir = vim.fn.stdpath('config')

    if vim.startswith(file, config_dir .. '/') then
      on_dir(config_dir)
      return
    end

    on_dir(vim.fs.root(bufnr, {
      '.luarc.json',
      '.luarc.jsonc',
      '.git',
    }))
  end,

  settings = {
    Lua = {
      workspace = {
        library = {
          vim.env.VIMRUNTIME,
        },
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

vim.lsp.enable({
  'gopls',
  'lua_ls',
})
