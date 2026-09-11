# Neovim config

A minimalist configuration for Neovim 0.12.x.

The goal is to build a comfortable development environment without distributions such as LazyVim and without unnecessary abstraction layers.

The main principle:

> Use Neovim's built-in features first. Add a plugin only when it solves a specific problem.

## Core decisions

* Lua-based configuration;
* built-in `vim.pack` for plugin management;
* built-in Neovim LSP;
* `gopls` for Go;
* built-in LSP completion without a separate completion framework;
* Tree-sitter for syntax highlighting;
* no automatic popup windows;
* no format-on-save;
* minimal visual decoration.

## Plugins

Planned minimal plugin set:

* `nvim-tree.lua` — file tree;
* `fzf-lua` — fuzzy search;
* `nvim-treesitter` — Tree-sitter parsers;
* `gitsigns.nvim` — Git indicators in the gutter;
* `rose-pine` — colorscheme.

Not used unless there is a real need:

* LazyVim;
* `lazy.nvim`;
* Mason;
* `nvim-cmp`;
* `blink.cmp`;
* LuaSnip;
* conform.nvim;
* lualine;
* toggleterm;
* vim-fugitive.

## Navigation

Main key mappings:

| Key               | Action                       |
| ----------------- | ---------------------------- |
| `<leader><space>` | find file                    |
| `<leader>e`       | file tree                    |
| `<leader>fR`      | recently opened files        |
| `<leader>;`       | open buffers                 |
| `<leader>bd`      | delete current buffer        |
| `<leader>/`       | search project text          |
| `<leader>fw`      | search for word under cursor |
| `<C-/>`           | toggle built-in terminal     |

The fuzzy finder shows the result list immediately, but file preview is shown only after an explicit action.

## Completion

Completion must not appear automatically.

Neovim's built-in LSP completion is used:

| Key             | Action                         |
| --------------- | ------------------------------ |
| `Tab`           | trigger completion / next item |
| `Shift-Tab`     | previous item                  |
| `Ctrl-Y`        | accept item                    |
| `Ctrl-E`        | cancel completion              |
| `Ctrl-X Ctrl-F` | file name completion           |

Initially, LSP is the only completion source.

## LSP

Go uses `gopls` directly through Neovim's built-in LSP client.

The main mappings preserve the familiar LazyVim workflow:

| Key          | Action                     |
| ------------ | -------------------------- |
| `gd`         | definition                 |
| `gD`         | declaration                |
| `gr`         | references                 |
| `gI`         | implementation             |
| `gy`         | type definition            |
| `K`          | hover                      |
| `gK`         | signature help             |
| `<leader>ca` | code action                |
| `<leader>cr` | rename                     |
| `<leader>cf` | clean up current file      |
| `<leader>cd` | show diagnostic details    |
| `[d` / `]d`  | previous / next diagnostic |
| `<leader>ss` | document symbols           |
| `<leader>sS` | workspace symbols          |

## Formatting

Saving a file must not modify the code.

```text
:w
```

only saves the file.

For Go:

```text
<leader>cf
```

performs:

1. organize imports;
2. format through `gopls`.

Format-on-save and organize-imports-on-save are not used.

## Diagnostics

Diagnostics should be visible without being intrusive.

Used:

* gutter indicators;
* underline;
* `[d` / `]d` navigation.

Not used:

* persistent virtual text;
* automatically opened diagnostic windows.

Detailed diagnostic information is shown explicitly with `<leader>cd`.

## Git

`gitsigns.nvim` is used mainly to display changes:

```text
+  added
~  changed
-  deleted
```

Git operations such as `add`, `commit`, `rebase`, and `blame` remain terminal workflows.

## Statusline

The statusline should display only useful information.

Example:

```text
 NORMAL  internal/foo.go [+]          main   utf-8  unix   go   42:17
```

Left side:

* mode;
* relative file path;
* modified indicator.

Right side:

* Git branch;
* file encoding;
* line endings;
* filetype;
* line and column.

Diagnostics are not shown in the statusline.

## Colorscheme

The terminal uses the dark Rosé Pine theme.

Neovim uses the light variant:

```text
Rosé Pine Dawn
```

The Neovim background is opaque.

## UI

The configuration intentionally avoids unnecessary visual activity.

Not needed:

* dashboards;
* animations;
* breadcrumbs;
* buffer tabs;
* automatically appearing popup windows;
* decorative separators;
* UI elements without practical value.

The editor should display information permanently only when it is genuinely useful. Everything else should appear after an explicit action.

## Build plan

1. `init.lua` and configuration structure;
2. options;
3. basic key mappings;
4. `vim.pack`;
5. Rosé Pine Dawn;
6. `nvim-tree`;
7. `fzf-lua`;
8. Tree-sitter;
9. `gitsigns`;
10. `gopls` and LSP;
11. completion;
12. formatting;
13. terminal toggle;
14. statusline;
15. final cleanup.

