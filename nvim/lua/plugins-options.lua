--------------------------------------------------------------------------------
-- Core plugins
--------------------------------------------------------------------------------
-- Отключает дефолтный плагин Netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

--------------------------------------------------------------------------------
-- Сoc
--------------------------------------------------------------------------------
vim.g.coc_global_extensions = {
  "coc-css",
  "coc-html",
  "coc-html-css-support",
  "coc-markdownlint",
  "coc-json",
  "coc-phpls",
  "coc-tsserver",
  "coc-solargraph",
  "coc-snippets",
}

local keyset = vim.keymap.set
-- Autocomplete
function _G.check_back_space()
  local col = vim.fn.col(".") - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
end

-- Use Tab for trigger completion with characters ahead and navigate
-- NOTE: There's always a completion item selected by default, you may want to enable
-- no select by setting `"suggest.noselect": true` in your configuration file
-- NOTE: Use command ':verbose imap <tab>' to make sure Tab is not mapped by
-- other plugins before putting this into your config
local opts =
  { silent = true, noremap = true, expr = true, replace_keycodes = false }
keyset(
  "i",
  "<TAB>",
  'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()',
  opts
)
keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

-- Make <CR> to accept selected completion item or notify coc.nvim to format
-- <C-g>u breaks current undo, please make your own choice
keyset(
  "i",
  "<cr>",
  [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]],
  opts
)

-- Use <c-j> to trigger snippets
keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
-- Use <c-space> to trigger completion
keyset("i", "<c-space>", "coc#refresh()", { silent = true, expr = true })

-- Use `[g` and `]g` to navigate diagnostics
-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true })
keyset("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true })

-- GoTo code navigation
keyset("n", "gd", "<Plug>(coc-definition)", { silent = true })
keyset("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
keyset("n", "gi", "<Plug>(coc-implementation)", { silent = true })
keyset("n", "gr", "<Plug>(coc-references)", { silent = true })

-- Use K to show documentation in preview window
function _G.show_docs()
  local cw = vim.fn.expand("<cword>")
  if vim.fn.index({ "vim", "help" }, vim.bo.filetype) >= 0 then
    vim.api.nvim_command("h " .. cw)
  elseif vim.api.nvim_eval("coc#rpc#ready()") then
    vim.fn.CocActionAsync("doHover")
  else
    vim.api.nvim_command("!" .. vim.o.keywordprg .. " " .. cw)
  end
end
keyset("n", "K", "<CMD>lua _G.show_docs()<CR>", { silent = true })

-- Highlight the symbol and its references on a CursorHold event(cursor is idle)
vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {
  group = "CocGroup",
  command = "silent call CocActionAsync('highlight')",
  desc = "Highlight symbol under cursor on CursorHold",
})

-- Symbol renaming
keyset("n", "<leader>rn", "<Plug>(coc-rename)", { silent = true })

-- Formatting selected code
-- keyset("x", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })
-- keyset("n", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })

-- Setup formatexpr specified filetype(s)
vim.api.nvim_create_autocmd("FileType", {
  group = "CocGroup",
  pattern = "typescript,json",
  command = "setl formatexpr=CocAction('formatSelected')",
  desc = "Setup formatexpr specified filetype(s).",
})

-- Update signature help on jump placeholder
vim.api.nvim_create_autocmd("User", {
  group = "CocGroup",
  pattern = "CocJumpPlaceholder",
  command = "call CocActionAsync('showSignatureHelp')",
  desc = "Update signature help on jump placeholder",
})

-- Apply codeAction to the selected region
-- Example: `<leader>aap` for current paragraph
local opts = { silent = true, nowait = true }
keyset("x", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
keyset("n", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)

-- Remap keys for apply code actions at the cursor position.
keyset("n", "<leader>ac", "<Plug>(coc-codeaction-cursor)", opts)
-- Remap keys for apply source code actions for current file.
keyset("n", "<leader>as", "<Plug>(coc-codeaction-source)", opts)
-- Apply the most preferred quickfix action on the current line.
keyset("n", "<leader>qf", "<Plug>(coc-fix-current)", opts)

-- Remap keys for apply refactor code actions.
keyset("n", "<leader>re", "<Plug>(coc-codeaction-refactor)", { silent = true })
keyset(
  "x",
  "<leader>r",
  "<Plug>(coc-codeaction-refactor-selected)",
  { silent = true }
)
keyset(
  "n",
  "<leader>r",
  "<Plug>(coc-codeaction-refactor-selected)",
  { silent = true }
)

-- Run the Code Lens actions on the current line
-- keyset("n", "<leader>cl", "<Plug>(coc-codelens-action)", opts)

-- Map function and class text objects
-- NOTE: Requires 'textDocument.documentSymbol' support from the language server
keyset("x", "if", "<Plug>(coc-funcobj-i)", opts)
keyset("o", "if", "<Plug>(coc-funcobj-i)", opts)
keyset("x", "af", "<Plug>(coc-funcobj-a)", opts)
keyset("o", "af", "<Plug>(coc-funcobj-a)", opts)
keyset("x", "ic", "<Plug>(coc-classobj-i)", opts)
keyset("o", "ic", "<Plug>(coc-classobj-i)", opts)
keyset("x", "ac", "<Plug>(coc-classobj-a)", opts)
keyset("o", "ac", "<Plug>(coc-classobj-a)", opts)

-- Remap <C-f> and <C-b> to scroll float windows/popups
---@diagnostic disable-next-line: redefined-local
local opts = { silent = true, nowait = true, expr = true }
keyset(
  "n",
  "<C-f>",
  'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"',
  opts
)
keyset(
  "n",
  "<C-b>",
  'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"',
  opts
)
keyset(
  "i",
  "<C-f>",
  'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"',
  opts
)
keyset(
  "i",
  "<C-b>",
  'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"',
  opts
)
keyset(
  "v",
  "<C-f>",
  'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"',
  opts
)
keyset(
  "v",
  "<C-b>",
  'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"',
  opts
)

-- Use CTRL-S for selections ranges
-- Requires 'textDocument/selectionRange' support of language server
keyset("n", "<C-s>", "<Plug>(coc-range-select)", { silent = true })
keyset("x", "<C-s>", "<Plug>(coc-range-select)", { silent = true })

-- Add `:Format` command to format current buffer
vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

-- " Add `:Fold` command to fold current buffer
vim.api.nvim_create_user_command(
  "Fold",
  "call CocAction('fold', <f-args>)",
  { nargs = "?" }
)

-- Add `:OR` command for organize imports of the current buffer
vim.api.nvim_create_user_command(
  "OR",
  "call CocActionAsync('runCommand', 'editor.action.organizeImport')",
  {}
)

-- Add (Neo)Vim's native statusline support
-- NOTE: Please see `:h coc-status` for integrations with external plugins that
-- provide custom statusline: lightline.vim, vim-airline
vim.opt.statusline:prepend(
  "%{coc#status()}%{get(b:,'coc_current_function','')}"
)

-- Mappings for CoCList
-- code actions and coc stuff
---@diagnostic disable-next-line: redefined-local
local opts = { silent = true, nowait = true }
-- Show all diagnostics
keyset("n", "<space>a", ":<C-u>CocList diagnostics<cr>", opts)
-- Manage extensions
keyset("n", "<space>e", ":<C-u>CocList extensions<cr>", opts)
-- Show commands
keyset("n", "<space>cc", ":<C-u>CocList commands<cr>", opts)
-- Find symbol of current document
keyset("n", "<space>o", ":<C-u>CocList outline<cr>", opts)
-- Search workspace symbols
-- keyset("n", "<space>s", ":<C-u>CocList -I symbols<cr>", opts)
-- Do default action for next item
-- keyset("n", "<space>j", ":<C-u>CocNext<cr>", opts)
-- Do default action for previous item
keyset("n", "<space>k", ":<C-u>CocPrev<cr>", opts)
-- Resume latest coc list
-- keyset("n", "<space>p", ":<C-u>CocListResume<cr>", opts)

--------------------------------------------------------------------------------
-- Comment
--------------------------------------------------------------------------------
local ts_comment_integration =
  require("ts_context_commentstring.integrations.comment_nvim")

require("Comment").setup({
  pre_hook = ts_comment_integration.create_pre_hook(),
})

--------------------------------------------------------------------------------
-- Gitsigns
--------------------------------------------------------------------------------
require("gitsigns").setup({
  on_attach = function(bufnr)
    vim.keymap.set(
      "n",
      "<leader>hp",
      require("gitsigns").preview_hunk,
      { buffer = bufnr, desc = "Git [H]unk [P]review" }
    )
    vim.keymap.set(
      "n",
      "<leader>lb",
      package.loaded.gitsigns.toggle_current_line_blame,
      { buffer = bufnr, desc = "Toggle current [L]ine [B]lame" }
    )

    -- don't override the built-in and fugitive keymaps
    local gs = package.loaded.gitsigns
    vim.keymap.set({ "n", "v" }, "]c", function()
      if vim.wo.diff then
        return "]c"
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return "<Ignore>"
    end, { expr = true, buffer = bufnr, desc = "Jump to next hunk" })
    vim.keymap.set({ "n", "v" }, "[c", function()
      if vim.wo.diff then
        return "[c"
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return "<Ignore>"
    end, { expr = true, buffer = bufnr, desc = "Jump to previous hunk" })
  end,
  signs = {
    add = { text = "▐" },
    change = { text = "▐" },
    delete = { text = "▐" },
  },
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> • <summary>",
})

--------------------------------------------------------------------------------
-- NvimTree
--------------------------------------------------------------------------------
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 50,
  },
  renderer = {
    group_empty = true,
  },
  git = {
    enable = false,
    show_on_dirs = true,
    show_on_open_dirs = true,
    disable_for_dirs = {},
    timeout = 400,
    cygwin_support = false,
  },
  filters = {
    dotfiles = true,
  },
})

--------------------------------------------------------------------------------
-- NvimTree
--------------------------------------------------------------------------------
vim.g.php_cs_fixer_config_file = os.getenv("HOME") .. "/.php-cs-fixer.php"
vim.api.nvim_create_user_command(
  "PhpCsFixerFixFile",
  "call PhpCsFixerFixFile()",
  {}
)
vim.api.nvim_create_user_command(
  "PhpCsFixerFixDirectory",
  "call PhpCsFixerFixDirectory()",
  {}
)

--------------------------------------------------------------------------------
-- Telescope
--------------------------------------------------------------------------------
local actions = require("telescope.actions")

require("telescope").setup({
  defaults = {
    -- Default configuration for telescope goes here:
    -- config_key = value,
    -- initial_mode = "normal",
    use_regex = true,
    path_display = { "truncate" },
    layout_config = { width = 0.9 },
    mappings = {
      n = {
        ["cd"] = function(prompt_bufnr)
          local selection =
            require("telescope.actions.state").get_selected_entry()
          local dir = vim.fn.fnamemodify(selection.path, ":p:h")
          require("telescope.actions").close(prompt_bufnr)
          -- Depending on what you want put `cd`, `lcd`, `tcd`
          vim.cmd(string.format("silent lcd %s", dir))
        end,
      },
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        ["<C-h>"] = "which_key",
        -- ["<esc>"] = actions.close,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
    },
  },
  pickers = {
    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
    undo = {
      -- telescope-undo.nvim config, see below
    },
    buffers = {
      sort_lastused = true,
    },
    find_files = {},
  },
  extensions = {
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
    ["ui-select"] = {
      require("telescope.themes").get_dropdown({
        -- even more opts
      }),
    },
  },
})

require("telescope").load_extension("fzf")
require("telescope").load_extension("live_grep_args")
require("telescope").load_extension("ui-select")

--------------------------------------------------------------------------------
-- Treejs
--------------------------------------------------------------------------------
require("treesj").setup({
  opts = { use_default_keymaps = false, max_join_length = 150 },
})

--------------------------------------------------------------------------------
-- Undo-tree
--------------------------------------------------------------------------------
require("undotree").setup({
  float_diff = true, -- using float window previews diff, set this `true` will disable layout option
  layout = "left_bottom", -- "left_bottom", "left_left_bottom"
  position = "left", -- "right", "bottom"
  ignore_filetype = {
    "undotree",
    "undotreeDiff",
    "qf",
    "TelescopePrompt",
    "spectre_panel",
    "tsplayground",
  },
  window = {
    winblend = 30,
  },
  keymaps = {
    ["j"] = "move_next",
    ["k"] = "move_prev",
    ["gj"] = "move2parent",
    ["J"] = "move_change_next",
    ["K"] = "move_change_prev",
    ["<cr>"] = "action_enter",
    ["p"] = "enter_diffbuf",
    ["q"] = "quit",
  },
})

--------------------------------------------------------------------------------
-- Pdv standalone
--------------------------------------------------------------------------------
vim.api.nvim_create_user_command("PhpDocSingle", "call PhpDocSingle()", {})
vim.api.nvim_create_user_command("PhpDocRange", "call PhpDocRange()", {})

--------------------------------------------------------------------------------
-- Treesitter
--------------------------------------------------------------------------------
---@diagnostic disable: missing-fields
require("nvim-treesitter.configs").setup({
  -- A list of parser names, or "all"
  ensure_installed = { "vimdoc", "javascript", "php", "phpdoc", "lua" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
    filetypes = { "php" },
    set = {
      ["tabstop"] = 4,
      ["shiftwidth"] = 4,
      ["softtabstop"] = 4,
      ["expandtab"] = true,
    },
  },
  matchup = {
    enable = true, -- mandatory, false will disable the whole extension
    disable = { "c", "javascript", "sql" }, -- optional, list of language that will be disabled
    -- [options]
  },
  cond = function(lang, bufnr) -- Disable in large JS or SQL buffers
    return not (
      (lang == "javascript")
      or (lang == "sql" and vim.api.nvim_buf_line_count(bufnr) > 10000)
    )
  end,
})

--------------------------------------------------------------------------------
-- Treesitter-context
--------------------------------------------------------------------------------
require("treesitter-context").setup({
  separator = "-",
})
