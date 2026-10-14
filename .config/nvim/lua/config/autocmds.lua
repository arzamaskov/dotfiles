local group = vim.api.nvim_create_augroup("config_autocmds", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  callback = function()
    -- Продолжать комментарий после Enter,
    -- но не добавлять comment leader после o/O.
    vim.opt_local.formatoptions:append("r")
    vim.opt_local.formatoptions:remove("o")
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line = mark[1]
    local last_line = vim.api.nvim_buf_line_count(0)

    if line > 0 and line <= last_line then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})
