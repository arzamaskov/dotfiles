vim.g.mapleader = " "

vim.keymap.set(
  "n",
  "<C-[>",
  ":nohlsearch<CR>",
  { silent = true, noremap = true, desc = "Disable search highlighting" }
)

vim.keymap.set(
  "n",
  "<C-l>",
  "<C-w>l",
  { silent = true, noremap = true, desc = "Move to right window" }
)

vim.keymap.set(
  "n",
  "<C-h>",
  "<C-w>h",
  { silent = true, noremap = true, desc = "Move to left window" }
)

vim.keymap.set(
  "n",
  "<C-j>",
  "<C-w>j",
  { silent = true, noremap = true, desc = "Move to window below" }
)

vim.keymap.set(
  "n",
  "<C-k>",
  "<C-w>k",
  { silent = true, noremap = true, desc = "Move to window above" }
)

vim.keymap.set(
  "n",
  "k",
  "gk",
  { silent = true, noremap = true, desc = "Move up by line" }
)

vim.keymap.set(
  "n",
  "j",
  "gj",
  { silent = true, noremap = true, desc = "Move down by line" }
)

-- For russian layout
vim.keymap.set(
  "i",
  "<c-х>",
  "<C-[>",
  { silent = true, noremap = true, desc = "Escape" }
)

vim.keymap.set(
  "n",
  "л",
  "gk",
  { silent = true, noremap = true, desc = "Move up by line" }
)

vim.keymap.set(
  "n",
  "о",
  "gj",
  { silent = true, noremap = true, desc = "Move down by line" }
)

vim.keymap.set(
  "n",
  "gn",
  ":bn<CR>",
  { silent = true, noremap = true, desc = "[G]o to the [N]ext buffer" }
)

vim.keymap.set(
  "n",
  "gp",
  ":bp<CR>",
  { silent = true, noremap = true, desc = "[G]o to the [P]revious buffer" }
)

vim.keymap.set(
  { "n", "v" },
  "<leader>y",
  '"+y',
  { silent = true, noremap = true, desc = "[Y]ank to the system clipboard" }
)

vim.keymap.set("n", "<leader>Y", '"+Y', {
  silent = true,
  noremap = true,
  desc = "[Y]ank whole line to the system clipboard",
})

vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', {
  silent = true,
  noremap = true,
  desc = "[P]aste from system clipboard after cursor",
})

vim.keymap.set("n", "<leader>P", '"+P', {
  silent = true,
  noremap = true,
  desc = "[P]aste from system clipboard before cursor",
})

-- Copy relative file path
vim.keymap.set("n", "<leader>l", function()
  local file_name = vim.fn.expand("%:p")
  local cwd = vim.fn.getcwd()
  local rel_path = vim.fn.fnamemodify(file_name, ":." .. cwd .. ":")
  vim.fn.setreg("+", rel_path)
end, { silent = true, noremap = true, desc = "Copy relative file path" })

-- Copy full file path
vim.keymap.set("n", "<leader>L", function()
  local file_name = vim.fn.expand("%")
  vim.fn.setreg("+", file_name)
end, { silent = true, noremap = true, desc = "Copy full file path" })

-- -- Format code
-- vim.keymap.set("n",
--   "<leader>cf",
--   ":Format<CR>",
--   { silent = true, noremap = true, desc = "[C]ode [F]ormat" }
-- )
