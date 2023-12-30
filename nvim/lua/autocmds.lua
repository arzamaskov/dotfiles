-- Highlight on yank
vim.api.nvim_exec(
  [[
  augroup textyank
    autocmd!
    autocmd TextYankPost * lua vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 })
  augroup END
]],
  false
)

-- Set auto-indent and other options for specific file types
vim.api.nvim_exec(
  [[
  augroup myfiletypes
    autocmd!
    autocmd FileType ruby,eruby,yaml,typescript,lua set ai sw=2 sts=2 et
    autocmd BufRead,BufNewFile *.env setfiletype sh
    autocmd BufRead,BufNewFile .rgignore setfiletype gitignore
    autocmd BufRead,BufNewFile *.blade.php setfiletype blade
    autocmd BufRead,BufNewFile * if &syntax == '' | set syntax=sh | endif
  augroup END
]],
  false
)
