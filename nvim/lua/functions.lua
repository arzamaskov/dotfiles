P = function(v)
  print(vim.inspect(v))
  return v
end

RELOAD = function(...)
  return require('plenary.reload').reload_module(...)
end

R = function(name)
  RELOAD(name)
  return require(name)
end

-- function ADD_SEMICOLON()
--   vim.cmd 'normal! A;'
-- end
