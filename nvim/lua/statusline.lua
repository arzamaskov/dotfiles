vim.cmd([[
  set laststatus=2
  set statusline=
  set statusline+=%F
  set statusline+=\ 
  set statusline+=%r
  set statusline+=\ 
  set statusline+=%m
  set statusline+=%=
  set statusline+=%{exists('b:gitbranch')?b:gitbranch:''}
  set statusline+=%y
  set statusline+=\ 
  set statusline+=[%{strlen(&fenc)?&fenc:'none'}:%{&ff}]
  set statusline+=\ 
  set statusline+=[line:%l/%L]
  set statusline+=\ 
  set statusline+=col:%03c
  set statusline+=\ 
  set statusline+=%P
]])
