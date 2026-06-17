local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Fonts and Text
config.font = wezterm.font('0xProto Nerd Font')
config.font_size = 13.5
config.line_height = 1.30
config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' }

-- Appearance and Theme
config.color_scheme = 'Catppuccin Mocha'
config.window_background_opacity = 0.85
config.window_decorations = 'RESIZE | TITLE' -- macOS native traffic light buttons
config.enable_tab_bar = true
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.tab_and_split_indices_are_zero_based = true

config.window_padding = {
	left = '1cell',
	right = '1cell',
	top = '1cell',
	bottom = '1.5cell',
}

-- Performance and Smoothness (ProMotion 120Hz)
config.max_fps = 120
config.animation_fps = 120
config.cursor_blink_rate = 800
config.scrollback_lines = 5000

-- Keybindings
config.leader = { key = 'Space', mods = 'CTRL|SHIFT', timeout_milliseconds = 1000 }
config.keys = {
  -- Pane navigation: OPT instead of CTRL to avoid conflicts with shell/readline
  { key = 'h',     mods = 'OPT',    action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'j',     mods = 'OPT',    action = wezterm.action.ActivatePaneDirection 'Down' },
  { key = 'k',     mods = 'OPT',    action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'l',     mods = 'OPT',    action = wezterm.action.ActivatePaneDirection 'Right' },
  { key = '|',     mods = 'LEADER', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '-',     mods = 'LEADER', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'H',     mods = 'LEADER', action = wezterm.action.AdjustPaneSize { 'Left', 5 } },
  { key = 'J',     mods = 'LEADER', action = wezterm.action.AdjustPaneSize { 'Down', 5 } },
  { key = 'K',     mods = 'LEADER', action = wezterm.action.AdjustPaneSize { 'Up', 2 } },
  { key = 'L',     mods = 'LEADER', action = wezterm.action.AdjustPaneSize { 'Right', 2 } },
  { key = 'x',     mods = 'LEADER', action = wezterm.action.CloseCurrentPane { confirm = false } },
  { key = 'Enter', mods = 'LEADER', action = wezterm.action.ToggleFullScreen },
  { key = 'n',     mods = 'CMD',    action = wezterm.action.SpawnCommandInNewWindow { } },
  { key = 'p',     mods = 'LEADER', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
}

-- =============================================
-- Window Constraints
config.initial_cols = 120
config.initial_rows = 20
config.inactive_pane_hsb = { saturation = 0.9, brightness = 0.8 }
config.window_close_confirmation = 'NeverPrompt'
config.enable_scroll_bar = false

return config
