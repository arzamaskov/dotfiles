-- Mapping modules below may load plugins, so initialize pack support first.
require("config.plugins")

local map = vim.keymap.set
local fzf = require("fzf-lua")
local gs = require("gitsigns")
local handlers = {}

local function setup_keymaps()
  -- Сочетания клавиш

  -- Терминал
  map({ "n", "i", "t" }, "<C-/>", handlers.toggle_terminal, { desc = "Toggle terminal" })
  map({ "n", "i", "t" }, "<C-_>", handlers.toggle_terminal, { desc = "Toggle terminal" })

  -- Вставка: русская раскладка и завершение ввода
  map("i", "<C-х>", "<Esc>")
  map("i", "<C-г>", "<C-u>")
  map("i", "<C-ц>", "<C-w>")
  map("i", "<CR>", handlers.accept_completion_or_newline, {
    expr = true,
    desc = "Accept completion or newline",
  })

  -- Форматирование
  map("n", "<leader>cf", handlers.format_buffer, { desc = "Format buffer" })

  -- Поиск, файлы и буферы
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
  map("n", "<leader>fR", handlers.find_recent_files_in_cwd, {
    desc = "Recent files (cwd)",
  })
  map("n", "<leader>a", handlers.find_by_grep, {
    desc = "Find by grep",
  })
  map("n", "<leader>A", handlers.repeat_last_grep, {
    desc = "Repeat last grep",
  })

  -- Изменения Git
  map("n", "]h", handlers.next_hunk, { desc = "Next hunk" })
  map("n", "[h", handlers.previous_hunk, { desc = "Previous hunk" })
  map("n", "<leader>gp", gs.preview_hunk, {
    desc = "Preview hunk",
  })

  -- Диагностика и действия с кодом
  map("n", "<leader>cd", handlers.show_line_diagnostics, {
    desc = "Line diagnostics",
  })
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {
    desc = "Code action",
  })
  map("n", "<leader>cr", vim.lsp.buf.rename, {
    desc = "Rename symbol",
  })
  map("n", "<leader>xx", handlers.show_all_errors, {
    desc = "All errors",
  })

  -- Список quickfix
  map("n", "<leader>qo", "<cmd>copen<CR>", {
    desc = "Open quickfix",
  })
  map("n", "<leader>qc", "<cmd>cclose<CR>", {
    desc = "Close quickfix",
  })

  -- Очистка подсветки поиска
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

  -- Вспомогательные действия при редактировании
  map("n", "<leader>j", handlers.toggle_split_join, {
    desc = "Split/join",
  })
  map("n", "<leader>cp", handlers.copy_relative_path, {
    desc = "Copy relative path",
  })
end

-- Обработчики сочетаний клавиш
function handlers.toggle_terminal()
  require("config.terminal").toggle()
end

function handlers.accept_completion_or_newline()
  if vim.fn.pumvisible() == 1 then
    if vim.fn.complete_info({ "selected" }).selected >= 0 then
      return "<C-y>"
    end

    return "<C-e><CR>"
  end

  return "<CR>"
end

function handlers.format_buffer()
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
end

function handlers.find_recent_files_in_cwd()
  fzf.oldfiles({
    cwd_only = true,
    include_current_session = true,
  })
end

function handlers.next_hunk()
  gs.nav_hunk("next")
end

function handlers.previous_hunk()
  gs.nav_hunk("prev")
end

function handlers.show_line_diagnostics()
  vim.diagnostic.open_float({ scope = "line" })
end

function handlers.show_all_errors()
  vim.diagnostic.setqflist()
end

function handlers.find_by_grep()
  fzf.grep({ input_prompt = "Grep > " })
end

function handlers.repeat_last_grep()
  fzf.grep({ resume = true })
end

function handlers.toggle_split_join()
  require("treesj").toggle()
end

function handlers.copy_relative_path()
  local path = vim.fn.expand("%:.")

  vim.fn.setreg("+", path)
  vim.notify(path)
end

setup_keymaps()
