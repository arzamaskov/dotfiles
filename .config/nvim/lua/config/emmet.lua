vim.g.user_emmet_install_global = 0
vim.g.user_emmet_settings = {
  gotmpl = {
    extends = "html",
  },
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "html", "css", "gotmpl" },
  callback = function()
    vim.cmd.EmmetInstall()
  end,
})
