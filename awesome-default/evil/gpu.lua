-------------------------------------------------------------------------------
-- Evil GPU Monitoring                                                       --
-------------------------------------------------------------------------------
-- Provides:                                                                 --
--   evil::gpu_temp   : Current GPU temperature                              --
--   evil::gpu_util   : Current GPU utilization                              --
-------------------------------------------------------------------------------
local awful = require("awful")
local gears = require("gears")

local cmd_temp = [[ nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader ]]
local cmd_util = [[ nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader ]]
local cmd_clock = [[ nvidia-smi --query-gpu=clocks.current.graphics --format=csv,noheader ]]
local cmd_power = [[ nvidia-smi --query-gpu=power.draw --format=csv,noheader]]
local interval = 5

-- TODO fix for multi GPU
local function split_str(str)
	-- Split output
	local result = {}
	for line in str:gmatch("([^\n]*)\n?") do
		result = line
	end
	return result
end

local gpu_util, gpu_temp, gpu_clock, gpu_power = 0, 0, 0, 0
gears.timer({
	timeout = interval,
	call_now = true,
	autostart = true,
	callback = function()
		awful.spawn.easy_async(cmd_util, function(evil)
			gpu_util = tonumber(string.match(split_str(evil), "%d+"))
		end)
		awful.spawn.easy_async(cmd_temp, function(evil)
			gpu_temp = tonumber(string.match(split_str(evil), "%d+"))
		end)
		awful.spawn.easy_async(cmd_clock, function(evil)
			gpu_clock = tonumber(string.match(split_str(evil), "%d+"))
		end)
		awful.spawn.easy_async(cmd_power, function(evil)
			gpu_power = tonumber(string.match(split_str(evil), "%d+"))
		end)
		awful.spawn.easy_async("sleep 0.2", function()
			awesome.emit_signal("evil::gpu", gpu_util, gpu_temp, gpu_clock, gpu_power)
		end)
	end,
})

-- awful.widget.watch(cmd_temp, interval,
--     function(_, evil) awesome.emit_signal("evil::gpu_temp", tonumber(evil)) end)
--
-- awful.widget.watch(cmd_util, interval,
--     function(_, evil) awesome.emit_signal("evil::gpu_util", string.match(evil, "%d+")) end)
--
-- awful.widget.watch(cmd_clock, interval,
--     function(_, evil) awesome.emit_signal("evil::gpu_clock", string.match(evil, "%d+")) end)
--
-- awful.widget.watch(cmd_power, interval,
--     function(_, evil) awesome.emit_signal("evil::gpu_power", string.match(evil, "%d+")) end)
--
-- awful.widget.watch(cmd_util, interval,
--     function(_, evil) awesome.emit_signal("evil::gpu_watt", string.match(evil, "%d+")) end)
