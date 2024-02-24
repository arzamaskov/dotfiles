local bind = vim.keymap.set
local cmd = vim.cmd

--------------------------------------------------------------------------------
-- Bbye
--------------------------------------------------------------------------------
bind(
  "n",
  "<leader>q",
  cmd.Bdelete,
  { silent = true, noremap = true, desc = "Close current buffer" }
)

--------------------------------------------------------------------------------
-- NvimTree
--------------------------------------------------------------------------------
bind(
  "n",
  "<leader><leader>",
  cmd.NvimTreeToggle,
  { silent = true, noremap = true, desc = "Open file manager" }
)

bind(
  "n",
  "<C-n>",
  cmd.NvimTreeFindFile,
  { silent = true, noremap = true, desc = "Find file in file manager" }
)

--------------------------------------------------------------------------------
-- Pdv standalone
--------------------------------------------------------------------------------
bind(
  "n",
  "<leader>k",
  cmd.PhpDocSingle,
  { silent = true, noremap = true, desc = "Create PHPDoc" }
)

bind(
  "v",
  "<leader>k",
  cmd.PhpDocRange,
  { silent = true, noremap = true, desc = "Create PHPDoc" }
)

--------------------------------------------------------------------------------
-- Php-cs-fixer
--------------------------------------------------------------------------------
-- bind("n", "<leader>pcd", cmd.PhpCsFixerFixDirectory,
--   { silent = true, noremap = true, desc = "Fix the directory with Php-cs-fixer" }
-- )

bind(
  "n",
  "<leader>cf",
  cmd.PhpCsFixerFixFile,
  { silent = true, noremap = true, desc = "Fix the file with Php-cs-fixer" }
)

--------------------------------------------------------------------------------
-- Spectre
--------------------------------------------------------------------------------
-- bind("n", "<leader>pr", "<cmd>lua require('spectre').open_visual({select_word=true})<CR>",
--   { silent = true, noremap = true, desc = "Spectre: open visual toolbar with current word", })
--
-- bind("v", "<leader>pr", "<cmd>lua require('spectre').open_visual()<CR>",
--   { silent = true, noremap = true, desc = "Spectre: open visual toolbar" })

--------------------------------------------------------------------------------
-- Telescope
--------------------------------------------------------------------------------
local builtin = require("telescope.builtin")

bind(
  "n",
  "<C-p>",
  require("telescope.builtin").git_files,
  { remap = false, desc = "Search [G]it [F]iles" }
)

bind(
  "n",
  "<leader>;",
  require("telescope.builtin").buffers,
  { remap = false, desc = "[;] Find existing buffers" }
)

bind(
  "n",
  "<leader>?",
  require("telescope.builtin").oldfiles,
  { remap = false, desc = "[?] Find recently opened files" }
)

bind("n", "<leader>/", function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require("telescope.builtin").current_buffer_fuzzy_find(
    require("telescope.themes").get_dropdown({
      winblend = 10,
      previewer = false,
    })
  )
end, { desc = "[/] Fuzzily search in current buffer" })

bind(
  "n",
  "<leader>sf",
  require("telescope.builtin").find_files,
  { remap = false, desc = "[S]earch [F]iles" }
)

bind(
  "n",
  "<leader>gs",
  require("telescope.builtin").git_status,
  { remap = false, desc = "[Search [G]it [S]tatus" }
)

bind("n", "<leader>f", function()
  builtin.grep_string({ search = vim.fn.input("Grep > "), use_regex = true })
end, { desc = "[F]ind by Grep" })

-- Search with live_grep_args: https://github.com/nvim-telescope/telescope-live-grep-args.nvim
bind(
  "n",
  "<leader>fg",
  ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
  { remap = false, silent = true, desc = "[F]ind by live [G]rep" }
)

bind(
  { "n", "v" },
  "<leader>F",
  require("telescope.builtin").grep_string,
  { remap = false, desc = "[F]ind current word by [G]rep" }
)

bind(
  "n",
  "<leader>gc",
  require("telescope.builtin").git_commits,
  { remap = false, desc = "Search [G]it [C]ommit" }
)

bind(
  "n",
  "<leader>ss",
  require("telescope.builtin").builtin,
  { desc = "[S]earch [S]elect Telescope" }
)

--------------------------------------------------------------------------------
-- Treesj
--------------------------------------------------------------------------------
-- For use default preset and it work with dot
bind(
  "n",
  "<leader>j",
  require("treesj").toggle,
  { desc = "Split or [J]oin the line" }
)

-- For extending default preset with `recursive = true`, but this doesn't work with dot
bind("n", "<leader>J", function()
  require("treesj").toggle({ split = { recursive = true } })
end, { desc = "Split or [J]oin line recursive" })

--------------------------------------------------------------------------------
-- Undo-tree
--------------------------------------------------------------------------------
bind(
  "n",
  "<leader>u",
  require("undotree").toggle,
  { noremap = true, silent = true, desc = "Toggle [U]ndo-tree" }
)

--------------------------------------------------------------------------------
-- Tagbar
--------------------------------------------------------------------------------
bind(
  "n",
  "<leader>ds",
  cmd.TagbarToggle,
  { noremap = true, silent = true, desc = "Show [D]ocument [S]ymbols" }
)
