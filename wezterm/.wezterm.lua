local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- =============================================
-- 1. Initial domain
-- =============================================
config.default_domain = 'local'
config.default_prog = { 'powershell.exe' }

-- =============================================
-- 2. Font (0xProto Nerd Font)
-- =============================================
config.font = wezterm.font('0xProto Nerd Font')
config.font_size = 13.5
config.line_height = 1.30
config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' }

-- =============================================
-- 3. Renderer (Optimized for Snapdragon X)
-- =============================================
config.front_end = 'WebGpu'

-- =============================================
-- 4. Appearance & Theme
-- =============================================
config.color_scheme = 'Catppuccin Mocha'
config.window_background_opacity = 0.85
config.win32_system_backdrop = 'Acrylic'
config.window_decorations = 'RESIZE'
config.enable_tab_bar = true
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.tab_and_split_indices_are_zero_based = true

config.window_padding = {
  left   = '1cell',
  right  = '1cell',
  top    = '1cell',
  bottom = '1.5cell',
}

-- =============================================
-- 5. Performance / Smoothness
-- =============================================
config.max_fps = 60
config.animation_fps = 60
config.cursor_blink_rate = 800
config.scrollback_lines = 5000

-- =============================================
-- 6. Keybindings
-- =============================================
config.leader = { key = 'Space', mods = 'CTRL|SHIFT', timeout_milliseconds = 1000 }
config.keys = {
  { key = 'h',     mods = 'CTRL',   action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'j',     mods = 'CTRL',   action = wezterm.action.ActivatePaneDirection 'Down' },
  { key = 'k',     mods = 'CTRL',   action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'l',     mods = 'CTRL',   action = wezterm.action.ActivatePaneDirection 'Right' },
  { key = '|',     mods = 'LEADER', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '-',     mods = 'LEADER', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'H',     mods = 'LEADER', action = wezterm.action.AdjustPaneSize { 'Left', 5 } },
  { key = 'J',     mods = 'LEADER', action = wezterm.action.AdjustPaneSize { 'Down', 5 } },
  { key = 'K',     mods = 'LEADER', action = wezterm.action.AdjustPaneSize { 'Up', 2 } },
  { key = 'L',     mods = 'LEADER', action = wezterm.action.AdjustPaneSize { 'Right', 2 } },
  { key = 'x',     mods = 'LEADER', action = wezterm.action.CloseCurrentPane { confirm = false } },
  { key = 'Enter', mods = 'LEADER', action = wezterm.action.ToggleFullScreen },
  { key = 'u',     mods = 'LEADER', action = wezterm.action.SpawnTab { DomainName = 'WSL:Ubuntu' } },
  { key = 'p',     mods = 'LEADER', action = wezterm.action.SpawnTab { DomainName = 'local' } },
}

-- =============================================
-- 7. Visual Confirmation (Fixed Version)
-- =============================================
wezterm.on('window-config-reloaded', function(window)
  window:toast_notification('WezTerm', 'Fresh as a baby\'s ass!', nil, 2000)
end)

-- =============================================
-- 8. SERIAL PORT CONFIGURATION (The Scale)
-- =============================================
config.serial_ports = {
  {
    name = 'scale',
    port = 'COM9',
    baud = 9600,
  },
}

-- =============================================
-- 9. WINDOW STUFF
-- =============================================
config.initial_cols = 120
config.initial_rows = 20
config.inactive_pane_hsb = { saturation = 0.9, brightness = 0.8 }
config.window_close_confirmation = 'NeverPrompt'
config.enable_scroll_bar = false

return config
