local wezterm = require 'wezterm'

-- gruvbox colorscheme d-dark | l-light | nor-normal | br-bright
local dark_scheme = {
  bg         = "#282828",
  fg         = "#ebdbb2",

  red_nor    = "#cc241d",
  green_nor  = "#98971a",
  yellow_nor = "#d79921",
  blue_nor   = "#458588",
  purple_nor = "#b16286",
  aqua_nor   = "#689d6a",
  gray_nor   = "#a89984",
  orange_nor = "#d65d0e",

  red_br    = "#fb4934",
  green_br  = "#b8bb26",
  yellow_br = "#fabd2f",
  blue_br   = "#83a598",
  purple_br = "#d3869b",
  aqua_br   = "#8ec07c",
  gray_br   = "#928374",
  orange_br = "#fe8019",

  bg0_h     = "#1d2021",
  -- bg0       = dark_scheme.bg,
  bg1       = "#3c3836",
  bg2       = "#504945",
  bg3       = "#665c54",
  bg4       = "#7c6f64",
  -- bg_gray   = dark_scheme.gray_br,

  bg0_s     = "#32303f",
  fg0       = "#fbf1c7",
  fg1       = "#ebdbb2",
  fg2       = "#d5c4a1",
  fg3       = "#bdae93",
  fg4       = "#a89984",
}
dark_scheme.bg0 = dark_scheme.bg
dark_scheme.bg_gray = dark_scheme.gray_br

local light_scheme = {
  bg         = dark_scheme.fg0,
  fg         = dark_scheme.bg1,

  red_nor    = "#9d0006",
  green_nor  = "#79740e",
  yellow_nor = "#b57641",
  blue_nor   = "#076678",
  purple_nor = "#8f3f71",
  aqua_nor   = "#427b58",
  gray_nor   = dark_scheme.gray_br,
  orange_nor = "#af3a03",

  red_br    = dark_scheme.red_nor,
  green_br  = dark_scheme.green_nor,
  yellow_br = dark_scheme.yellow_nor,
  blue_br   = dark_scheme.blue_nor,
  purple_br = dark_scheme.purple_nor,
  aqua_br   = dark_scheme.aqua_nor,
  gray_br   = dark_scheme.gray_nor,
  orange_br = dark_scheme.orange_nor,

  bg0_h     = "#f9f5d7",
  bg0       = dark_scheme.fg0,
  bg1       = dark_scheme.fg1,
  bg2       = dark_scheme.fg2,
  bg3       = dark_scheme.fg3,
  bg4       = dark_scheme.fg4,
  bg_gray   = dark_scheme.bg_gray,

  bg0_s     = dark_scheme.fg0,
  fg0       = dark_scheme.bg0,
  fg1       = dark_scheme.bg1,
  fg2       = dark_scheme.bg2,
  fg3       = dark_scheme.bg3,
  fg4       = dark_scheme.bg4
}

local function gen_colors(scheme) return {
  tab_bar = {
    background = scheme.bg,
    active_tab = {
      bg_color = scheme.bg3,
      fg_color = scheme.fg0,
      intensity = 'Bold', -- "Half", "Normal" or "Bold" intensity. Default "Normal"
      underline = 'None', -- "None", "Single" or "Double" default is "None"
      italic = true, -- default false
      strikethrough = false, -- default false
    },
    inactive_tab = { -- tabs that do not have focus
      bg_color = scheme.bg1,-- The same options that were listed under `active_tab`
      fg_color = scheme.fg4,-- can also be used for `inactive_tab`.
    },
    inactive_tab_hover = { -- alternate styling when the mouse pointer hovers
      bg_color = scheme.yellow_br,
      fg_color = scheme.bg1, -- The same options that were listed under `active_tab` 
      italic = true,    -- can also be used for `inactive_tab`.
    },
    new_tab = { -- The new tab button that let you create new tabs
      bg_color = scheme.fg0,  -- The same options that were listed under `active_tab` 
      fg_color = scheme.bg4,  -- can also be used for `new_tab`.
    },
    new_tab_hover = { -- alternate styling when the mouse pointer hovers
      bg_color = scheme.orange_nor,
      fg_color = scheme.bg1,
      italic = true,
    },
  },
} end

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
local function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return 'Dark'
end

local function scheme_and_colors_for_appearance(appearance)
  if appearance:find 'Dark' then
		return {
	    colors = gen_colors(dark_scheme),
	    color_scheme = "Gruvbox dark, medium (base16)"
		}
  else
		return {
	    colors = gen_colors(light_scheme),
	    color_scheme = 'Gruvbox Light'
		}
  end
end

return scheme_and_colors_for_appearance(get_appearance())

