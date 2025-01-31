local wezterm = require 'wezterm'
local act = wezterm.action
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- backslash on mac
config.send_composed_key_when_left_alt_is_pressed = true

config.font_size = 15.0

-- config.color_scheme = 'Neon Night (Gogh)'
-- config.color_scheme = 'Night Owl (Gogh)'
-- config.color_scheme = 'Nocturnal Winter'
-- config.color_scheme = 'nightfox'
config.color_scheme = 'iceberg-dark'

config.hide_tab_bar_if_only_one_tab = true
config.adjust_window_size_when_changing_font_size = false

config.enable_scroll_bar = false
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

config.initial_cols = 160
config.initial_rows = 40
config.window_background_opacity = 0.93

config.mouse_bindings = {
  -- Disable mouse WheelUp/Down
  {
    event = { Down = { streak = 1, button = { WheelUp = 1 } } },
    mods = 'NONE',
    action = act.Nop,
  },

  -- Scrolling down while holding CTRL decreases the font size
  {
    event = { Down = { streak = 1, button = { WheelDown = 1 } } },
    mods = 'NONE',
    action = act.Nop,
  },

  -- Change the default click behavior so that it only selects
  -- text and doesn't open hyperlinks
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = act.CompleteSelection 'ClipboardAndPrimarySelection',
  },

  -- and make CTRL-Click open hyperlinks
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = act.OpenLinkAtMouseCursor,
  },
  -- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
  {
    event = { Down = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = act.Nop,
  },
}

return config
