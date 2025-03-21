-------------------------------------------------------------------------------
-- Evil Network Monitoring                                                   --
-------------------------------------------------------------------------------
-- Provides:                                                                 --
--   evil::net_ip4    : Current public IP4                                   --
--   evil::net_ssid   : Current SSID                                         --
--   evil::net_total  : Total download (rx_bytes)                            --
--   evil::net_now    : Current download speed (averaged rx_bytes)           --
-------------------------------------------------------------------------------
local awful = require("awful")

local cmd_ip4  = [[ curl ifconfig.me 2>/dev/null ]]
-- local cmd_ssid = [[ LANG=C nmcli -t -f active,ssid dev wifi | grep ^yes | cut -d: -f2- ]]
-- local cmd_down = [[ bash -c ". ~/.config/awesome/scripts/net-totals" ]]
-- local cmd_up   = [[ bash -c ". ~/.config/awesome/scripts/net-totals-up" ]]
local cmd_now  = [[ bash -c ". ~/.config/awesome/scripts/net-now" ]]

local interval_ip4  = 3600
-- local interval_ssid = 3600
-- local interval_total = 10
local interval_now = 1

-- IP4
awful.widget.watch(cmd_ip4, interval_ip4,
  function(_, evil) awesome.emit_signal("evil::net_ip4", evil) end)

-- SSID
-- awful.widget.watch(cmd_ssid, interval_ssid,
--   function(_, evil) awesome.emit_signal("evil::net_ssid", evil) end)

-- Total Download
-- awful.widget.watch(cmd_down, interval_total,
--     function(_, evil) awesome.emit_signal("evil::net_total", tonumber(evil)) end)
--

local last = 0
awful.widget.watch(cmd_now, interval_now, function(_, evil)
  local now = evil - last
  last = evil
  awesome.emit_signal("evil::net_now", tonumber(now))
end)
