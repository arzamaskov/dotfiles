vim.opt.rtp:prepend(vim.fn.getcwd())
vim.opt.swapfile = false
package.preload["config.plugins"] = function() end

local scheduled, completion, started, notifications = {}, nil, {}, {}
vim.schedule = function(callback) table.insert(scheduled, callback) end
local function drain()
  while #scheduled > 0 do table.remove(scheduled, 1)() end
end
vim.notify = function(message) table.insert(notifications, message) end
vim.treesitter.start = function(buf)
  if vim.bo[buf].filetype ~= "go" then error("parser unavailable") end
  table.insert(started, buf)
end
package.preload["nvim-treesitter"] = function()
  return {
    get_installed = function(kind)
      assert(kind == "parsers")
      return { "go" }
    end,
    install = function(language)
      assert(language == "php")
      return { await = function(_, callback) completion = callback end }
    end,
  }
end

require("config.treesitter")
drain()
assert(completion, "missing PHP parser should start an independent install")
completion("network unavailable", false)
drain()
assert(vim.tbl_contains(notifications, "Tree-sitter parser installation failed for php: network unavailable"),
  "failed install should report its language-specific failure")
local go = vim.api.nvim_create_buf(true, false)
vim.bo[go].filetype = "go"
vim.api.nvim_exec_autocmds("FileType", { buffer = go, modeline = false })
assert(vim.tbl_contains(started, go), "failed PHP install must not disable available Go")
print("PASS: Tree-sitter install failures are isolated by language")
vim.cmd("qa!")
