-------------------------------------------------------------------------------
-- Beautiful                                                                 --
-------------------------------------------------------------------------------
local xresources = require("beautiful.xresources")
local xrdb = xresources.get_current_theme()
local dpi = xresources.apply_dpi
local rnotification = require("ruled.notification")
local lama = require("helpers.lama")
local theme = {}

---------------------------------------------------------------------------------
-- Default Apps
---------------------------------------------------------------------------------
theme.terminal = "kitty"
theme.shell = "zsh"
theme.browser = "firefox"
theme.editor = "nvim"
theme.music_player = "youtube-music"

theme.mail_ims = theme.terminal .. " -e neomutt -F ~/Sync/Rice/_private/mail-muttrcIMS"
theme.mail_st = theme.terminal .. " -e neomutt -F ~/Sync/Rice/_private/mail-muttrcUni"

-- Other Settings
theme.modkey = "Mod4"
theme.altkey = "Mod1"
theme.uwu_map = {
	["clear sky"] = "Clear Skywu",
	["few clouds"] = "Few Cloudwu",
	["scattered clouds"] = "Little Cloudwu",
	["broken clouds"] = "Much Cloudwu",
	["overcast clouds"] = "Only Cloudwu",
	["light rain"] = "Little Rainwu",
	["heavy intensity rain"] = "Heavy Rainwu!!",
	["moderate rain"] = "Moderate Rainwu",
	["shower rain"] = "Shower Rainwu",
	["rain"] = "rainwu",
	["light intensity shower rain"] = "Lil Shower Rainwu",
	["light shower snow"] = "Lil Shower Snowu",
	["light intensity drizzle"] = "Lil Drizzle Rainwu",
	["thunderstorm"] = "Thunderstormwu!!!!",
	["snow"] = "Snowu :)",
	["light snow"] = "Little Snowu",
	["rain and snow"] = "Rainwu, maybe little Snowu",
	["mist"] = "Mistwu",
	["fog"] = "Fogwu uww",
}

---------------------------------------------------------------------------------
-- Panel and Dashboard Settings
---------------------------------------------------------------------------------
theme.panel_right_width = dpi(550)
theme.sidepanel_margin = dpi(20)
theme.dashboard_margin = dpi(10)

---------------------------------------------------------------------------------
-- Theme Variables
---------------------------------------------------------------------------------
theme.font_name = "Cascadia Code"
theme.font_size = "14"
theme.font = theme.font_name .. " " .. theme.font_size

theme.useless_gap = dpi(32)
-- theme.useless_gap = dpi(10)
theme.size_hint_honor = false
theme.border_width = dpi(5)

theme.master_width_factor = 0.668

-- 1 red
-- 2 green
-- 3 orange
-- 4 blue
-- 5 red-light
-- 6 green-light
-- 7 gray
-- 8 gray-light
-- 9 red
---------------------------------------------------------------------------------
-- Colors
---------------------------------------------------------------------------------
-- Main xresources colors
theme.accent_color = xrdb.color4
theme.accent_alt_color = xrdb.color6
theme.main_color = xrdb.foreground
theme.bg_color = xrdb.background

-- Adjusted colors thanks to lama
theme.bg_color_light = lama.lighten(theme.bg_color, 5)
theme.main_color_light = lama.lighten(theme.main_color, 5)
theme.main_color_dark = lama.lighten(theme.main_color, -2)
theme.accent_color_dark = lama.lighten(theme.accent_color, -6)
theme.accent_alt_color_dark = lama.lighten(theme.accent_alt_color, -3)

theme.bg_dashboard_item = theme.bg_color_light

-- Reactive colors
theme.color_default = theme.accent_alt_color
theme.color_moderate = xrdb.color3
theme.color_stress = xrdb.color1
theme.color_critical = "#e54c62"

-- Default BG colors
theme.bg_normal = theme.bg_color
theme.bg_focus = theme.bg_color
theme.bg_urgent = theme.bg_color
theme.bg_minimize = theme.bg_color

if theme.transparent_bar then
	theme.bg_systray = theme.accent_color
else
	theme.bg_systray = theme.bg_color
end

theme.bg_bar_outer = theme.bg_color
theme.bg_bar_inner = theme.bg_color

-- Default FG colors
theme.fg_normal = theme.main_color
theme.fg_focus = theme.accent_color
theme.fg_urgent = theme.color_critical
theme.fg_minimize = theme.main_color

-- Border Color
theme.border_color = theme.bg_color
theme.border_color_normal = theme.bg_color
theme.border_color_active = theme.bg_color
theme.border_color_marked = theme.border_color

-- Taglist
if theme.transparent_bar then
	theme.taglist_fg_focus = theme.accent_color
	theme.taglist_fg_empty = "0000000"
	theme.taglist_fg_occupied = theme.accent_color .. "50"
	theme.taglist_fg_occupied = theme.main_color
	theme.taglist_fg_urgent = theme.main_color
	theme.taglist_bg_urgent = theme.color_critical
	theme.taglist_bg_occupied = "0000000"
else
	theme.taglist_fg_focus = theme.accent_color
	theme.taglist_fg_empty = theme.main_color
	theme.taglist_fg_occupied = theme.main_color
	theme.taglist_fg_urgent = theme.main_color
	theme.taglist_bg_urgent = theme.color_critical
	-- theme.taglist_fg_focus    = theme.accent_alt_color
	-- theme.taglist_bg_occupied = theme.bg_color
end

-- Tasklsit
theme.tasklist_fg_focus = theme.accent_color
theme.tasklist_fg_normal = theme.main_color
theme.tasklist_bg_focus = theme.bg_color_light5
theme.tasklist_bg_normal = theme.bg_color

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

---------------------------------------------------------------------------------
-- Notifications Settings
---------------------------------------------------------------------------------
local naughty = require("naughty")
naughty.config.defaults.ontop = true
naughty.config.defaults.timeout = 3
naughty.config.defaults.title = "System Notification"
naughty.config.defaults.margin = dpi(40)
-- naughty.config.defaults.position = "top_right"

-- For debugging
function Print(title, text)
	naughty.notify({
		title = title,
		text = text,
		bg = theme.bg_color,
		height = dpi(100),
		width = dpi(200),
		position = "bottom",
	})
end

return theme
