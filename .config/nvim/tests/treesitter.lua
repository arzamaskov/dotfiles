vim.opt.rtp:prepend(vim.fn.getcwd())
vim.opt.swapfile = false
package.preload["config.plugins"] = function() end

local scheduled, installs, started = {}, {}, {}
local updates = 0
local refreshed = 0
local available = { go = true }
local query_only = { gotmpl = true }
local notifications = {}
vim.notify = function(message) table.insert(notifications, message) end
vim.schedule = function(callback)
  table.insert(scheduled, callback)
end
local function drain()
  while #scheduled > 0 do
    table.remove(scheduled, 1)()
  end
end

vim.treesitter.start = function(buf)
  local ft = vim.bo[buf].filetype
  if not available[ft] then
    error("parser unavailable")
  end
  table.insert(started, buf)
end
vim.treesitter.language.add = function() return true end
vim.treesitter.get_parser = function()
  return {
    invalidate = function(_, reload) assert(reload == true); refreshed = refreshed + 1 end,
    parse = function(_, range, callback)
      assert(range == true, "injection refresh must parse the root and child language trees")
      callback()
    end,
  }
end
local ts = {
  get_installed = function(kind)
    assert(kind == "parsers", "installer check must inspect parsers rather than query files")
    local installed = {}
    for language in pairs(available) do table.insert(installed, language) end
    return installed
  end,
  install = function(language, options)
    assert(options == nil, "normal parser installs must not force dependencies")
    local task = { await = function(_, callback) installs[language] = callback end }
    return task
  end,
  update = function()
    updates = updates + 1
    error("startup must not update parsers")
  end,
}
package.preload["nvim-treesitter"] = function() return ts end

require("config.treesitter")
local function new_buffer(ft)
  local buf = vim.api.nvim_create_buf(true, false)
  vim.bo[buf].filetype = ft
  vim.api.nvim_exec_autocmds("FileType", { buffer = buf, modeline = false })
  return buf
end

local go = new_buffer("go")
assert(started[1] == go, "available Go parser should start before unrelated installs settle")
local php = new_buffer("php")
local gotmpl = new_buffer("gotmpl")
local closed_php = new_buffer("php")
local closed_start_count = vim.tbl_count(vim.tbl_filter(function(buf) return buf == closed_php end, started))
vim.api.nvim_buf_delete(closed_php, { force = true })
drain()
assert(installs.html and installs.php and installs.gotmpl and installs.lua, "missing languages should install independently")
local php_starts = vim.tbl_count(vim.tbl_filter(function(buf) return buf == php end, started))
local lua = new_buffer("lua")

available.php = true
installs.php(nil, true)
drain()
assert(vim.tbl_count(vim.tbl_filter(function(buf) return buf == php end, started)) == php_starts + 1,
  "successful PHP install should retry an open PHP buffer before HTML finishes")
available.lua = true
installs.lua(nil, true)
drain()
assert(vim.tbl_contains(started, lua), "successful Lua install should retry an open Lua buffer")
assert(query_only.gotmpl, "gotmpl should model queries present without its parser")
installs.gotmpl(nil, true)
drain()
assert(vim.tbl_contains(notifications, "Tree-sitter did not install gotmpl; run :TSInstall! gotmpl, then restart Neovim"),
  "query-only install result should report the manual recovery command")
local starts_before_go = #started
local second_go = new_buffer("go")
assert(#started > starts_before_go and started[#started] == second_go,
  "failed gotmpl install must not disable later Go buffers")
available.html = true
installs.html(nil, true)
drain()
assert(updates == 0, "startup should never update parsers")
assert(not vim.api.nvim_buf_is_valid(closed_php), "closed buffer should remain safely skipped")
assert(vim.tbl_count(vim.tbl_filter(function(buf) return buf == closed_php end, started)) == closed_start_count,
  "closed buffer must not be retried after install")
assert(refreshed > 0, "new HTML parser should refresh embedded-language parse trees")
assert(vim.tbl_contains(started, go), "unavailable parser must not disable available Go")
print("PASS: independent Tree-sitter startup and parser installs")
vim.cmd("qa!")
