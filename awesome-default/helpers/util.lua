-------------------------------------------------------------------------------
-- Utils                                                                     --
-------------------------------------------------------------------------------
local helpers = {}
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local spawn = awful.spawn

local function file_exists(file)
	if file ~= nil then
		local f = io.open(file, "rb")
		if f then
			f:close()
		end
		return f ~= nil
	end
	return nil
end

function helpers.file_exists(file)
	if file then
		local f = io.open(file, "rb")
		if f then
			f:close()
		end
		return f ~= nil
	end
	--return false
end

function helpers.read_line(path)
	if file_exists(path) then
		for line in io.lines(path) do
			if #line then
				return line
			end
		end
	end
	return nil
end

function helpers.read_lines(path)
	if not file_exists(path) then
		return nil
	end
	local lines = {}
	for line in io.lines(path) do
		lines[#lines + 1] = line
	end
	return lines
end

function helpers.async(cmd, callback)
	return spawn.easy_async(cmd, function(stdout, stderr, reason, exit_code)
		callback(stdout, exit_code, stderr, reason)
	end)
end

function helpers.read_cmd(cmd)
	local result = {}
	local handle = io.popen(cmd)
	if handle then
		local output = handle:read("*a")
		handle:close()
		for s in output:gmatch("[^\r\n]+") do
			table.insert(result, s)
		end
	end
	return result
end

-- On the fly useless gaps change (lain)
function helpers.useless_gaps_resize(thatmuch, s, t)
	local scr = s or awful.screen.focused()
	local tag = t or scr.selected_tag
	local target = tonumber(thatmuch) + tag.gap
	if target < 5 then
		tag.gap = 0
	elseif target > 200 then
		tag.gap = 200
	else
		tag.gap = tag.gap + tonumber(thatmuch)
	end

	awful.layout.arrange(scr)
end

----------------------------------------------------------
-- Mark focused client with border while "cycling"
local function hideborder()
	local focused = client.focus
	if focused then
		focused.border_color = beautiful.bg_color
	end
end
local border_timer
border_timer = gears.timer({
	timeout = 0.5,
	autostart = false,
	run_once = true,
	callback = function()
		hideborder()
		border_timer:stop()
	end,
})

function helpers.showborder()
	border_timer:stop()
	hideborder()
	local screen = awful.screen.focused()
	local clients = screen.selected_tag:clients()
	for _, c in pairs(clients) do
		c.border_color = beautiful.bg_color
	end
	if client.focus then
		client.focus.border_color = beautiful.accent_color
	end
	border_timer:start()
end
----------------------------------------------------------

-- get a table with all lines from a file matching regexp (lain)
function helpers.lines_match(regexp, path)
	local lines = {}
	for line in io.lines(path) do
		if string.match(line, regexp) then
			lines[#lines + 1] = line
		end
	end
	return lines
end

return helpers
