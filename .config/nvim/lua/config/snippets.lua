local M = {}

local snippets_by_filetype = {
  go = require("snippets.go"),
  lua = require("snippets.lua"),
}

local emmet_filetypes = { html = true, css = true, gotmpl = true }

local function snippet_at_cursor()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  local before_cursor = line:sub(1, col)
  local trigger = vim.fn.matchstr(before_cursor, [[\k\+$]])
  if trigger == "" or vim.fn.matchstr(line:sub(col + 1), [[^\k]]) ~= "" then
    return nil
  end

  local body = snippets_by_filetype[vim.bo.filetype]
    and snippets_by_filetype[vim.bo.filetype][trigger]
  if not body then
    return nil
  end
  return row, col, trigger, body
end

function M.expand(name)
  local snippets = snippets_by_filetype[vim.bo.filetype]
  local body = snippets and snippets[name]
  if body then
    vim.snippet.expand(body)
    return true
  end
  return false
end

function M.expand_at_cursor()
  if vim.fn.pumvisible() == 1 then
    return false
  end

  local row, col, trigger, body = snippet_at_cursor()
  if not trigger then
    return false
  end

  local start_col = col - #trigger
  vim.api.nvim_buf_set_text(0, row - 1, start_col, row - 1, col, {})
  vim.api.nvim_win_set_cursor(0, { row, start_col })
  vim.snippet.expand(body)
  return true
end

_G.expand_snippet = M.expand

local function tab_key(direction, key)
  return function()
    if vim.snippet.active({ direction = direction }) then
      vim.snippet.jump(direction)
      return
    end
    if vim.fn.pumvisible() == 1 then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(direction > 0 and "<C-n>" or "<C-p>", true, false, true), "in", false)
      return
    end
    if direction > 0 and vim.api.nvim_get_mode().mode:sub(1, 1) == "i" then
      if M.expand_at_cursor() then
        return
      end
      if emmet_filetypes[vim.bo.filetype]
        and vim.g.loaded_emmet_vim
        and vim.fn["emmet#isExpandable"]() == 1
      then
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("<Plug>(emmet-expand-abbr)", true, false, true),
          "im",
          false
        )
        return
      end
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), "in", false)
  end
end

vim.keymap.set({ "i", "s" }, "<Tab>", tab_key(1, "<Tab>"), {
  silent = true,
  desc = "Expand snippet or jump forward",
})
vim.keymap.set({ "i", "s" }, "<S-Tab>", tab_key(-1, "<S-Tab>"), {
  silent = true,
  desc = "Jump backward in snippet",
})

return M
