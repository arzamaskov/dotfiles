local ui_group = vim.api.nvim_create_augroup("custom_ui", { clear = true })

-- Не продолжать комментарий при o/O
vim.api.nvim_create_autocmd("FileType", {
  group = ui_group,
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove("o")
  end,
  desc = "Do not continue comments with o/O",
})

-- UI highlights
local function set_ui_highlights()
  vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
  vim.api.nvim_set_hl(0, "FloatBorder", { link = "WinSeparator" })
  vim.api.nvim_set_hl(0, "EndOfBuffer", { link = "LineNr" })
end

set_ui_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
  group = ui_group,
  callback = set_ui_highlights,
})

-- Не проверять орфографию во всплывающей Markdown-документации
vim.api.nvim_create_autocmd("FileType", {
  group = ui_group,
  pattern = "markdown",
  callback = function(event)
    vim.schedule(function()
      for _, win in ipairs(vim.fn.win_findbuf(event.buf)) do
        if vim.api.nvim_win_get_config(win).relative ~= "" then
          vim.api.nvim_set_option_value("spell", false, { win = win })
        end
      end
    end)
  end,
  desc = "Disable spell checking in Markdown floats",
})
