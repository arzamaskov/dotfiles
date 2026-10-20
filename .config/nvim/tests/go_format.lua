vim.opt.rtp:prepend(vim.fn.getcwd())
vim.opt.swapfile = false
package.preload["config.plugins"] = function() end
package.preload["fzf-lua"] = function() return setmetatable({}, { __index = function() return function() end end }) end
package.preload["gitsigns"] = function() return setmetatable({}, { __index = function() return function() end end }) end

local original_get_clients = vim.lsp.get_clients
local original_get_client_by_id = vim.lsp.get_client_by_id
local original_apply_workspace_edit = vim.lsp.util.apply_workspace_edit
local original_format = vim.lsp.buf.format
local client = { id = 42, name = "gopls", offset_encoding = "utf-16" }
local calls = {}
vim.bo.filetype = "go"
vim.lsp.get_clients = function() return { client } end
vim.lsp.get_client_by_id = function(id) assert(id == client.id); return client end
client.request_sync = function(_, method, params, timeout, bufnr)
  table.insert(calls, { "request", method, params, timeout, bufnr })
  return { result = { { title = "Organize Imports", kind = "source.organizeImports", edit = { changes = {} } } } }
end
vim.lsp.util.apply_workspace_edit = function(edit, encoding)
  table.insert(calls, { "edit", edit, encoding })
end
vim.lsp.buf.format = function(opts) table.insert(calls, { "format", opts }) end

require("config.keymaps")
local mapping
for _, item in ipairs(vim.api.nvim_get_keymap("n")) do
  if item.lhs == (vim.g.mapleader or "\\") .. "cf" then mapping = item end
end
assert(mapping and mapping.callback, "format mapping should have a callback")
mapping.callback()
assert(calls[1] and calls[1][1] == "request", "Go formatting should request organize imports first")
assert(calls[1][2] == "textDocument/codeAction")
assert(calls[1][3].context.only[1] == "source.organizeImports")
assert(calls[2] and calls[2][1] == "edit", "organize import edits should be applied")
assert(calls[3] and calls[3][1] == "format", "formatting should follow organize imports")
assert(calls[3][2].id == client.id)

calls = {}
client.request_sync = function() return nil end
local original_notify = vim.notify
vim.notify = function() end
vim.bo.filetype = "go"
mapping.callback()
vim.notify = original_notify
assert(#calls == 0, "formatting should stop when organize imports times out")
client.request_sync = function(_, method, params, timeout, bufnr)
  table.insert(calls, { "request", method, params, timeout, bufnr })
  return { result = {} }
end

calls = {}
vim.bo.filetype = "rust"
mapping.callback()
assert(#calls == 1 and calls[1][1] == "format", "other filetypes should only format")
assert(calls[1][2].id == client.id)

print("PASS: Go organize-imports precedes formatting; other filetypes retain formatting")
vim.lsp.get_clients = original_get_clients
vim.lsp.get_client_by_id = original_get_client_by_id
vim.lsp.util.apply_workspace_edit = original_apply_workspace_edit
vim.lsp.buf.format = original_format

local gopls = vim.fn.exepath("gopls")
if gopls == "" then
  print("SKIP: real gopls integration (gopls executable not found)")
else
  local root = "/tmp/nvim-go-format-integration-" .. vim.uv.os_getpid()
  vim.fn.delete(root, "rf")
  vim.fn.mkdir(root, "p")
  local id
  local ok, failure = xpcall(function()
    local mod = assert(io.open(root .. "/go.mod", "w"))
    mod:write("module example.test/nvimformat\n\ngo 1.23\n")
    mod:close()
    local fixture = assert(io.open(root .. "/main.go", "w"))
    fixture:write('package main\n\nimport "strings"\n\nfunc main(){fmt.Println("x")}\n')
    fixture:close()
    vim.cmd("edit " .. root .. "/main.go")
    vim.bo.filetype = "go"
    id = vim.lsp.start({ name = "gopls", cmd = { gopls }, root_dir = root })
    assert(id, "gopls did not start")
    local ready = vim.wait(20000, function()
      local attached = vim.lsp.get_client_by_id(id)
      return attached
        and attached.initialized
        and attached:supports_method("textDocument/codeAction", { bufnr = 0 })
        and attached:supports_method("textDocument/formatting", { bufnr = 0 })
    end, 100)
    assert(ready, "gopls did not initialize with code action and formatting support")
    mapping.callback()
    local result = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
    assert(not result:find('import "strings"', 1, true), "gopls left the unused strings import: " .. result)
    assert(result:find('import "fmt"', 1, true), "gopls did not add the missing fmt import: " .. result)
    assert(result:find("func main() {", 1, true), "gopls did not format the Go file: " .. result)
  end, debug.traceback)
  if id then
    local attached = vim.lsp.get_client_by_id(id)
    if attached then attached:stop(true) end
  end
  vim.fn.delete(root, "rf")
  if not ok then error(failure) end
  print("PASS: real gopls added fmt, removed unused strings, and formatted the Go file")
end
vim.cmd("qa!")
