-------------------------------------------------------------------------------
-- Autostart on startup                                                      --
-------------------------------------------------------------------------------
local awful = require("awful")
local gears = require("gears")

-- {{{ Autostart programs
local function run_once(cmd_arr)
  for _, cmd in ipairs(cmd_arr) do
    awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
  end
end

run_once({ "picom", "setxkbmap de" })

-- Run garbage collector regularly to prevent memory leaks
gears.timer {
  timeout = 600,
  autostart = true,
  callback = function() collectgarbage() end
}
