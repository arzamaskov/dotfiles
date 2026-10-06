return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      diagnostics = { virtual_text = false },

      servers = {
        gopls = {
          init_options = {
            semanticTokens = false,
          },
        },

        emmet_language_server = {
          filetypes = {
            "html",
            "css",
            "scss",
            "javascriptreact",
            "typescriptreact",
            "svelte",
            "vue",
            "gotmpl",
          },
        },
      },
    },
  },
}
