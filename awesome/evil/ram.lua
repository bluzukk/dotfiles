-------------------------------------------------------------------------------
-- Evil RAM Monitoring                                                       --
-------------------------------------------------------------------------------
-- Provides:                                                                 --
--   evil::ram        : Used RAM                                             --
--   evil::ram_total  : @todo Total available RAM                            --
-------------------------------------------------------------------------------
local awful    = require("awful")
local gears    = require("gears")

local cmd_used = [[ bash -c ". ~/.config/awesome/scripts/ram-util" ]]
local interval = 10

gears.timer {
  timeout   = interval,
  call_now  = true,
  autostart = true,
  callback  = function()
    awful.spawn.easy_async(cmd_used,
      function(evil)
        if evil ~= "" then
          awesome.emit_signal("evil::ram", tonumber(evil))
        end
      end)
  end
}
