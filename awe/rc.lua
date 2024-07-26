pcall(require, "luarocks.loader")

local beautiful = require("beautiful")
local naughty = require("naughty")
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

naughty.connect_signal("request::display_error", function(message, startup)
	naughty.notification({
		urgency = "critical",
		title = "Oops, an error happened" .. (startup and " during startup!" or "!"),
		message = message,
	})
end)

beautiful.init("/home/keklon/Stuff/awesome/theme.lua")

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

-- Panel configuration
require("evil.cpu")
require("evil.gpu")
require("evil.netw")
require("evil.disk")
require("evil.ram")
require("evil.mail")
require("evil.bat")

require("panel")
require("clients")
require("keybinds")

PROMPT = require("prompt")

-- {{{ Autostart programs
local function run_once(cmd_arr)
	for _, cmd in ipairs(cmd_arr) do
		awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
	end
end

run_once({
	"~/.config/awesome/scripts/startup",
	"setxkbmap de",
})

-- Run garbage collector regularly to prevent memory leaks
gears.timer({
	timeout = 600,
	autostart = true,
	callback = function()
		collectgarbage()
	end,
})
