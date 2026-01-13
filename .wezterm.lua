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
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false
config.show_close_tab_button_in_tabs = false
config.window_decorations = "RESIZE"

local function run_git(cwd, args)
  return wezterm.run_child_process({ "git", "-C", cwd, table.unpack(args) })
end

local function git_repo_slug(pane)
  local cwd_uri = pane:get_current_working_dir()
  if not cwd_uri then
    return nil
  end
  local cwd = type(cwd_uri) == "string" and cwd_uri or (cwd_uri.file_path or tostring(cwd_uri))
  if not cwd or cwd == "" then
    return nil
  end
  cwd = cwd:gsub("^file://", "")

  local workspace_match = cwd:match("^/Users/[^/]+/Workspace/([^/]+)")
  if workspace_match and workspace_match ~= "" then
    return workspace_match
  end

  local ok, out = run_git(cwd, { "config", "--get", "remote.origin.url" })
  if ok and out then
    local url = out:gsub("%s+$", "")
    local slug = url:match("github.com[:/](.-)%.git$") or url:match("github.com[:/](.+)$")
    if slug and slug ~= "" then
      return slug
    end
  end

  local ok_top, out_top = run_git(cwd, { "rev-parse", "--show-toplevel" })
  if not ok_top or not out_top then
    return nil
  end
  local path = out_top:gsub("%s+$", "")
  return path:match("([^/]+)$")
end

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
    key = "o",
    mods = "CMD|SHIFT",
    action = wezterm.action_callback(function(window, pane)
      window:perform_action(
        wezterm.action.PromptInputLine {
          description = "Workspace name",
          initial_value = git_repo_slug(pane) or "",
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
  local colors = window:effective_config().colors
  local inactive_tab = colors.tab_bar.inactive_tab
  local bg = inactive_tab.bg_color
  local fg = inactive_tab.fg_color
  local items = {}
  local workspace = window:active_workspace()
  if workspace and workspace ~= "" then
    table.insert(items, workspace)
  end
  local key_table = window:active_key_table()
  if key_table and key_table ~= "" then
    table.insert(items, 'TABLE: ' .. key_table)
  end
  local text = table.concat(items, ' | ')
  local padded = text ~= "" and (text .. "  ") or ""
  window:set_right_status(wezterm.format({
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Text = padded },
  }))
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
