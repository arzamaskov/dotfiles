-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

local time
local profile_info
local should_profile = false
if should_profile then
  local hrtime = vim.loop.hrtime
  profile_info = {}
  time = function(chunk, start)
    if start then
      profile_info[chunk] = hrtime()
    else
      profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
    end
  end
else
  time = function(chunk, start) end
end

local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end
  if threshold then
    table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
  end

  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/arzamaskov/.cache/nvim/packer_hererocks/2.1.1696795921/share/lua/5.1/?.lua;/Users/arzamaskov/.cache/nvim/packer_hererocks/2.1.1696795921/share/lua/5.1/?/init.lua;/Users/arzamaskov/.cache/nvim/packer_hererocks/2.1.1696795921/lib/luarocks/rocks-5.1/?.lua;/Users/arzamaskov/.cache/nvim/packer_hererocks/2.1.1696795921/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/arzamaskov/.cache/nvim/packer_hererocks/2.1.1696795921/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["Comment.nvim"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/Comment.nvim",
    url = "https://github.com/numToStr/Comment.nvim"
  },
  LuaSnip = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["alabaster.nvim"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/alabaster.nvim",
    url = "https://github.com/p00f/alabaster.nvim"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-lua"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/cmp-nvim-lua",
    url = "https://github.com/hrsh7th/cmp-nvim-lua"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  cmp_luasnip = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip"
  },
  ["formatter.nvim"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/formatter.nvim",
    url = "https://github.com/mhartington/formatter.nvim"
  },
  ["friendly-snippets"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/friendly-snippets",
    url = "https://github.com/rafamadriz/friendly-snippets"
  },
  ["gitsigns.nvim"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  ["goyo.vim"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/goyo.vim",
    url = "https://github.com/junegunn/goyo.vim"
  },
  ["impatient.nvim"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/impatient.nvim",
    url = "https://github.com/lewis6991/impatient.nvim"
  },
  ["lsp-zero.nvim"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/lsp-zero.nvim",
    url = "https://github.com/VonHeikemen/lsp-zero.nvim"
  },
  ["lualine.nvim"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/lualine.nvim",
    url = "https://github.com/nvim-lualine/lualine.nvim"
  },
  ["mason-lspconfig.nvim"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/mason-lspconfig.nvim",
    url = "https://github.com/williamboman/mason-lspconfig.nvim"
  },
  ["mason.nvim"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/mason.nvim",
    url = "https://github.com/williamboman/mason.nvim"
  },
  neogen = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/neogen",
    url = "https://github.com/danymat/neogen"
  },
  ["nvim-cmp"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-colorizer.lua"] = {
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14colorizer\frequire\0" },
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua",
    url = "https://github.com/norcalli/nvim-colorizer.lua"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-spectre"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/nvim-spectre",
    url = "https://github.com/windwp/nvim-spectre"
  },
  ["nvim-tree.lua"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/nvim-tree.lua",
    url = "https://github.com/nvim-tree/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-context"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/nvim-treesitter-context",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-context"
  },
  ["nvim-ts-context-commentstring"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/nvim-ts-context-commentstring",
    url = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/nvim-tree/nvim-web-devicons"
  },
  ["oil.nvim"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/oil.nvim",
    url = "https://github.com/stevearc/oil.nvim"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["rose-pine"] = {
    config = { "\27LJ\2\n9\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0\26colorscheme rose-pine\bcmd\bvim\0" },
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/rose-pine",
    url = "https://github.com/rose-pine/neovim"
  },
  ["smarty.vim"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/smarty.vim",
    url = "https://github.com/blueyed/smarty.vim"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim"
  },
  ["telescope-live-grep-args.nvim"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/telescope-live-grep-args.nvim",
    url = "https://github.com/nvim-telescope/telescope-live-grep-args.nvim"
  },
  ["telescope-ui-select.nvim"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/telescope-ui-select.nvim",
    url = "https://github.com/nvim-telescope/telescope-ui-select.nvim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  treesj = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/treesj",
    url = "https://github.com/Wansmer/treesj"
  },
  undotree = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/undotree",
    url = "https://github.com/jiaoshijie/undotree"
  },
  ["vim-bbye"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/vim-bbye",
    url = "https://github.com/moll/vim-bbye"
  },
  ["vim-better-whitespace"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/vim-better-whitespace",
    url = "https://github.com/ntpeters/vim-better-whitespace"
  },
  ["vim-blade"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/vim-blade",
    url = "https://github.com/jwalton512/vim-blade"
  },
  ["vim-carbon-now-sh"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/vim-carbon-now-sh",
    url = "https://github.com/kristijanhusak/vim-carbon-now-sh"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-liquid"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/vim-liquid",
    url = "https://github.com/tpope/vim-liquid"
  },
  ["vim-matchup"] = {
    after_files = { "/Users/arzamaskov/.local/share/nvim/site/pack/packer/opt/vim-matchup/after/plugin/matchit.vim" },
    loaded = true,
    needs_bufread = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/opt/vim-matchup",
    url = "https://github.com/andymass/vim-matchup"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/vim-repeat",
    url = "https://github.com/tpope/vim-repeat"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/vim-surround",
    url = "https://github.com/tpope/vim-surround"
  },
  ["vim-undodir-tree"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/vim-undodir-tree",
    url = "https://github.com/pixelastic/vim-undodir-tree"
  },
  ["vim-unimpaired"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/vim-unimpaired",
    url = "https://github.com/tpope/vim-unimpaired"
  },
  ["vim-wakatime"] = {
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/vim-wakatime",
    url = "https://github.com/wakatime/vim-wakatime"
  },
  ["which-key.nvim"] = {
    config = { "\27LJ\2\n;\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\14which-key\frequire\0" },
    loaded = true,
    path = "/Users/arzamaskov/.local/share/nvim/site/pack/packer/start/which-key.nvim",
    url = "https://github.com/folke/which-key.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Setup for: vim-matchup
time([[Setup for vim-matchup]], true)
try_loadstring("\27LJ\2\nN\0\0\2\0\4\0\0056\0\0\0009\0\1\0005\1\3\0=\1\2\0K\0\1\0\1\0\1\vmethod\npopup!matchup_matchparen_offscreen\6g\bvim\0", "setup", "vim-matchup")
time([[Setup for vim-matchup]], false)
time([[packadd for vim-matchup]], true)
vim.cmd [[packadd vim-matchup]]
time([[packadd for vim-matchup]], false)
-- Config for: nvim-colorizer.lua
time([[Config for nvim-colorizer.lua]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14colorizer\frequire\0", "config", "nvim-colorizer.lua")
time([[Config for nvim-colorizer.lua]], false)
-- Config for: which-key.nvim
time([[Config for which-key.nvim]], true)
try_loadstring("\27LJ\2\n;\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\14which-key\frequire\0", "config", "which-key.nvim")
time([[Config for which-key.nvim]], false)
-- Config for: rose-pine
time([[Config for rose-pine]], true)
try_loadstring("\27LJ\2\n9\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0\26colorscheme rose-pine\bcmd\bvim\0", "config", "rose-pine")
time([[Config for rose-pine]], false)

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end