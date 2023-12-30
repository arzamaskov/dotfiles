-- [[ Configure LSP ]]
local lsp = require 'lsp-zero'
lsp.preset 'recommended'

lsp.ensure_installed {
  'lua_ls',
  -- "eslint",
  -- 'phpactor@2022.11.12',
  -- 'psalm',
  'emmet_ls',
  'intelephense',
}

--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap(
    'gd',
    require('telescope.builtin').lsp_definitions,
    '[G]oto [D]efinition'
  )
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap(
    'gI',
    require('telescope.builtin').lsp_implementations,
    '[G]oto [I]mplementation'
  )
  nmap(
    '<leader>D',
    require('telescope.builtin').lsp_type_definitions,
    'Type [D]efinition'
  )
  nmap(
    '<leader>ds',
    require('telescope.builtin').lsp_document_symbols,
    '[D]ocument [S]ymbols'
  )
  nmap(
    '<leader>ws',
    require('telescope.builtin').lsp_dynamic_workspace_symbols,
    '[W]orkspace [S]ymbols'
  )

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
  vim.keymap.set(
    'i',
    '<C-k>',
    vim.lsp.buf.signature_help,
    { buffer = bufnr, desc = 'Signature Documentation' }
  )

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap(
    '<leader>wa',
    vim.lsp.buf.add_workspace_folder,
    '[W]orkspace [A]dd Folder'
  )
  nmap(
    '<leader>wr',
    vim.lsp.buf.remove_workspace_folder,
    '[W]orkspace [R]emove Folder'
  )
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  -- vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
  --   vim.lsp.buf.format()
  -- end, { desc = 'Format current buffer with LSP' })

  nmap(
    '<leader>xx',
    require('telescope.builtin').diagnostics,
    'Open diagnostics messages'
  )
end

-- document existing key chains
require('which-key').register {
  ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
  ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
  ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
  ['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
  ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
  ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
  ['<leader>t'] = { name = '[T]oggle', _ = 'which_key_ignore' },
  ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
}
-- register which-key VISUAL mode
-- required for visual <leader>hs (hunk stage) to work
require('which-key').register({
  ['<leader>'] = { name = 'VISUAL <leader>' },
  ['<leader>h'] = { 'Git [H]unk' },
}, { mode = 'v' })

lsp.configure('lua_ls', {
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = {
        globals = { 'vim' },
        -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
        disable = { 'missing-fields' },
      },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
})

lsp.configure('emmet_ls', {
  on_attach = on_attach,
  filetypes = {
    'html',
    'typescriptreact',
    'javascriptreact',
    'css',
    'sass',
    'scss',
    'less',
    'smarty',
    'blade',
    'twig',
    'php',
  },
  init_options = {
    html = {
      options = {
        -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
        ['bem.enabled'] = true,
      },
    },
  },
})

lsp.configure('phpactor', {
  on_attach = on_attach,
  filetypes = { 'php', 'twig' },
  init_options = {
    ['symfony.enabled'] = true,
    ['language_server_psalm.enabled'] = true,
  },
  root_dir = function()
    return vim.loop.cwd()
  end,
})

lsp.configure('intelephense', {
  on_attach = on_attach,
  filetypes = { 'php', 'twig' },
  root_dir = function()
    return vim.loop.cwd()
  end,
  init_options = {
    licenceKey = '00P5X2K9NL7QCE3',
  },
  settings = {
    intelephense = {
      telemetry = {
        enabled = false,
      },
      completion = {
        fullyQualifyGlobalConstantsAndFunctions = false,
      },
      returnVoid = false,
    },
  },
})

local cmp = require 'cmp'
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings {
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm { select = true },
  ['<C-Space>'] = cmp.mapping.complete(),
}

lsp.setup_nvim_cmp {
  mapping = cmp_mappings,
}

lsp.set_preferences {
  suggest_lsp_servers = false,
  sign_icons = {
    error = 'E',
    warn = 'W',
    hint = 'H',
    info = 'I',
  },
}

lsp.setup()

-- vim.diagnostic.config({ virtual_text = true })
