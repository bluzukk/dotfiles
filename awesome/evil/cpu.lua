-------------------------------------------------------------------------------
-- Evil CPU Monitoring                                                       --
-------------------------------------------------------------------------------
-- Provides:                                                                 --
--   evil::cpu  cpu_util      : Current CPU utilization                      --
--   evil::cpu: cpu_temp_ctl  : Current CPU ctl temperature                  --
--   evil::cpu: cpu_temp_ccd  : Current CPU ccd temperature                  --
-------------------------------------------------------------------------------
local awful        = require("awful")
local gears        = require("gears")

local cmd_temp_ctl = [[ cat /sys/class/hwmon/hwmon1/temp1_input ]]
local cmd_temp_ccd = [[ cat /sys/class/hwmon/hwmon1/temp4_input ]]
local cmd_util     = [[ bash -c "cpu-util" ]]
local interval     = 5

local cpu_util, cpu_temp_ctl, cpu_temp_ccd = 0, 0, 0

gears.timer {
    timeout   = interval,
    call_now  = true,
    autostart = true,
    callback  = function()
        awful.spawn.easy_async(cmd_util,
            function(evil)
                if evil ~= "" then
                    cpu_util = tonumber(evil)
                end
            end)
        awful.spawn.easy_async(cmd_temp_ctl,
            function(evil)
                if evil ~= "" then
                    cpu_temp_ctl = tonumber(string.format("%02.f", tonumber(evil / 1000)))
                end
            end)
        awful.spawn.easy_async(cmd_temp_ccd,
            function(evil)
                if evil ~= "" then
                    cpu_temp_ccd = tonumber(string.format("%02.f", tonumber(evil / 1000)))
                end
            end)
        awful.spawn.easy_async("sleep 5",
            function()
                awesome.emit_signal("evil::cpu", cpu_util, cpu_temp_ctl, cpu_temp_ccd)
            end)
    end
}

-- awful.widget.watch(cmd_temp_ctl, interval/2,
--     function(_, evil) awesome.emit_signal("evil::cpu_temp_ctl",
--         string.format("%02.f", tonumber(evil/1000))) end)
--
-- awful.widget.watch(cmd_temp_ccd, interval/2,
--     function(_, evil) awesome.emit_signal("evil::cpu_temp_ccd",
--         string.format("%02.f", tonumber(evil/1000))) end)
--
-- awful.widget.watch(cmd_util, interval,
--     function(_, evil) awesome.emit_signal("evil::cpu_util", tonumber(evil)) end)
