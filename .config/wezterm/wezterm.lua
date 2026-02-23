local wezterm = require("wezterm")
local config = wezterm.config_builder()

local is_windows = wezterm.target_triple:find("windows") ~= nil

-- ── Catppuccin palettes (tab bar) ─────────────────────────────
local palettes = {
	macchiato = {
		base = "#24273a", mantle = "#1e2030", crust = "#181926",
		surface0 = "#363a4f", surface1 = "#494d64",
		text = "#cad3f5", subtext0 = "#a5adcb", blue = "#8aadf4",
	},
	latte = {
		base = "#eff1f5", mantle = "#e6e9ef", crust = "#dce0e8",
		surface0 = "#ccd0da", surface1 = "#bcc0cc",
		text = "#4c4f69", subtext0 = "#6c6f85", blue = "#1e66f5",
	},
}

local function get_flavour()
	if is_windows then
		local ok, stdout = wezterm.run_child_process({
			"wsl.exe", "-d", "Ubuntu-24.04", "--", "cat", "/home/paugam/.config/theme",
		})
		if ok then
			return stdout:gsub("%s+", "")
		end
	else
		local f = io.open(os.getenv("HOME") .. "/.config/theme", "r")
		if f then
			local flavour = f:read("*l")
			f:close()
			if flavour then
				return flavour
			end
		end
	end
	return "macchiato"
end

local flavour = get_flavour()
local p = palettes[flavour] or palettes.macchiato

if is_windows then
	config.default_prog = { "wsl.exe", "-d", "Ubuntu-24.04", "--cd", "~" }
end

config.font_size = 11.0
config.color_scheme = "Catppuccin " .. flavour:gsub("^%l", string.upper)
config.window_background_opacity = 1.0
config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }
config.hide_tab_bar_if_only_one_tab = true

if is_windows then
	config.front_end = "OpenGL"
end

config.window_frame = {
	active_titlebar_bg = p.mantle,
	inactive_titlebar_bg = p.crust,
}

config.colors = {
	tab_bar = {
		background = p.mantle,
		active_tab = { bg_color = p.base, fg_color = p.blue },
		inactive_tab = { bg_color = p.mantle, fg_color = p.subtext0 },
		inactive_tab_hover = { bg_color = p.surface0, fg_color = p.text },
		new_tab = { bg_color = p.mantle, fg_color = p.subtext0 },
		new_tab_hover = { bg_color = p.surface0, fg_color = p.text },
	},
}

config.keys = {
	{ key = "d", mods = "CTRL|SHIFT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "e", mods = "CTRL|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "h", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "l", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "k", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "j", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Down") },
	{ key = "t", mods = "CTRL|SHIFT", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
	{
		key = "m",
		mods = "CTRL|SHIFT",
		action = wezterm.action_callback(function(win, pane)
			pane:move_to_new_tab()
		end),
	},
	{
		key = "n",
		mods = "CTRL|SHIFT",
		action = wezterm.action_callback(function(win, pane)
			pane:move_to_new_window()
		end),
	},
	{ key = "s", mods = "CTRL|SHIFT", action = wezterm.action.PaneSelect({ mode = "SwapWithActive" }) },
	{
		key = "p",
		mods = "CTRL|SHIFT",
		action = wezterm.action_callback(function(win, pane)
			if is_windows then
				wezterm.run_child_process({
					"wsl.exe", "-d", "Ubuntu-24.04", "--", "/home/paugam/.local/bin/theme-toggle",
				})
			else
				wezterm.run_child_process({ os.getenv("HOME") .. "/.local/bin/theme-toggle" })
			end
			win:toast_notification("Theme", "Theme toggled", nil, 2000)
		end),
	},
	{ key = "Enter", mods = "SHIFT", action = wezterm.action.SendString("\x1b[13;2u") },
}

return config
