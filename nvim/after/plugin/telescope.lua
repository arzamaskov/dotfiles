local bind = vim.keymap.set
local builtin = require 'telescope.builtin'

local actions = require 'telescope.actions'
require('telescope').setup {
  defaults = {
    -- Default configuration for telescope goes here:
    -- config_key = value,
    -- initial_mode = "normal",
    use_regex = true,
    path_display = { 'truncate' },
    layout_config = { width = 0.9 },
    mappings = {
      n = {
        ['cd'] = function(prompt_bufnr)
          local selection =
            require('telescope.actions.state').get_selected_entry()
          local dir = vim.fn.fnamemodify(selection.path, ':p:h')
          require('telescope.actions').close(prompt_bufnr)
          -- Depending on what you want put `cd`, `lcd`, `tcd`
          vim.cmd(string.format('silent lcd %s', dir))
        end,
      },
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        ['<C-h>'] = 'which_key',
        -- ["<esc>"] = actions.close,
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
      },
    },
  },
  pickers = {
    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
    undo = {
      -- telescope-undo.nvim config, see below
    },
    buffers = {
      sort_lastused = true,
    },
    find_files = {},
  },
  extensions = {
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
    ['ui-select'] = {
      require('telescope.themes').get_dropdown {
        -- even more opts
      },
    },
  },
}
bind(
  'n',
  '<C-p>',
  require('telescope.builtin').git_files,
  { remap = false, desc = 'Search [G]it [F]iles' }
)
bind(
  'n',
  '<leader>;',
  require('telescope.builtin').buffers,
  { remap = false, desc = '[;] Find existing buffers' }
)
bind(
  'n',
  '<leader>?',
  require('telescope.builtin').oldfiles,
  { remap = false, desc = '[?] Find recently opened files' }
)
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(
    require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
    }
  )
end, { desc = '[/] Fuzzily search in current buffer' })
bind(
  'n',
  '<leader>sf',
  require('telescope.builtin').find_files,
  { remap = false, desc = '[S]earch [F]iles' }
)
bind(
  'n',
  '<leader>gs',
  require('telescope.builtin').git_status,
  { remap = false, desc = '[Search [G]it [S]tatus' }
)
bind('n', '<leader>f', function()
  ---@diagnostic disable-next-line: param-type-mismatch
  builtin.grep_string { search = vim.fn.input 'Grep > ', use_regex = true }
end, { desc = '[F]ind by Grep' })

-- Search with live_grep_args: https://github.com/nvim-telescope/telescope-live-grep-args.nvim
bind(
  'n',
  '<leader>fg',
  ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
  {
    remap = false,
    silent = true,
    desc = '[F]ind by live [G]rep',
  }
)

bind(
  { 'n', 'v' },
  '<leader>F',
  require('telescope.builtin').grep_string,
  { remap = false, desc = '[F]ind current word by [G]rep' }
)
bind(
  'n',
  '<leader>gc',
  require('telescope.builtin').git_commits,
  { remap = false, desc = 'Search [G]it [C]ommit' }
)
bind(
  'n',
  '<leader>ss',
  require('telescope.builtin').builtin,
  { desc = '[S]earch [S]elect Telescope' }
)

require('telescope').load_extension 'fzf'
require('telescope').load_extension 'live_grep_args'
require('telescope').load_extension 'ui-select'
