local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.font_size = 17
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false

local function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    return 'Solarized (dark) (terminal.sexy)'
  else
    return 'Solarized (light) (terminal.sexy)'
  end
end

local function tab_colors_for_appearance(appearance)
  if appearance:find 'Dark' then
    -- Darkモード時のタブ配色
    return {
      window_frame = {
        active_titlebar_bg = "#073642",
        inactive_titlebar_bg = "#073642",
      },
      colors = {
        tab_bar = {
          active_tab = {
            bg_color = "#002b36",
            fg_color = "#93a1a1"
          },
          inactive_tab = {
            bg_color = "#073642",
            fg_color = "#657b83"
          },
          inactive_tab_hover = {
            bg_color = "#002b36",
            fg_color = "#93a1a1"
          },
          new_tab = {
            bg_color = "#073642",
            fg_color = "#839496"
          },
          new_tab_hover = {
            bg_color = "#002b36",
            fg_color = "#93a1a1"
          }
        }
      }
    }
  else
    -- Lightモード時のタブ配色
    return {
      window_frame = {
        active_titlebar_bg = "#eee8d5",
        inactive_titlebar_bg = "#eee8d5",
      },
      colors = {
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
    }
  end
end

-- macOSの外観に応じたテーマとタブ色を設定
local appearance = wezterm.gui.get_appearance()
config.color_scheme = scheme_for_appearance(appearance)

-- タブバーとタイトルバーの色を自動適用
local tab_color_config = tab_colors_for_appearance(appearance)
config.window_frame = tab_color_config.window_frame
config.colors = tab_color_config.colors

-- 外観の変更をリアルタイムに追従させる
wezterm.on('window-config-reloaded', function(window)
  local overrides = window:get_config_overrides() or {}
  local new_appearance = window:get_appearance()

  overrides.color_scheme = scheme_for_appearance(new_appearance)

  local tab_colors = tab_colors_for_appearance(new_appearance)
  overrides.window_frame = tab_colors.window_frame
  overrides.colors = tab_colors.colors

  window:set_config_overrides(overrides)
end)

return config
