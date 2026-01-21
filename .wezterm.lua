local wezterm = require 'wezterm'

local config = wezterm.config_builder()

-- Basic settings
config.font = wezterm.font_with_fallback({
  { family = 'RobotoMono Nerd Font' },
  { family = 'ヒラギノ角ゴシック' },
})
config.font_size = 17
config.command_palette_font_size = 18
config.use_ime = true
config.macos_forward_to_ime_modifier_mask = "SHIFT|CTRL"
config.window_background_opacity = 1
config.hide_tab_bar_if_only_one_tab = false
config.enable_tab_bar = true
config.show_new_tab_button_in_tab_bar = false
config.show_close_tab_button_in_tabs = false
config.window_decorations = "RESIZE"
config.status_update_interval = 1000

local function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    return 'Solarized (dark) (terminal.sexy)'
  end
  return 'Solarized (light) (terminal.sexy)'
end

local tab_colors = {
  dark = {
    window_frame = {
      active_titlebar_bg = "#073642",
      inactive_titlebar_bg = "#073642",
    },
    colors = {
      tab_bar = {
        active_tab = { bg_color = "#002b36", fg_color = "#93a1a1" },
        inactive_tab = { bg_color = "#073642", fg_color = "#657b83" },
        inactive_tab_hover = { bg_color = "#002b36", fg_color = "#93a1a1" },
        new_tab = { bg_color = "#073642", fg_color = "#839496" },
        new_tab_hover = { bg_color = "#002b36", fg_color = "#93a1a1" },
      },
    },
  },
  light = {
    window_frame = {
      active_titlebar_bg = "#eee8d5",
      inactive_titlebar_bg = "#eee8d5",
    },
    colors = {
      tab_bar = {
        active_tab = { bg_color = "#fdf6e3", fg_color = "#586e75" },
        inactive_tab = { bg_color = "#eee8d5", fg_color = "#073642" },
        inactive_tab_hover = { bg_color = "#fdf6e3", fg_color = "#586e75" },
        new_tab = { bg_color = "#eee8d5", fg_color = "#002b36" },
        new_tab_hover = { bg_color = "#fdf6e3", fg_color = "#586e75" },
      },
    },
  },
}

local function tab_colors_for_appearance(appearance)
  if appearance:find 'Dark' then
    return tab_colors.dark
  end
  return tab_colors.light
end

local workspace_state = wezterm.GLOBAL.workspace_state or {
  current = nil,
  last = nil,
  last_toast = nil,
}
wezterm.GLOBAL.workspace_state = workspace_state

-- macOSの外観に応じたテーマとタブ色を設定
do
  local appearance = wezterm.gui.get_appearance()
  config.color_scheme = scheme_for_appearance(appearance)

  local tab_color_config = tab_colors_for_appearance(appearance)
  config.window_frame = tab_color_config.window_frame
  config.colors = tab_color_config.colors
end

-- 外観の変更をリアルタイムに追従させる
wezterm.on('window-config-reloaded', function(window)
  local overrides = window:get_config_overrides() or {}
  local new_appearance = window:get_appearance()

  overrides.color_scheme = scheme_for_appearance(new_appearance)

  local current_tab_colors = tab_colors_for_appearance(new_appearance)
  overrides.window_frame = current_tab_colors.window_frame
  overrides.colors = current_tab_colors.colors

  window:set_config_overrides(overrides)
end)

config.keys = {
  {
    key = "f",
    mods = "CMD|CTRL",
    action = wezterm.action.ToggleFullScreen
  },
  {
    key = "p",
    mods = "CMD|SHIFT",
    action = wezterm.action.ActivateCommandPalette
  },
  {
    key = "o",
    mods = "CMD",
    action = wezterm.action.ShowLauncherArgs { flags = "FUZZY|WORKSPACES" }
  },
  {
    key = "s",
    mods = "LEADER",
    action = wezterm.action.ShowLauncherArgs { flags = "FUZZY|WORKSPACES" }
  },
  {
    key = "t",
    mods = "LEADER",
    action = wezterm.action_callback(function(window, pane)
      local last = workspace_state.last
      if last and last ~= "" then
        window:perform_action(
          wezterm.action.SwitchToWorkspace { name = last },
          pane
        )
      end
    end)
  },
  {
    key = "n",
    mods = "LEADER",
    action = wezterm.action_callback(function(window, pane)
      window:perform_action(
        wezterm.action.PromptInputLine {
          description = "Workspace name",
          initial_value = "",
          action = wezterm.action_callback(function(window, pane, line)
            local name = line
            if name and name ~= "" then
              window:perform_action(
                wezterm.action.SwitchToWorkspace { name = name },
                pane
              )
            end
          end),
        },
        pane
      )
    end)
  },
  {
    key = "a",
    mods = "CMD|SHIFT",
    action = wezterm.action.ShowLauncherArgs { flags = "FUZZY|TABS" }
  },
  -- 横（上下）に分割
  {
    key = "s",
    mods = "LEADER|CTRL",
    action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" },
  },
  -- 縦（左右）に分割
  {
    key = "v",
    mods = "LEADER|CTRL",
    action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" },
  },
  -- ペインを閉じる
  {
    key = "x",
    mods = "LEADER|CTRL",
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
  -- ペインの移動（方向キー風）
  {
    key = "h",
    mods = "LEADER|CTRL",
    action = wezterm.action.ActivatePaneDirection "Left",
  },
  {
    key = "l",
    mods = "LEADER|CTRL",
    action = wezterm.action.ActivatePaneDirection "Right",
  },
  {
    key = "k",
    mods = "LEADER|CTRL",
    action = wezterm.action.ActivatePaneDirection "Up",
  },
  {
    key = "j",
    mods = "LEADER|CTRL",
    action = wezterm.action.ActivatePaneDirection "Down",
  },
}

wezterm.on('update-right-status', function(window, pane)
  local current = window:active_workspace()
  local prev_current = workspace_state.current
  if current and current ~= "" and current ~= prev_current then
    if prev_current and prev_current ~= "" then
      workspace_state.last = prev_current
    end
    workspace_state.current = current
    if window.toast_notification and workspace_state.last_toast ~= current then
      window:toast_notification("Workspace", current, nil, 1500)
      workspace_state.last_toast = current
    end
  end

  local bg = "#073642"
  local fg = "#839496"
  local colors = window:effective_config().colors
  if colors and colors.tab_bar and colors.tab_bar.inactive_tab then
    local inactive_tab = colors.tab_bar.inactive_tab
    if inactive_tab.bg_color and inactive_tab.fg_color then
      bg = inactive_tab.bg_color
      fg = inactive_tab.fg_color
    end
  end

  local items = {}
  local workspace = window:active_workspace()
  if workspace and workspace ~= "" then
    table.insert(items, workspace)
  end

  local key_table = window:active_key_table()
  if key_table and key_table ~= "" then
    table.insert(items, 'TABLE: ' .. key_table)
  end

  local text = table.concat(items, " | ")
  if text ~= "" then
    window:set_right_status(wezterm.format({
      { Background = { Color = bg } },
      { Foreground = { Color = fg } },
      { Text = " " .. text .. " " },
    }))
  else
    window:set_right_status("")
  end
end)

config.key_tables = {
  launcher_search = {
    { key = "h", mods = "CTRL", action = wezterm.action.SendKey { key = 'Backspace' } },
  },
  tab_navigator = {
    { key = "h", mods = "CTRL", action = wezterm.action.SendKey { key = 'Backspace' } },
  },
  prompt_input_line = {
    { key = "h", mods = "CTRL", action = wezterm.action.SendKey { key = 'Backspace' } },
  },
}

config.leader = { key = "t", mods = "CTRL", timeout_milliseconds = 1000 }
config.scrollback_lines = 100000

return config
