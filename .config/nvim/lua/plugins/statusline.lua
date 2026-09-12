return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections.lualine_a = {
        "mode",
      }

      opts.sections.lualine_b = {
        "branch",
      }

      opts.sections.lualine_c = {
        LazyVim.lualine.pretty_path(),
      }

      opts.sections.lualine_x = {
        "encoding",
        "fileformat",
      }

      opts.sections.lualine_y = {
        "location",
      }

      opts.sections.lualine_z = {}
    end,
  },
}
