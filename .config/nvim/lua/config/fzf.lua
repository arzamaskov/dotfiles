local M = {}

local fzf = require('fzf-lua')

local function project_root()
  return vim.fs.root(0, '.git') or vim.uv.cwd()
end

fzf.setup({
  winopts = {
    split = 'belowright new',
    preview = {
      hidden = true,
    },
  },

  keymap = {
    builtin = {
      true,
      ['<Tab>'] = 'toggle-preview',
    },
  },
})

function M.files()
  fzf.files({
    cwd = project_root(),
  })
end

function M.recent_files()
  fzf.oldfiles({
    cwd = project_root(),
    cwd_only = true,
  })
end

function M.buffers()
  fzf.buffers()
end

function M.live_grep()
  fzf.live_grep({
    cwd = project_root(),
  })
end

function M.grep_word()
  fzf.grep_cword({
    cwd = project_root(),
  })
end

return M
