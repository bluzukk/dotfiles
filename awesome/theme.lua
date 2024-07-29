local xresources = require("beautiful.xresources")
local xrdb = xresources.get_current_theme()
local dpi = xresources.apply_dpi
local rnotification = require("ruled.notification")
local theme = {}

---------------------------------------------------------------------------------
-- Default Apps
---------------------------------------------------------------------------------
theme.terminal = "kitty"
theme.shell = "zsh"
theme.browser = "firefox"
theme.editor = "nvim"
theme.wallpaper = "~/.config/awesome/wall2.png"

theme.mail_ims = theme.terminal .. " -e neomutt -F ~/Sync/Rice/_private/mail-muttrcIMS"
theme.mail_st = theme.terminal .. " -e neomutt -F ~/Sync/Rice/_private/mail-muttrcUni"

-- Other Settings
theme.modkey = "Mod4"
theme.altkey = "Mod1"

theme.font_name = "Cascadia Code"
theme.font = "Cascadia Code 15"

theme.useless_gap = dpi(12)
theme.size_hint_honor = false
theme.border_width = dpi(4)

theme.master_width_factor = 0.668

theme.mauve = "#cba6f7"
theme.red = "#f38ba8"
theme.peach = "#fab387"
theme.yellow = "#f9e2af"
theme.green = "#a6e3a1"
theme.teal = "#6DB2B7"
theme.blue = "#89b4fa"
theme.lavender = "#b4befe"
theme.subtext = "#a6adc8"
theme.text = "#cdd6f4"

theme.main_color = theme.text
theme.accent_color = theme.mauve
theme.accent_alt_color = theme.lavender
theme.bg_color = "#1E1E2E"
theme.bg_color_light = "#202135"
-- theme.bg_color_light = "#1E1E2E"
-- theme.bg_color = "#202135"

-- Default BG colors
theme.bg_normal = theme.bg_color
theme.bg_focus = theme.bg_color
theme.bg_urgent = theme.bg_color
theme.bg_minimize = theme.bg_color
theme.bg_systray = theme.bg_color

-- Default FG colors
theme.fg_normal = theme.main_color
theme.fg_focus = theme.accent_color
theme.fg_urgent = theme.color_critical
theme.fg_minimize = theme.main_color

-- Border Color
theme.border_color = theme.bg_color
theme.border_color_normal = theme.bg_color
theme.border_color_active = theme.bg_color
theme.border_color_marked = theme.accent_color

-- theme.tasklist_disable_icon = true
-- theme.tasklist_bg_focus = theme.bg_color_light

theme.taglist_fg_focus = theme.text
theme.taglist_bg_focus = theme.bg_color_light
theme.taglist_fg_empty = theme.text
theme.taglist_bg_empty = theme.bg_color
theme.taglist_fg_occupied = theme.mauve
theme.taglist_bg_occupied = theme.bg_color
theme.taglist_fg_urgent = theme.main_color
theme.taglist_bg_urgent = theme.color_critical
theme.taglist_font = "Cascadia Code 16"
theme.taglist_spacing = 10

-- Notifications
theme.notification_shape = theme.shape
theme.notification_bg = theme.bg_color
theme.notification_fg = theme.main_color

-- Set different colors for urgent notifications.
rnotification.connect_signal("request::rules", function()
	rnotification.append_rule({
		rule = { urgency = "critical" },
		properties = { bg = theme.bg_color, fg = theme.color_critical },
	})
end)

return theme
