local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

-- Font
config.font = wezterm.font '0xProto Nerd Font'
config.font_size = 13.5
config.line_height = 1.30
config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' }

-- Appearance
config.color_scheme = 'Catppuccin Mocha'
config.window_background_opacity = 0.85
config.window_decorations = 'RESIZE | TITLE'
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = false
config.tab_and_split_indices_are_zero_based = true
config.inactive_pane_hsb = { saturation = 0.9, brightness = 0.8 }
config.window_padding = {
  left = '1cell',
  right = '1cell',
  top = '1cell',
  bottom = '1.5cell',
}

-- Window
config.initial_cols = 120
config.initial_rows = 20
config.window_close_confirmation = 'NeverPrompt'
config.enable_scroll_bar = false

-- Performance (ProMotion 120Hz)
config.max_fps = 120
config.animation_fps = 120
config.cursor_blink_rate = 800
config.scrollback_lines = 10000

-- Left Option = plain modifier (for keybindings). Right Option composes
-- special characters (|, @, etc.) — required on Norwegian layout.
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = true

-- Leader: CTRL+A (tmux-style). Double-tap sends a literal CTRL+A through.
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1500 }

-- Show "LEADER" in the tab bar while the leader is active.
wezterm.on('update-right-status', function(window, _)
  window:set_right_status(window:leader_is_active() and ' LEADER ' or '')
end)

config.keys = {
  { key = 'a', mods = 'LEADER|CTRL', action = act.SendKey { key = 'a', mods = 'CTRL' } },

  -- Pane navigation
  { key = 'h', mods = 'CMD|OPT', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'CMD|OPT', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'CMD|OPT', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'CMD|OPT', action = act.ActivatePaneDirection 'Right' },

  -- Splits: v = new pane to the right, s = new pane below
  { key = 'v', mods = 'LEADER', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 's', mods = 'LEADER', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },

  -- Pane resizing
  { key = 'H', mods = 'LEADER', action = act.AdjustPaneSize { 'Left', 5 } },
  { key = 'J', mods = 'LEADER', action = act.AdjustPaneSize { 'Down', 5 } },
  { key = 'K', mods = 'LEADER', action = act.AdjustPaneSize { 'Up', 5 } },
  { key = 'L', mods = 'LEADER', action = act.AdjustPaneSize { 'Right', 5 } },

  -- Pane / tab management
  { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },
  { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = false } },
  { key = 'p', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'Enter', mods = 'LEADER', action = act.ToggleFullScreen },

  -- macOS-native text navigation
  { key = 'LeftArrow', mods = 'OPT', action = act.SendKey { key = 'b', mods = 'ALT' } }, -- word left
  { key = 'RightArrow', mods = 'OPT', action = act.SendKey { key = 'f', mods = 'ALT' } }, -- word right
  { key = 'LeftArrow', mods = 'CMD', action = act.SendKey { key = 'a', mods = 'CTRL' } }, -- line start
  { key = 'RightArrow', mods = 'CMD', action = act.SendKey { key = 'e', mods = 'CTRL' } }, -- line end
  { key = 'Backspace', mods = 'CMD', action = act.SendKey { key = 'u', mods = 'CTRL' } }, -- delete line
}

return config
