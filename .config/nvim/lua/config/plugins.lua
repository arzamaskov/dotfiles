-- Plugin loading depends on leaders and provider settings being initialized first.
require("config.options")

local pack_group = vim.api.nvim_create_augroup("config_pack", { clear = true })
vim.api.nvim_create_autocmd("PackChanged", {
  group = pack_group,
  callback = function(args)
    local data = args.data or {}
    if data.kind == "update" and data.spec and data.spec.name == "nvim-treesitter" then
      vim.notify("nvim-treesitter changed; run :TSUpdate, then restart Neovim", vim.log.levels.INFO)
    end
  end,
})

vim.pack.add({
  "https://github.com/mattn/emmet-vim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/folke/which-key.nvim",

  "https://github.com/Wansmer/treesj",
  "https://github.com/wakatime/vim-wakatime",

  "https://github.com/tpope/vim-surround",
  "https://github.com/tpope/vim-repeat",
})
