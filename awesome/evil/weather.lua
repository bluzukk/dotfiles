local awful = require("awful")

local cmd_weather = 'bash -c ". ~/.config/awesome/scripts/weather ' .. OWM_APIID .. " " .. CITY .. '"'
local interval = 180

awful.widget.watch(cmd_weather, interval, function(_, evil)
	local out = {} -- [city, temperature, status]
	for s in evil:gmatch("[^\r\n]+") do
		table.insert(out, s)
	end
	awesome.emit_signal("evil::weather_now", out)
end)
