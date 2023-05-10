-- Pull in the wezterm API
local wezterm = require 'wezterm'
local themes = require 'themes'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

local theme_config = themes

config.colors = theme_config.colors
config.color_scheme = theme_config.color_scheme
config.use_fancy_tab_bar = false
config.font = wezterm.font 'Rec Mono Linear'

config.window_decorations = "RESIZE"

return config
