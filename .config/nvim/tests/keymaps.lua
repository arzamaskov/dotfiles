vim.opt.rtp:prepend(vim.fn.getcwd())
vim.opt.swapfile = false
require("config.options")

package.preload["config.plugins"] = function() end
local grep_calls = {}
package.preload["fzf-lua"] = function()
  return setmetatable({ grep = function(opts) table.insert(grep_calls, opts) end }, { __index = function()
    return function() end
  end })
end
package.preload["gitsigns"] = function()
  return setmetatable({}, { __index = function()
    return function() end
  end })
end

require("config.keymaps")

local function mapping(mode, lhs)
  local expanded_lhs = lhs:gsub("<leader>", vim.g.mapleader)
  for _, item in ipairs(vim.api.nvim_get_keymap(mode)) do
    if item.lhs == expanded_lhs then
      return item
    end
  end
  vim.cmd("cquit 1")
  error(("missing %s mapping for %s"):format(mode, lhs))
end

local diagnostic_map = mapping("n", "<leader>cd")
vim.api.nvim_buf_set_lines(0, 0, -1, false, { "diagnostic line", "other line" })
local namespace = vim.api.nvim_create_namespace("keymaps-test")
vim.diagnostic.set(namespace, 0, {
  { lnum = 0, col = 0, end_col = 3, message = "line diagnostic", severity = vim.diagnostic.severity.ERROR },
})
vim.diagnostic.config({ float = { scope = "cursor" } })

local function diagnostic_float()
  diagnostic_map.callback()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_config(win).relative ~= "" then
      return win
    end
  end
end

local function assert_diagnostic_at(cursor, should_show, message)
  vim.api.nvim_win_set_cursor(0, cursor)
  local win = diagnostic_float()
  assert((win ~= nil) == should_show, message)
  if win then
    local text = table.concat(vim.api.nvim_buf_get_lines(vim.api.nvim_win_get_buf(win), 0, -1, false), "\n")
    assert(text:find("line diagnostic", 1, true), "diagnostic float should contain the line diagnostic")
    vim.api.nvim_win_close(win, true)
  end
end

assert_diagnostic_at({ 1, 0 }, true, "diagnostic should show at its position")
assert_diagnostic_at({ 1, 8 }, true, "line scope should show diagnostic outside its text range")
assert_diagnostic_at({ 2, 0 }, false, "diagnostic should not show on a different line")

local normal_action = mapping("n", "<leader>ca")
local visual_action = mapping("x", "<leader>ca")
assert(normal_action.callback == vim.lsp.buf.code_action, "normal code action mapping should call vim.lsp.buf.code_action")
assert(visual_action.callback == vim.lsp.buf.code_action, "visual code action mapping should call vim.lsp.buf.code_action")

local grep_mapping = mapping("n", "<leader>a")
local input = vim.fn.input
vim.fn.input = function() error("grep mapping should use fzf-lua's prompt") end
grep_mapping.callback()
vim.fn.input = input
assert(#grep_calls == 1 and grep_calls[1].input_prompt == "Grep > ", "grep mapping should delegate its prompt to fzf-lua")

print("PASS: line diagnostics and normal/visual code action mappings")
vim.cmd("qa!")
