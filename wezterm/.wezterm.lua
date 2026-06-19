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
config.window_decorations = 'RESIZE | TITLE'
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

-- =============================================
-- macOS Option key fix
-- Left Option acts as a plain modifier (so CMD+OPT+h/j/k/l bindings work).
-- Right Option keeps composing special characters (|, @, etc.) -- important
-- on Norwegian and other non-US layouts where these chars require OPT combos.
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = true

-- =============================================
-- Leader key
-- CTRL+SHIFT+Space conflicts with macOS Input Source switching (it's a system
-- default you'd have to disable in System Settings). CTRL+A is the de-facto
-- standard on macOS (same as the classic tmux prefix) and has no system conflict.
-- Double-tap CTRL+A sends a literal CTRL+A to the shell (useful for readline).
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }

-- =============================================
-- Keybindings
config.keys = {

  -- ── Pane navigation ────────────────────────────────────────────────────────
  -- Changed from OPT to CMD+OPT. Plain OPT+key is consumed by macOS for
  -- special character input even with send_composed_key_when_*_alt_is = 'Mapped'
  -- in some system configurations. CMD+OPT is safe and conflict-free on macOS.
  { key = 'h',          mods = 'CMD|OPT',     action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'j',          mods = 'CMD|OPT',     action = wezterm.action.ActivatePaneDirection 'Down' },
  { key = 'k',          mods = 'CMD|OPT',     action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'l',          mods = 'CMD|OPT',     action = wezterm.action.ActivatePaneDirection 'Right' },

  -- ── Splits ─────────────────────────────────────────────────────────────────
  -- LEADER+| / LEADER+- kept exactly as before; leader is now CTRL+A.
  { key = '|',          mods = 'LEADER',      action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '-',          mods = 'LEADER',      action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },

  -- ── Pane resizing ──────────────────────────────────────────────────────────
  -- Unified step size (was asymmetric: H/J=5, K/L=2 — likely a copy-paste typo).
  { key = 'H',          mods = 'LEADER',      action = wezterm.action.AdjustPaneSize { 'Left', 5 } },
  { key = 'J',          mods = 'LEADER',      action = wezterm.action.AdjustPaneSize { 'Down', 5 } },
  { key = 'K',          mods = 'LEADER',      action = wezterm.action.AdjustPaneSize { 'Up', 5 } },
  { key = 'L',          mods = 'LEADER',      action = wezterm.action.AdjustPaneSize { 'Right', 5 } },

  -- ── Pane / tab management ──────────────────────────────────────────────────
  { key = 'x',          mods = 'LEADER',      action = wezterm.action.CloseCurrentPane { confirm = false } },
  { key = 'p',          mods = 'LEADER',      action = wezterm.action.SpawnTab 'CurrentPaneDomain' },

  -- ── Fullscreen ─────────────────────────────────────────────────────────────
  -- LEADER+Enter kept as before. CMD+CTRL+F is the native macOS shortcut for
  -- fullscreen and also works out of the box (no config needed).
  { key = 'Enter',      mods = 'LEADER',      action = wezterm.action.ToggleFullScreen },

  -- ── New window ─────────────────────────────────────────────────────────────
  -- CMD+N is already a WezTerm built-in default on macOS (SpawnWindow).
  -- Restated here explicitly so the intent is clear and the behaviour is locked.
  { key = 'n',          mods = 'CMD',         action = wezterm.action.SpawnCommandInNewWindow {} },

  -- ── Send literal CTRL+A to shell (readline: jump to line start) ────────────
  -- When CTRL+A is your leader, you lose the readline shortcut. Press it twice
  -- (CTRL+A, CTRL+A) to pass a real CTRL+A through to the terminal.
  { key = 'a',          mods = 'LEADER|CTRL', action = wezterm.action.SendKey { key = 'a', mods = 'CTRL' } },

  -- ── macOS-native text navigation (not built into WezTerm by default) ───────
  -- These make Option/Command arrow keys behave the way every other macOS app
  -- does. WezTerm doesn't ship these by default because it tries to stay
  -- cross-platform, but they are the right thing to add on Mac.
  { key = 'LeftArrow',  mods = 'OPT',         action = wezterm.action.SendKey { key = 'b', mods = 'ALT' } }, -- word left
  { key = 'RightArrow', mods = 'OPT',         action = wezterm.action.SendKey { key = 'f', mods = 'ALT' } }, -- word right
  { key = 'LeftArrow',  mods = 'CMD',         action = wezterm.action.SendKey { key = 'a', mods = 'CTRL' } }, -- line start
  { key = 'RightArrow', mods = 'CMD',         action = wezterm.action.SendKey { key = 'e', mods = 'CTRL' } }, -- line end
  { key = 'Backspace',  mods = 'CMD',         action = wezterm.action.SendKey { key = 'u', mods = 'CTRL' } }, -- delete whole line
}

-- =============================================
-- Window Constraints
config.initial_cols = 120
config.initial_rows = 20
config.inactive_pane_hsb = { saturation = 0.9, brightness = 0.8 }
config.window_close_confirmation = 'NeverPrompt'
config.enable_scroll_bar = false

return config

-- =============================================
-- REFERENCE: WezTerm built-in macOS defaults (no config needed)
-- These work out of the box — listed here so you can study them.
-- ─────────────────────────────────────────────────────────────
-- Tabs
--   CMD+T              New tab
--   CMD+W              Close current tab
--   CMD+1…9            Jump to tab by index
--   CMD+SHIFT+[        Previous tab   (also CTRL+SHIFT+Tab)
--   CMD+SHIFT+]        Next tab       (also CTRL+Tab)
--
-- Window
--   CMD+N              New window
--   CMD+M              Minimise window
--   CMD+H              Hide window
--   CMD+Q              Quit WezTerm
--   CMD+CTRL+F         Toggle native macOS fullscreen
--   CMD+R              Reload config
--
-- Panes (WezTerm built-in, no leader needed)
--   CTRL+SHIFT+ALT+"   Split pane vertically   (new pane below)
--   CTRL+SHIFT+ALT+%   Split pane horizontally (new pane right)
--   CTRL+SHIFT+↑/↓/←/→  Move focus between panes
--
-- Copy / Paste
--   CMD+C              Copy selection
--   CMD+V              Paste
--   CMD+SHIFT+C        Copy to clipboard (alternate)
--
-- Font size
--   CMD+=              Increase font size
--   CMD+-              Decrease font size
--   CMD+0              Reset font size
--
-- Search & Debug
--   CMD+F              Find / search scrollback
--   CTRL+SHIFT+L       Open debug overlay (Lua REPL + logs)
--   CMD+P  (or CTRL+SHIFT+P)  Open command palette
