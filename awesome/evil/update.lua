-------------------------------------------------------------------------------
-- Evil Update                                                               --
-------------------------------------------------------------------------------
-- Provides:                                                                 --
--   evil::update: Returns true if packages can be upgraded                  --
-------------------------------------------------------------------------------
local awful = require("awful")

local cmd = [[ bash -c "mintupdate-cli list" ]]
local interval = 600

awful.widget.watch(cmd, interval, function(_, evil)
  if evil == "" then
   awesome.emit_signal("evil::update", false)
  else
   awesome.emit_signal("evil::update", true)
  end
end)
