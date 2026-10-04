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
local group = vim.api.nvim_create_augroup("custom_float_highlights", { clear = true })

local function float_highlights()
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1f2335" })
  vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#565f89", bg = "#1f2335" })
  vim.api.nvim_set_hl(0, "FloatTitle", { fg = "#7aa2f7", bg = "#1f2335", bold = true })

  vim.api.nvim_set_hl(0, "Pmenu", { bg = "#1f2335" })
  vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#2a2f4a" })
  vim.api.nvim_set_hl(0, "PmenuBorder", { fg = "#565f89", bg = "#1f2335" })
end

float_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
  group = group,
  callback = float_highlights,
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
