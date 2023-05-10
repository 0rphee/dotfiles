local wezterm = require 'wezterm'


-- CTRL+SHIFT 	Z 	TogglePaneZoomState

local keys = {
  {
    key = "n",
    mods = "ALT",
    action = wezterm.action.SplitHorizontal
  },
  {
    key = "n",
    mods = "ALT|SHIFT",
    action = wezterm.action.SplitVertical
  },
  {
    key = "h",
    mods = "ALT",
    action = wezterm.action.ActivatePaneDirection "Left"
  },
  {
    key = "l",
    mods = "ALT",
    action = wezterm.action.ActivatePaneDirection "Right"
  },
  {
    key = "j",
    mods = "ALT",
    action = wezterm.action.ActivatePaneDirection "Down"
  },
  {
    key = "k",
    mods = "ALT",
    action = wezterm.action.ActivatePaneDirection "Up"
  },
  {
    key = "f",
    mods = "ALT",
    action = wezterm.action.TogglePaneZoomState
  },
  {
    key = 'q',
    mods = 'ALT',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
  -- show the pane selection mode, but have it swap the active and selected panes
  {
    key = 'm',
    mods = 'ALT',
    action = wezterm.action.PaneSelect {
      mode = "SwapWithActive"
    },
  },
{
    key = 'r',
    mods = 'ALT',
    action = wezterm.action.RotatePanes 'CounterClockwise',
  },
}

return keys
