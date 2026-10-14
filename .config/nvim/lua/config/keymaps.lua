-- Mapping modules below may load plugins, so initialize pack support first.
require("config.plugins")

local map = vim.keymap.set
local fzf = require("fzf-lua")
local gs = require("gitsigns")

map({ "n", "i", "t" }, "<C-/>", function()
  require("config.terminal").toggle()
end, { desc = "Toggle terminal" })
map({ "n", "i", "t" }, "<C-_>", function()
  require("config.terminal").toggle()
end, { desc = "Toggle terminal" })

-- Insert mode: русская раскладка
map("i", "<C-х>", "<Esc>")
map("i", "<C-г>", "<C-u>")
map("i", "<C-ц>", "<C-w>")

map("i", "<CR>", function()
  if vim.fn.pumvisible() == 1 then
    if vim.fn.complete_info({ "selected" }).selected >= 0 then
      return "<C-y>"
    end

    return "<C-e><CR>"
  end

  return "<CR>"
end, {
  expr = true,
  desc = "Accept completion or newline",
})

map("n", "<leader>cf", function()
  local ft = vim.bo.filetype
  local preferred_formatters = {
    lua = "lua_ls",
    go = "gopls",
    gomod = "gopls",
    gowork = "gopls",
    gotmpl = "gopls",
  }
  local preferred = preferred_formatters[ft]
  local clients = vim.lsp.get_clients({ bufnr = 0, method = "textDocument/formatting" })
  local selected
  if preferred then
    for _, client in ipairs(clients) do
      if client.name == preferred then
        selected = client
        break
      end
    end
  elseif #clients == 1 then
    selected = clients[1]
  end
  if not selected then
    local message
    if preferred then
      message = "No " .. preferred .. " formatter attached"
    elseif #clients == 0 then
      message = "No formatter attached"
    else
      message = "More than one formatter attached"
    end
    vim.notify(message, vim.log.levels.WARN)
    return
  end
  vim.lsp.buf.format({ id = selected.id })
end, { desc = "Format buffer" })

map("n", "<leader><leader>", fzf.files, {
  desc = "Find files",
})

map("n", "<leader>fg", fzf.live_grep, {
  desc = "Live grep",
})

map("n", "<leader>sw", fzf.grep_cword, {
  desc = "Search word under cursor",
})

map("n", "<leader>;", fzf.buffers, {
  desc = "Buffers",
})

map("n", "<leader>e", "<cmd>Explore<CR>", { desc = "Explorer" })

map("n", "<leader>ss", fzf.lsp_document_symbols, {
  desc = "Document symbols",
})

map("n", "<leader>fr", fzf.oldfiles, {
  desc = "Recent files",
})

map("n", "<leader>fR", function()
  fzf.oldfiles({
    cwd_only = true,
    include_current_session = true,
  })
end, {
  desc = "Recent files (cwd)",
})

map("n", "]h", function()
  gs.nav_hunk("next")
end, { desc = "Next hunk" })

map("n", "[h", function()
  gs.nav_hunk("prev")
end, { desc = "Previous hunk" })

map("n", "<leader>gp", gs.preview_hunk, {
  desc = "Preview hunk",
})

map("n", "<leader>cd", function()
  vim.diagnostic.open_float({ scope = "line" })
end, {
  desc = "Line diagnostics",
})

map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {
  desc = "Code action",
})

map("n", "<leader>xx", function()
  vim.diagnostic.setqflist()
end, {
  desc = "All errors",
})

map("n", "<leader>qo", "<cmd>copen<CR>", {
  desc = "Open quickfix",
})

map("n", "<leader>qc", "<cmd>cclose<CR>", {
  desc = "Close quickfix",
})
map("n", "<leader>a", function()
  fzf.grep({ input_prompt = "Grep > " })
end, {
  desc = "Find by grep",
})

map("n", "<leader>A", function()
  fzf.grep({ resume = true })
end, {
  desc = "Repeat last grep",
})

-- Очистить подсветку обычного /
map("n", "<Esc>", "<cmd>nohlsearch<CR>", {
  desc = "Clear search highlight",
})

-- Переход между окнами
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Системный буфер обмена
map({ "n", "v" }, "<leader>y", '"+y', {
  desc = "Yank to clipboard",
})

map("n", "<leader>Y", '"+Y', {
  desc = "Yank line to clipboard",
})

map({ "n", "v" }, "<leader>p", '"+p', {
  desc = "Paste from clipboard",
})

map({ "n", "v" }, "<leader>P", '"+P', {
  desc = "Paste before from clipboard",
})

map("n", "<leader>j", function()
  require("treesj").toggle()
end, {
  desc = "Split/join",
})

map("n", "<leader>cp", function()
  local path = vim.fn.expand("%:.")

  vim.fn.setreg("+", path)
  vim.notify(path)
end, {
  desc = "Copy relative path",
})
