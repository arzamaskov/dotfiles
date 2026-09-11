local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Keep the sign column visible to prevent text from shifting.
opt.signcolumn = 'yes'

-- Keep some context around the cursor while scrolling.
opt.scrolloff = 4
opt.sidescrolloff = 8

-- Editing
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2

opt.smartindent = true
opt.wrap = false

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

-- Files
opt.swapfile = false
opt.backup = false
opt.writebackup = false

opt.undofile = true

-- Update externally changed files automatically.
opt.autoread = true

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Command line completion
opt.wildmode = 'longest:full,full'

-- Mouse
opt.mouse = 'a'

-- Timing
opt.updatetime = 250
opt.timeoutlen = 400

-- Appearance
opt.termguicolors = true

-- Ask for confirmation instead of failing when an operation would
-- otherwise discard unsaved changes.
opt.confirm = true


