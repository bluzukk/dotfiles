-- stylua: ignore start
pcall(require, "luarocks.loader")

local awful     = require("awful")
local beautiful = require("beautiful")
local gears     = require("gears")
local helpers   = require("helpers.util")
local naughty   = require("naughty")
local wibox     = require("wibox")

naughty.connect_signal("request::display_error", function(message, startup)
	naughty.notification({
		urgency = "critical",
		title = "Oops, an error happened" .. (startup and " during startup!" or "!"),
		message = message,
	})
end)

beautiful.init("~/.config/awesome/theme.lua")

screen.connect_signal("request::wallpaper", function(s)
	awful.wallpaper({
		screen = s,
		widget = {
			image = beautiful.wallpaper,
			horizontal_fit_policy = "fit",
			vertical_fit_policy = "fit",
			resize = true,
			widget = wibox.widget.imagebox,
		},
	})
end)

local private = os.getenv("HOME") .. "/Sync/Rice/_private"
CITY          = helpers.read_line(private .. "/weather-city") or "Tokyo"
LONGTIUIDE    = helpers.read_line(private .. "/gps-longtiude") or "0"
LATITUDE      = helpers.read_line(private .. "/gps-latitude") or "0"
OWM_APIID     = helpers.read_line(private .. "/weather-owm-key") or "XXXXXXXXXXXXXXXX"

require("evil.cpu")
require("evil.gpu")
require("evil.netw")
require("evil.disk")
require("evil.ram")
require("evil.mail")
require("evil.bat")
require("evil.weather")
require("evil.update")

require("panel")
require("clients")
require("keybinds")

PROMPT = require("prompt")
VOLUME = require("volume")

awful.spawn.with_shell("xcompmgr")
awful.spawn.with_shell("~/.config/awesome/scripts/startup")
awful.spawn.with_shell(string.format("sleep 1; redshift -l %s:%s", LATITUDE, LONGTIUIDE))

gears.timer({ timeout = 600, autostart = true, callback = function() collectgarbage() end })
