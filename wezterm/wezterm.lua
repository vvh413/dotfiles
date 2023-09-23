-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "Dracula (Official)"
config.font = wezterm.font("Fira Code")

config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
wezterm.on("update-status", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	overrides.enable_scroll_bar = not pane:is_alt_screen_active()
	window:set_config_overrides(overrides)
end)
config.min_scroll_bar_height = "1cell"
config.window_padding = {
	left = "0.5cell",
	right = "1cell",
	top = "0.25cell",
	bottom = "0.25cell",
}
config.max_fps = 120

config.warn_about_missing_glyphs = false

-- and finally, return the configuration to wezterm
return config
