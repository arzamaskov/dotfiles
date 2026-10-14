_G.statusline_git_branch = function()
  local status = vim.b.gitsigns_status_dict

  if not status or not status.head or status.head == "" then
    return ""
  end

  return "[" .. status.head .. "] │ "
end

vim.o.statusline = table.concat({
  " ",
  "%{v:lua.statusline_git_branch()}",
  "%<%f%m",
  "%=",
  "%{&fileencoding ==# '' ? &encoding : &fileencoding}",
  " │ %{&fileformat}",
  " │ %l:%c ",
})
