--------------------------------------------------------------------------------
-- Colorscheme
--------------------------------------------------------------------------------
require("rose-pine").setup({
  -- disable_background = true,
  dark_variant = "moon",
  groups = {
    -- background = "#001e26",
    background_nc = "_experimental_nc",
    panel = "surface",
    panel_nc = "base",
    border = "highlight_med",
    comment = "muted",
    link = "iris",
    punctuation = "subtle",

    error = "love",
    hint = "iris",
    info = "foam",
    warn = "gold",

    git_add = "foam",
    git_change = "rose",
    git_delete = "love",
    git_dirty = "rose",
    git_ignore = "muted",
    git_merge = "iris",
    git_rename = "pine",
    git_stage = "iris",
    git_text = "rose",
  },
  highlight_groups = {},
})

require("catppuccin").setup({
  flavour = "mocha", -- latte, frappe, macchiato, mocha
  background = { -- :h background
    light = "latte",
    dark = "mocha",
  },
  transparent_background = false, -- disables setting the background color.
  show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
  term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
  dim_inactive = {
    enabled = false, -- dims the background color of inactive window
    shade = "dark",
    percentage = 0.15, -- percentage of the shade to apply to the inactive window
  },
  no_italic = false, -- Force no italic
  no_bold = false, -- Force no bold
  no_underline = false, -- Force no underline
  styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
    comments = { "italic" }, -- Change the style of comments
    conditionals = { "italic" },
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
  },
  color_overrides = {},
  custom_highlights = {},
  integrations = {
    cmp = true,
    gitsigns = true,
    nvimtree = true,
    treesitter = true,
    notify = false,
    mini = {
      enabled = true,
      indentscope_color = "",
    },
    -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    coc_nvim = true,
    which_key = false,
    native_lsp = {
      enabled = true,
      virtual_text = {
        errors = { "italic" },
        hints = { "italic" },
        warnings = { "italic" },
        information = { "italic" },
      },
      underlines = {
        errors = { "undercurl" },
        hints = { "undercurl" },
        warnings = { "undercurl" },
        information = { "undercurl" },
      },
      inlay_hints = {
        background = true,
      },
    },
  },
})

function ColorMyPencils(color, background)
  color = color or "rose-pine"
  background = background or "dark"

  vim.cmd.colorscheme(color)
  vim.o.background = background
end

--------------------------------------------------------------------------------
-- Lualine
--------------------------------------------------------------------------------
-- local custom_onelight = require("lualine.themes.solarized_light")
-- custom_onelight.normal.c.bg = "#ffdead"

require("lualine").setup({
  options = {
    icons_enabled = false,
    -- theme = custom_onelight,
    theme = "catppuccin",
    component_separators = { left = "|", right = "|" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {
      statusline = { "alpha" },
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
    "windows",
    filetype_names = {
      TelescopePrompt = "Telescope",
      dashboard = "Dashboard",
      packer = "Packer",
      fzf = "FZF",
      alpha = "Alpha",
    }, -- Shows specific window name for that filetype ( { `filetype` = `window_name`, ... } )
    disabled_buftypes = { "quickfix", "prompt" }, -- Hide a window if its buffer's type is disabled
  },
  sections = {
    lualine_a = {
      "mode",
    },
    lualine_b = {
      "branch",
      "diff",
    },
    lualine_c = {
      {
        "filename",
        path = 1,
        symbols = {
          modified = "[+]",
          readonly = "[RO]",
          unnamed = "[scratch]",
        },
      },
    },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = { "nvim-tree", "lazy", "quickfix" },
})

--------------------------------------------------------------------------------
-- Colorscheme function
--------------------------------------------------------------------------------
ColorMyPencils("catppuccin", "dark")
