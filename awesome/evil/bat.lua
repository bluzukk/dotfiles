-------------------------------------------------------------------------------
-- Evil Battery Monitoring                                                   --
-------------------------------------------------------------------------------
-- Provides:                                                                 --
--   evil::bat_perc    : Current battery percentage                          --
--   evil::bat_status  : (TODO) Battery status i.e. charging                 --
-------------------------------------------------------------------------------
local awful = require("awful")

local cmd_bat = "cat /sys/class/power_supply/BAT0/capacity"
local interval = 180

awful.widget.watch(cmd_bat, interval,
    function(_, evil) awesome.emit_signal("evil::bat", evil) end)
