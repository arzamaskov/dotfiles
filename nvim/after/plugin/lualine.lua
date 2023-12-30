-- local custom_onelight = require("lualine.themes.solarized_light")
-- custom_onelight.normal.c.bg = "#ffdead"

require('lualine').setup {
  options = {
    icons_enabled = false,
    -- theme = custom_onelight,
    theme = 'auto',
    component_separators = { left = '|', right = '|' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = { 'alpha' },
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = true,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    },
    'windows',
    filetype_names = {
      TelescopePrompt = 'Telescope',
      dashboard = 'Dashboard',
      packer = 'Packer',
      fzf = 'FZF',
      alpha = 'Alpha',
    }, -- Shows specific window name for that filetype ( { `filetype` = `window_name`, ... } )
    disabled_buftypes = { 'quickfix', 'prompt' }, -- Hide a window if its buffer's type is disabled
  },
  sections = {
    lualine_a = {
      'mode',
    },
    lualine_b = {
      'branch',
      'diff',
    },
    lualine_c = {
      {
        'filename',
        path = 1,
        symbols = {
          modified = '[+]',
          readonly = '[RO]',
          unnamed = '[scratch]',
        },
      },
    },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = { 'nvim-tree', 'lazy', 'quickfix' },
}
