vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

vim.cmd([[
  augroup myfiletypes
      autocmd!
      autocmd FileType ruby,eruby,yaml,typescript,lua set ai sw=2 sts=2 et
      autocmd FileType *.twig :call CocAction('activeExtension', 'coc-html')
      autocmd BufRead,BufNewFile *.env setfiletype sh
      autocmd BufRead,BufNewFile .rgignore setfiletype gitignore
      autocmd BufRead,BufNewFile *.blade.php setfiletype blade
      autocmd BufRead,BufNewFile * if &syntax == '' | set syntax=sh | endif
  augroup END
]])

vim.api.nvim_create_augroup("CocGroup", {})
-- Setup formatexpr specified filetype(s)
vim.api.nvim_create_autocmd("FileType", {
  group = "CocGroup",
  pattern = "typescript,json",
  command = "setl formatexpr=CocAction('formatSelected')",
  desc = "Setup formatexpr specified filetype(s).",
})

-- Highlight the symbol and its references on a CursorHold event(cursor is idle)
vim.api.nvim_create_autocmd("CursorHold", {
  group = "CocGroup",
  command = "silent call CocActionAsync('highlight')",
  desc = "Highlight symbol under cursor on CursorHold",
})

-- Update signature help on jump placeholder
vim.api.nvim_create_autocmd("User", {
  group = "CocGroup",
  pattern = "CocJumpPlaceholder",
  command = "call CocActionAsync('showSignatureHelp')",
  desc = "Update signature help on jump placeholder",
})
