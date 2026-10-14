vim.opt.rtp:prepend(vim.fn.getcwd())
vim.opt.swapfile = false
package.preload["config.plugins"] = function() end
require("config.options")

local enable = vim.lsp.enable
vim.lsp.enable = function() end
require("config.lsp")
vim.lsp.enable = enable

local markers = vim.lsp.config.lua_ls.root_markers
assert(type(markers[1]) == "table", "Lua root markers should give .luarc files equal priority")
assert(markers[1][1] == ".luarc.json" and markers[1][2] == ".luarc.jsonc")
assert(markers[2] == ".git", "Git should remain the fallback Lua root marker")

local base = "/tmp/nvim-lsp-root-test-" .. vim.uv.os_getpid()
local parent = base .. "/parent"
local child = parent .. "/child"
local nested = child .. "/nested"
vim.fn.mkdir(nested, "p")
local function touch(path)
  local file = assert(io.open(path, "w"))
  file:close()
end
touch(parent .. "/.luarc.json")
touch(child .. "/.luarc.jsonc")
assert(vim.fs.root(nested, markers) == child, "nearest JSONC marker should beat parent JSON marker")
vim.fn.delete(child .. "/.luarc.jsonc")
vim.fn.delete(parent .. "/.luarc.json")
vim.fn.mkdir(parent .. "/.git", "p")
assert(vim.fs.root(nested, markers) == parent, "Git marker should be used when no Lua config marker exists")
vim.fn.delete(base, "rf")
print("PASS: Lua project root marker priority")
vim.cmd("qa!")
