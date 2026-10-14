require("config.plugins")

local group = vim.api.nvim_create_augroup("config_treesitter", { clear = true })
local managed = { go = true, gotmpl = true, php = true }
local languages = { "lua", "go", "gotmpl", "html", "php" }
local installing = {}
local notified = {}
local checking_installation = true

local function notify_once(key, message)
  if notified[key] then
    return
  end
  notified[key] = true
  vim.notify(message, vim.log.levels.WARN)
end

local function start(buf, installed_retry)
  if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_buf_is_loaded(buf) then
    return
  end
  local ft = vim.bo[buf].filetype
  if not managed[ft] and not (installed_retry and ft == "lua") then
    return
  end
  local ok, err = pcall(vim.treesitter.start, buf)
  if ok then
    local cleanup = "call v:lua.vim.treesitter.stop()"
    local current = vim.b[buf].undo_ftplugin or ""
    if not current:find(cleanup, 1, true) then
      vim.b[buf].undo_ftplugin = current == "" and cleanup or (current .. " | " .. cleanup)
    end
  elseif not checking_installation and not installing[ft] then
    notify_once(ft, "Tree-sitter could not start for " .. ft .. ": " .. tostring(err))
  end
end

local function retry_buffers(language)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
      local ft = vim.bo[buf].filetype
      if ft == language then
        start(buf, true)
      end
    end
  end
end

local function refresh_injections()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
      local ft = vim.bo[buf].filetype
      if ft == "gotmpl" or ft == "php" then
        local ok, parser = pcall(vim.treesitter.get_parser, buf)
        if ok and parser then
          local invalidated = pcall(parser.invalidate, parser, true)
          if invalidated then
            pcall(parser.parse, parser, true, function() end)
          end
        end
      end
    end
  end
end

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "go", "gotmpl", "php" },
  callback = function(args)
    start(args.buf)
  end,
})

local function install_language(ts, language)
  local installed_ok, installed = pcall(ts.get_installed, "parsers")
  if not installed_ok then
    notify_once("install:" .. language, "Tree-sitter could not check " .. language .. ": " .. tostring(installed))
    return
  end
  if vim.tbl_contains(installed, language) then
    return
  end

  installing[language] = true
  local called, task = pcall(ts.install, language)
  if not called or type(task) ~= "table" or type(task.await) ~= "function" then
    installing[language] = nil
    notify_once("install:" .. language, "Tree-sitter could not install " .. language .. ": " .. tostring(task))
    return
  end

  local awaited, await_err = pcall(task.await, task, function(err, success)
    vim.schedule(function()
      installing[language] = nil
      if err or success ~= true then
        notify_once("install:" .. language,
          "Tree-sitter parser installation failed for " .. language .. ": " .. tostring(err or "task did not succeed"))
        return
      end
      local check_ok, parsers = pcall(ts.get_installed, "parsers")
      if not check_ok or not vim.tbl_contains(parsers, language) then
        notify_once("install:" .. language,
          "Tree-sitter did not install " .. language .. "; run :TSInstall! " .. language .. ", then restart Neovim")
        return
      end
      -- Core weakly caches missing parsers; collect before retrying language.add/start.
      collectgarbage("collect")
      pcall(vim.treesitter.language.add, language)
      retry_buffers(language)
      if language == "html" then
        refresh_injections()
      end
    end)
  end)
  if not awaited then
    installing[language] = nil
    notify_once("install:" .. language, "Tree-sitter could not await " .. language .. " installation: " .. tostring(await_err))
  end
end

local function prepare()
  local ok, ts = pcall(require, "nvim-treesitter")
  if not ok then
    checking_installation = false
    notify_once("load", "Tree-sitter parser installation could not load nvim-treesitter: " .. tostring(ts))
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      start(buf)
    end
    return
  end
  for _, language in ipairs(languages) do
    install_language(ts, language)
  end
  checking_installation = false
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    start(buf)
  end
end

for _, buf in ipairs(vim.api.nvim_list_bufs()) do
  start(buf)
end
vim.schedule(prepare)
