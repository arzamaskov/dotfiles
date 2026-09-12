return {
  {
    "folke/noice.nvim",
    enabled = false,
  },

  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        enabled = false,
      },
      scroll = {
        enabled = false,
      },
      notifier = {
        enabled = false,
      },
      input = {
        enabled = false,
      },

      picker = {
        sources = {
          explorer = {
            actions = {
              explorer_add = function(picker)
                local input = Snacks.input
                Snacks.input = vim.ui.input

                local ok, err = pcall(require("snacks.explorer.actions").actions.explorer_add, picker)

                Snacks.input = input

                if not ok then
                  error(err)
                end
              end,
            },
          },
        },
      },
    },
  },

  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },
}
