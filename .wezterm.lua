-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.font_size = 17

-- For example, changing the color scheme:
config.color_scheme = 'Solarized (light) (terminal.sexy)'
config.window_frame = {
  active_titlebar_bg = "#eee8d5",
  inactive_titlebar_bg = "#eee8d5",
}
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false


config.colors = {
  tab_bar = {
    active_tab = {
      bg_color = "#fdf6e3",
      fg_color = "#586e75"
    },

    inactive_tab = {
      bg_color = "#eee8d5",
      fg_color = "#073642"
    },

    inactive_tab_hover = {
      bg_color = "#fdf6e3",
      fg_color = "#586e75"
    },

    new_tab = {
      bg_color = "#eee8d5",
      fg_color = "#002b36"
    },

    new_tab_hover = {
      bg_color = "#fdf6e3",
      fg_color = "#586e75"
    }
  }
}

-- and finally, return the configuration to wezterm
return config
