local bg = "#222436"

local groups = { "Normal", "NormalNC", "SignColumn", "EndOfBuffer" }
local group = vim.api.nvim_create_augroup("config_colors", { clear = true })

local function apply()
  local attrs = {}
  for _, name in ipairs(groups) do
    attrs[name] = vim.api.nvim_get_hl(0, { name = name, link = false })
  end
  for _, name in ipairs(groups) do
    attrs[name].bg = bg
    vim.api.nvim_set_hl(0, name, attrs[name])
  end
end

apply()
vim.api.nvim_create_autocmd("ColorScheme", { group = group, callback = apply })
