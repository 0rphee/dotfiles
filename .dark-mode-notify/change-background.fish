#! /opt/homebrew/bin/fish

function change_background --argument mode_setting
  # change background to the given mode. If mode is missing, 
  # we try to deduct it from the system settings.
  set -l mode "light" # default value
  if test -z $mode_setting
    set -l val (defaults read -g AppleInterfaceStyle) >/dev/null
    if test $status -eq 0
      set mode "dark"
    end
  else
    switch $mode_setting
      case light
        osascript -l JavaScript -e "Application('System Events').appearancePreferences.darkMode = false" >/dev/null
        set mode "light"
      case dark
        osascript -l JavaScript -e "Application('System Events').appearancePreferences.darkMode = true" >/dev/null
        set mode "dark"
    end
  end

  # change alacritty
  switch $mode
    case dark
      /opt/homebrew/bin/alacritty-themes gruvbox-dark
    case light
      /opt/homebrew/bin/alacritty-themes gruvbox-light
  end
end


change_background