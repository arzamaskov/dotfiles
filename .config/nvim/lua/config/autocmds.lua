-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove("o")
  end,
  desc = "Do not continue comments automatically",
})

local group = vim.api.nvim_create_augroup("custom_float_highlights", { clear = true })

local function float_highlights()
  vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
  vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#d0d7de", bg = "NONE" })
  -- Показываем ~ после конца файла
  vim.api.nvim_set_hl(0, "EndOfBuffer", { link = "LineNr" })
end

float_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
  group = group,
  callback = float_highlights,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(event)
    vim.schedule(function()
      for _, win in ipairs(vim.fn.win_findbuf(event.buf)) do
        local config = vim.api.nvim_win_get_config(win)

        if config.relative ~= "" then
          vim.api.nvim_set_option_value("spell", false, { win = win })
        end
      end
    end)
  end,
  desc = "Disable spell checking in Markdown floats",
})
