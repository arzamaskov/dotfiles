local o = vim.opt_local

o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true
local undo = "setlocal tabstop< shiftwidth< expandtab<"
if not (vim.b.undo_ftplugin or ""):find(undo, 1, true) then
  vim.b.undo_ftplugin = (vim.b.undo_ftplugin and vim.b.undo_ftplugin .. " | " or "") .. undo
end
