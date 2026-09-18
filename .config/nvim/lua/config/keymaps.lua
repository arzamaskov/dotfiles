local map = vim.keymap.set

-- Русская раскладка в Insert mode
map("i", "<C-х>", "<C-[>", { silent = true })
map("i", "<C-г>", "<C-G>u<C-U>", { silent = true })
map("i", "<C-ц>", "<C-G>u<C-W>", { silent = true })

-- Explorer
map("n", "<C-n>", function()
  Snacks.explorer.reveal()
end, { desc = "Reveal file in explorer" })

-- Buffers
map("n", "<leader>;", function()
  Snacks.picker.buffers({
    sort_lastused = true,
    current = false,
  })
end, { desc = "Recent buffers" })

-- System clipboard
map({ "n", "x" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
map({ "n", "x" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })

map("n", "<leader>cp", function()
  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
  vim.fn.setreg("+", path)
end, { desc = "Copy relative file path" })

-- Comments
map("n", "<leader>cc", "gcc", { remap = true, desc = "Toggle comment" })
map("x", "<leader>cc", "gc", { remap = true, desc = "Toggle comment" })

-- TreeSJ
map("n", "<leader>j", "<cmd>TSJToggle<cr>", { desc = "Toggle split/join" })

-- Journal
local journal = vim.fn.expand("~/journal/index.txt")

local function setup_journal_keymap(buf)
  local path = vim.api.nvim_buf_get_name(buf)

  if path ~= journal then
    return
  end

  vim.keymap.set("n", "<leader>J", function()
    local now = os.date("*t")
    local weekdays = {
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
    }

    local header = string.format("%04d-%02d-%02d %s", now.year, now.month, now.day, weekdays[now.wday])

    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

    for _, line in ipairs(lines) do
      if line == header then
        vim.notify("Today's journal entry already exists")
        return
      end
    end

    vim.api.nvim_buf_set_lines(buf, 0, 0, false, {
      header,
      "",
      "",
      "",
    })

    vim.api.nvim_win_set_cursor(0, { 3, 0 })
    vim.cmd("startinsert")
  end, {
    buffer = buf,
    desc = "Add today's journal entry",
  })
end

setup_journal_keymap(0)

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function(args)
    setup_journal_keymap(args.buf)
  end,
})
