return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.sources.default = vim.tbl_filter(function(source)
        return source ~= "buffer"
      end, opts.sources.default)
    end,
  },
}
