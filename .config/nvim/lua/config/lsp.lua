-- LSP mappings use <leader> keys; ensure leaders are set before registration.
require("config.options")

vim.diagnostic.config({
  underline = false,
  severity_sort = true,
})

vim.lsp.config("lua_ls", {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = {
    { ".luarc.json", ".luarc.jsonc" },
    ".git",
  },
  settings = {},
  before_init = function(_, config)
    local root = config.root_dir and vim.uv.fs_realpath(config.root_dir)
    local nvim_config = vim.uv.fs_realpath(vim.fn.stdpath("config"))
    if not root or not nvim_config or root ~= nvim_config then
      return
    end
    config.settings.Lua = config.settings.Lua or {}
    config.settings.Lua.workspace = config.settings.Lua.workspace or {}
    local library = config.settings.Lua.workspace.library or {}
    config.settings.Lua.workspace.library = library
    local runtime = vim.env.VIMRUNTIME
    for _, path in ipairs(library) do
      if path == runtime then
        return
      end
    end
    table.insert(library, runtime)
  end,
})

local lsp_group = vim.api.nvim_create_augroup("config_lsp", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
  group = lsp_group,
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
      buffer = args.buf,
      desc = "Go to definition",
    })

    if client:supports_method("textDocument/completion") then
      local provider = client.server_capabilities.completionProvider
      if provider then
        provider.triggerCharacters = provider.triggerCharacters or {}
        local chars = {}
        local seen = {}
        for _, char in ipairs(provider.triggerCharacters) do
          if not seen[char] then
            seen[char] = true
            table.insert(chars, char)
          end
        end
        for char in ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"):gmatch(".") do
          if not seen[char] then
            seen[char] = true
            table.insert(chars, char)
          end
        end
        provider.triggerCharacters = chars
      end

      vim.lsp.completion.enable(true, client.id, args.buf, {
        autotrigger = true,
      })
    end

    if client.name == "gopls"
        and vim.bo[args.buf].filetype == "go"
        and client:supports_method("textDocument/codeAction") then
      vim.keymap.set("n", "<leader>ci", function()
        vim.lsp.buf.code_action({
          context = { only = { "source.organizeImports" }, diagnostics = {} },
          apply = true,
        })
      end, { buffer = args.buf, desc = "Organize Go imports" })
    end
  end,
})

vim.lsp.config("gopls", {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  settings = {
    gopls = {
      templateExtensions = { "tmpl", "gotmpl" },
      usePlaceholders = true,
    },
  },
  root_markers = {
    "go.work",
    "go.mod",
    ".git",
  },
})

vim.lsp.enable("gopls")
vim.lsp.enable("lua_ls")
