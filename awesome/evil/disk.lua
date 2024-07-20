-------------------------------------------------------------------------------
-- Evil Disk Monitoring                                                      --
-------------------------------------------------------------------------------
-- Provides:                                                                 --
--   evil::disk_free   : Free space on main storage disk                     --
--   evil::disk_total  : (TODO) Total space on main storage disk             --
--   evil::disk_info   : (TODO) Info about filesystem                        --
-------------------------------------------------------------------------------
local awful = require("awful")

local cmd_space = [[ bash -c ". ~/.config/awesome/scripts/disk-home" ]]
local interval = 60

awful.widget.watch(cmd_space, interval, function(_, evil)
	awesome.emit_signal("evil::disk_free", string.match(evil, "%d+"))
end)
