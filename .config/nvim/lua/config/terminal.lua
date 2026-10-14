local M = {}

local function is_managed_terminal(buf)
  return vim.api.nvim_buf_is_valid(buf) and vim.b[buf].config_terminal == true
end

local function terminal_job(buf)
  if not is_managed_terminal(buf) then
    return nil
  end

  local job = vim.b[buf].terminal_job
  if job and vim.fn.jobwait({ job }, 0)[1] == -1 then
    return job
  end
end

local function find_terminal()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if terminal_job(buf) then
      return buf
    end
  end
end

local function find_current_tab_terminal_window()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if is_managed_terminal(buf) then
      return win
    end
  end
end

local function normal_window_count()
  local count = 0
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative == "" and not config.external then
      count = count + 1
    end
  end
  return count
end

local function hide_terminal(win)
  if vim.api.nvim_get_current_win() ~= win then
    vim.api.nvim_set_current_win(win)
  end

  vim.cmd("stopinsert")
  if normal_window_count() == 1 then
    vim.cmd("enew")
  else
    vim.api.nvim_win_close(win, true)
  end
end

function M.toggle()
  local visible_win = find_current_tab_terminal_window()
  if visible_win then
    hide_terminal(visible_win)
    return
  end

  vim.cmd("stopinsert")

  local buf = find_terminal()
  local split_ok = pcall(vim.cmd, "botright 12split")
  if not split_ok then
    vim.notify("Could not open terminal split", vim.log.levels.ERROR)
    return
  end
  local win = vim.api.nvim_get_current_win()

  if not buf then
    buf = vim.api.nvim_create_buf(false, true)
    vim.b[buf].config_terminal = true
    vim.bo[buf].bufhidden = "hide"
  end

  vim.api.nvim_win_set_buf(win, buf)

  if not terminal_job(buf) then
    local started, job = pcall(vim.fn.jobstart, vim.o.shell, { term = true })
    if not started or job <= 0 then
      vim.api.nvim_win_close(win, true)
      vim.notify("Could not start terminal shell", vim.log.levels.ERROR)
      return
    end
    vim.b[buf].terminal_job = job
  end

  vim.schedule(function()
    if vim.api.nvim_win_is_valid(win)
      and vim.api.nvim_get_current_win() == win
      and vim.api.nvim_win_get_buf(win) == buf
      and terminal_job(buf)
    then
      vim.cmd("startinsert")
    end
  end)
end

return M
