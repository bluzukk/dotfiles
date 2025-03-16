-------------------------------------------------------------------------------
-- Evil Battery Monitoring                                                   --
-------------------------------------------------------------------------------
-- Provides:                                                                 --
--   evil::bat_perc    : Current battery percentage                          --
-------------------------------------------------------------------------------
local awful = require("awful")

local cmd_bat = "cat /sys/class/power_supply/BAT0/capacity"
local interval = 60

awful.widget.watch(cmd_bat, interval, function(_, evil)
	awesome.emit_signal("evil::bat", tonumber(evil))
end)
