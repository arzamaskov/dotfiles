require("rose-pine").setup({
	-- disable_background = true,
	dark_variant = "moon",
	groups = {
		-- background = "#001e26",
		background_nc = "_experimental_nc",
		panel = "surface",
		panel_nc = "base",
		border = "highlight_med",
		comment = "muted",
		link = "iris",
		punctuation = "subtle",

		error = "love",
		hint = "iris",
		info = "foam",
		warn = "gold",

		git_add = "foam",
		git_change = "rose",
		git_delete = "love",
		git_dirty = "rose",
		git_ignore = "muted",
		git_merge = "iris",
		git_rename = "pine",
		git_stage = "iris",
		git_text = "rose",
	},
	highlight_groups = {
		-- ColorColumn = { bg = "none" },

		-- -- Blend colours against the "base" background
		-- CursorLine = { bg = 'foam', blend = 10 },
		-- StatusLine = { fg = "base", bg = "text", blend = 10 },
		--
		-- -- By default each group adds to the existing config.
		-- -- If you only want to set what is written in this config exactly,
		-- -- you can set the inherit option:
		-- Search = { bg = "inherit", inherit = false },
	},
})

function ColorMyPencils(color)
	color = color or "rose-pine"
	vim.cmd.colorscheme(color)
	-- vim.g.alabaster_dim_comments = true
	-- vim.g.alabaster_floatborder = true
	-- vim.o.background = "light"
	vim.o.background = "dark"

	-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

-- ColorMyPencils("github_light")
ColorMyPencils()
