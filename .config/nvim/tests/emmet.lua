vim.opt.rtp:prepend(vim.fn.getcwd())
vim.opt.swapfile = false
require("config.options")
vim.g.user_emmet_install_global = 0
vim.g.user_emmet_settings = { gotmpl = { extends = "html" } }
vim.cmd.packadd("emmet-vim")
vim.cmd.runtime("plugin/emmet.vim")
vim.cmd.packadd("nvim-treesitter")
require("config.snippets")
require("config.emmet")

local function equal(actual, expected, message)
  assert(actual == expected, ("%s: expected %q, got %q"):format(message, expected, actual))
end

local function reset(filetype, lines)
  vim.snippet.stop()
  vim.cmd("%bwipeout!")
  vim.cmd("enew")
  vim.bo.filetype = filetype
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines or { "" })
end

local steps = {}
local function step(keys, check)
  steps[#steps + 1] = function(done)
    if keys then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "xt", false)
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
  reset("html")
end)
step("idiv<Tab><Esc>", function()
  equal(vim.api.nvim_get_current_line(), "<div></div>", "HTML Emmet expansion")
end)

step(nil, function()
  reset("css", { ".card {", "  ", "}" })
  vim.api.nvim_win_set_cursor(0, { 2, 2 })
end)
step("Am10<Tab><Esc>", function()
  equal(vim.api.nvim_buf_get_lines(0, 0, -1, false)[2], "  margin: 10px;", "CSS Emmet expansion in a rule")
end)

step(nil, function()
  reset("gotmpl", { "{{if .Enabled}}", "div", "{{end}}" })
  vim.api.nvim_win_set_cursor(0, { 2, 3 })
  vim.treesitter.start(0, "gotmpl")
end)
step("A<Tab><Esc>", function()
  equal(vim.api.nvim_buf_get_lines(0, 0, -1, false)[2], "<div></div>", "Go template Emmet expansion with Tree-sitter")
end)

step(nil, function()
  reset("html", { "  " })
end)
step("A<Tab><Esc>", function()
  equal(vim.api.nvim_get_current_line(), "  " .. string.rep(" ", vim.bo.tabstop - 2), "blank HTML line keeps Tab indentation")
end)

local index = 0
local function run_next()
  index = index + 1
  if not steps[index] then
    print("PASS: Emmet Tab expansion for HTML, CSS, and Go templates")
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
  io.stderr:write("FAIL: Emmet test timed out\n")
  vim.cmd("cquit 1")
end, 5000)
