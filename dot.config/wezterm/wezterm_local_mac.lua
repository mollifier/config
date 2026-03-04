-- ln -s ~/etc/config/dot.config/wezterm/wezterm_local_mac.lua ~/.config/wezterm/wezterm_local.lua
local config = {}

-- brew tap homebrew/cask-fonts
-- brew install font-hack-nerd-font
config.font = wezterm.font { family = 'Nack Nerd Font', weight = 'Medium' }

return config
