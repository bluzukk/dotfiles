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
-- local cmd_util     = [[ bash -c "cpu-util" ]]
local interval     = 1

local util         = require("helpers.util")
local math         = math
local string       = string

local cpu = { core = {} }
function cpu.update()
    for index, time in pairs(util.lines_match("cpu", "/proc/stat")) do
        local coreid = index - 1
        local core   = cpu.core[coreid] or
            { last_active = 0, last_total = 0, usage = 0 }
        local at     = 1
        local idle   = 0
        local total  = 0

        for field in string.gmatch(time, "[%s]+([^%s]+)") do
            if at == 4 or at == 5 then
                idle = idle + field
            end
            total = total + field
            at = at + 1
        end

        local active = total - idle

        if core.last_active ~= active or core.last_total ~= total then
            local dactive    = active - core.last_active
            local dtotal     = total - core.last_total
            local usage      = math.floor(((dactive / dtotal) * 100))

            core.last_active = active
            core.last_total  = total
            core.usage       = usage

            cpu.core[coreid] = core
        end
    end

    return cpu.core[0].usage
end

local cpu_util, cpu_temp_ctl, cpu_temp_ccd = 0, 0, 0
gears.timer {
    timeout   = interval,
    call_now  = true,
    autostart = true,
    callback  = function()
        cpu_util = cpu.update()
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
        awful.spawn.easy_async("sleep 1",
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
