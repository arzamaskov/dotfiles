local function explorer_add(picker)
  local input = Snacks.input

  Snacks.input = function(opts, callback)
    opts.prompt = "New path: "
    vim.ui.input(opts, callback)
  end

  local ok, err = pcall(require("snacks.explorer.actions").actions.explorer_add, picker)

  Snacks.input = input

  if not ok then
    error(err)
  end
end

return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = { enabled = false },
      scroll = { enabled = false },
      notifier = { enabled = false },
      input = { enabled = false },

      picker = {
        sources = {
          explorer = {
            actions = {
              -- Explorer вызывает Snacks.input напрямую.
              -- Используем обычную командную строку Vim с коротким prompt.
              explorer_add = explorer_add,
            },
          },
        },
      },
    },
  },
}
