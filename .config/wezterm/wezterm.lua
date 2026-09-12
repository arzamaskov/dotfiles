local wezterm = require("wezterm")
local act = wezterm.action

local config = wezterm.config_builder()

-- WSL
config.default_domain = "WSL:Ubuntu"

-- Font
config.font = wezterm.font_with_fallback({
	"FiraCode Nerd Font Mono",
	"FiraCode Nerd Font",
	"Cascadia Mono",
	"Consolas",
	"Symbols Nerd Font Mono",
})
config.font_size = 11

-- Physical shortcuts work regardless of the active keyboard layout.
config.key_map_preference = "Physical"

-- Window
config.window_decorations = "RESIZE"
config.window_padding = {
	left = 4,
	right = 4,
	top = 4,
	bottom = 4,
}

-- Appearance
config.color_scheme = "Github (Gogh)"

config.colors = {
	ansi = {
		"#24292f", -- black
		"#cf222e", -- red
		"#1a7f37", -- green
		"#9a6700", -- yellow
		"#0969da", -- blue
		"#8250df", -- magenta
		"#1b7c83", -- cyan
		"#6e7781", -- white
	},

	brights = {
		"#57606a",
		"#a40e26",
		"#116329",
		"#7d4e00",
		"#0550ae",
		"#6639ba",
		"#0a6e75",
		"#24292f",
	},
}

config.window_frame = {
	font = wezterm.font({
		family = "FiraCode Nerd Font Mono",
		weight = "Bold",
	}),
	font_size = 11,
}

-- Keybindings
config.keys = {
	{
		key = "\\",
		mods = "ALT|SHIFT",
		action = act.SplitPane({
			direction = "Right",
			size = { Percent = 50 },
		}),
	},

	{
		key = "phys:H",
		mods = "CTRL",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "phys:L",
		mods = "CTRL",
		action = act.ActivatePaneDirection("Right"),
	},

	{
		key = "phys:T",
		mods = "CTRL|SHIFT",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "phys:W",
		mods = "CTRL|SHIFT",
		action = act.CloseCurrentTab({ confirm = true }),
	},

	{
		key = "phys:C",
		mods = "CTRL|SHIFT",
		action = act.CopyTo("Clipboard"),
	},
	{
		key = "phys:V",
		mods = "CTRL|SHIFT",
		action = act.PasteFrom("Clipboard"),
	},

	{
		key = "Tab",
		mods = "CTRL",
		action = act.ActivateTabRelative(1),
	},
	{
		key = "Tab",
		mods = "CTRL|SHIFT",
		action = act.ActivateTabRelative(-1),
	},

	{
		key = "=",
		mods = "CTRL",
		action = act.IncreaseFontSize,
	},
	{
		key = "-",
		mods = "CTRL",
		action = act.DecreaseFontSize,
	},
	{
		key = "0",
		mods = "CTRL",
		action = act.ResetFontSize,
	},

	{
		key = "phys:F",
		mods = "CTRL|SHIFT",
		action = act.Search("CurrentSelectionOrEmptyString"),
	},
	{
		key = "phys:X",
		mods = "CTRL|SHIFT",
		action = act.ActivateCopyMode,
	},
}

wezterm.on("gui-startup", function(cmd)
	local _, _, window = wezterm.mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

return config
