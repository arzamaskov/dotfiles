vim.opt.rtp:prepend(vim.fn.getcwd())
vim.opt.swapfile = false
require("config.options")
require("config.statusline")
require("config.snippets")

local function reset(filetype, lines)
  vim.snippet.stop()
  vim.cmd("%bwipeout!")
  vim.cmd("enew")
  vim.bo.filetype = filetype
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines or { "" })
end

local function equal(actual, expected, message)
  assert(actual == expected, ("%s: expected %q, got %q"):format(message, expected, actual))
end

local function tab_after(text)
  local width = vim.bo.tabstop - (#text % vim.bo.tabstop)
  return text .. string.rep(" ", width)
end

local steps = {}
local function step(keys, check, mode)
  steps[#steps + 1] = function(done)
    if keys then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), mode or "xt", false)
    end
    vim.defer_fn(function()
      local ok, err = xpcall(check, debug.traceback)
      if not ok then
        io.stderr:write(err .. "\n")
        vim.cmd("cquit 1")
        return
      end
      done()
    end, 10)
  end
end

step(nil, function()
  reset("lua")
end)
step("ireq<Tab><Esc>", function()
  equal(vim.api.nvim_get_current_line(), 'local name = require("module")', "Lua trigger")
end)

step(nil, function()
  reset("go", { "    " })
end)
step("Aiferr<Tab><Esc>", function()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  equal(lines[1], "    if err != nil {", "Go trigger and indentation")
  equal(lines[2], "        return err", "Go body and trigger removal")
  equal(lines[3], "    }", "Go closing brace indentation")
end)

step(nil, function()
  reset("lua")
end)
step("ireq<Tab>", function()
  assert(vim.snippet.active({ direction = 1 }), "custom snippet should activate its first field")
end)
step("value<Tab>", function()
  assert(vim.snippet.active({ direction = -1 }), "Tab should advance to the second field")
end)
step("my_module<S-Tab>", function()
  assert(vim.snippet.active({ direction = 1 }), "Shift-Tab should return to the first field")
end)
step("other<Esc>", function()
  equal(vim.api.nvim_get_current_line(), 'local other = require("my_module")', "edited Lua fields")
end)

step(nil, function()
  reset("text")
end)
step("iunknown<Tab><Esc>", function()
  equal(vim.api.nvim_get_current_line(), tab_after("unknown"), "unsupported filetype should insert Tab")
end)

step(nil, function()
  reset("lua")
end)
step("ixreq<Tab><Esc>", function()
  equal(vim.api.nvim_get_current_line(), tab_after("xreq"), "unknown trigger should insert Tab")
end)

step(nil, function()
  reset("lua", { "request" })
  vim.api.nvim_win_set_cursor(0, { 1, 3 })
end)
step("i<Tab><Esc>", function()
  equal(vim.api.nvim_get_current_line(), "req" .. string.rep(" ", vim.bo.tabstop - 3) .. "uest", "midword trigger should not expand")
end)

step(nil, function()
  reset("lua", { "префикс req" })
  vim.keymap.set("i", "<F2>", function()
    vim.snippet.expand('call(${1:first}, ${2:second})$0')
  end)
end)
step("A<Tab><Esc>", function()
  equal(vim.api.nvim_get_current_line(), 'префикс local name = require("module")', "multibyte prefix")
end)

step(nil, function()
  reset("lua")
end)
step("i<F2>", function()
  assert(vim.snippet.active({ direction = 1 }), "LSP-style snippet should activate its first field")
end)
step("changed<Tab>", function()
  assert(vim.snippet.active({ direction = -1 }), "Tab should advance through native snippet fields")
end)
step("changed2<S-Tab>", function()
  assert(vim.snippet.active({ direction = 1 }), "Shift-Tab should move back in native snippet fields")
end)
step("first<Esc>", function()
  equal(vim.api.nvim_get_current_line(), "call(first, changed2)", "native LSP-style snippet navigation")
end)

step(nil, function()
  reset("lua")
  vim.keymap.set("i", "<F3>", function()
    vim.fn.complete(1, { "value_one", "value_two" })
  end)
end)
step("i<F2>", function()
  assert(vim.snippet.active({ direction = 1 }), "snippet should activate before popup test")
end)
step("value<F3>", function()
  equal(vim.fn.pumvisible(), 1, "completion menu should be open")
end, "t")
step("<Tab>", function()
  equal(vim.snippet._session.current_tabstop.index, 2, "Tab should advance snippet with completion menu open")
end, "t")
step("second<F3>", function()
  equal(vim.fn.pumvisible(), 1, "completion menu should be open before backward snippet navigation")
end, "t")
step("<S-Tab>", function()
  equal(vim.snippet._session.current_tabstop.index, 1, "Shift-Tab should go back in snippet with completion menu open")
end, "t")
step("<C-e><Esc>", function()
  equal(vim.fn.pumvisible(), 0, "completion menu should close")
end)

step(nil, function()
  reset("text")
  vim.keymap.set("i", "<F3>", function()
    vim.fn.complete(1, { "value_one", "value_two" })
  end)
end)
step("i<F3>", function()
  equal(vim.fn.pumvisible(), 1, "completion menu should open outside a snippet")
end, "t")
step("<Tab>", function()
  assert(vim.fn.complete_info({ "selected" }).selected >= 0, "Tab should navigate completion outside a snippet")
end, "t")

step(nil, function()
  assert(vim.o.showmode, "default showmode should stay enabled")
  assert(not vim.o.statusline:find("statusline_mode", 1, true), "statusline should not duplicate showmode")
  vim.api.nvim_buf_set_name(0, "/tmp/snippets-example.lua")
  vim.b.gitsigns_status_dict = { head = "feature/test" }
  local statusline = vim.api.nvim_eval_statusline(vim.o.statusline, {}).str
  assert(statusline:find("feature/test", 1, true), "statusline should show git branch")
  assert(statusline:find("snippets-example.lua", 1, true), "statusline should show filename")
end)

local index = 0
local function run_next()
  index = index + 1
  if not steps[index] then
    print("PASS: custom snippets, native snippet navigation, fallback keys, and statusline")
    vim.cmd("qa!")
    return
  end
  steps[index](run_next)
end

vim.defer_fn(function()
  local ok, err = xpcall(run_next, debug.traceback)
  if not ok then
    io.stderr:write(err .. "\n")
    vim.cmd("cquit 1")
  end
end, 10)
vim.defer_fn(function()
  io.stderr:write("FAIL: snippet test timed out\n")
  vim.cmd("cquit 1")
end, 5000)
