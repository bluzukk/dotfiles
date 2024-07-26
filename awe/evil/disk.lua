-------------------------------------------------------------------------------
-- Evil Disk Monitoring                                                      --
-------------------------------------------------------------------------------
-- Provides:                                                                 --
--   evil::disk_free   : Free space on main storage disk                     --
--   evil::disk_total  : (TODO) Total space on main storage disk             --
--   evil::disk_info   : (TODO) Info about filesystem                        --
-------------------------------------------------------------------------------
local awful = require("awful")

local cmd_space = [[ bash -c "df -h /home | awk ' /[0-9]/ {print $4}'" ]]
local interval = 60

awful.widget.watch(cmd_space, interval, function(_, evil)
	awesome.emit_signal("evil::disk_free", string.match(evil, "%d+"))
end)
