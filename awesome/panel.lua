local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local dpi = require("beautiful").xresources.apply_dpi
local markup = require("helpers.markup")
local naughty = require("naughty")
local helpers = require("helpers.util")

local CMD_CPU  = [[ bash -c "ps -Ao pcpu,comm,pid --sort=-pcpu | head -n 30" ]]
local CMD_MEM  = [[ bash -c "ps -Ao pmem,comm,pid --sort=-pmem | head -n 30" ]]
local CMD_GPU  = [[ nvidia-smi  ]]
local CMD_NET  = [[ bash -c ". ~/.config/awesome/scripts/net-info" ]]
local CMD_BAT  = [[ acpi ]]
local CMD_DISK = [[ df --output=target,pcent,avail,used /home /tmp -h  ]]

local notification
local function notification_hide()
	if notification then
		naughty.destroy(notification)
	end
end

local function notification_show(str, bg_color)
	naughty.destroy(notification)
	notification = naughty.notify({
		font = beautiful.font_name .. " 15",
		fg = beautiful.text,
		bg = bg_color,
		title = "",
		text = str,
	})
end

local function createWidget(name, onclick_cmd)
	local container = wibox.widget({
		{
			{
				widget = wibox.widget.textbox,
				id = "text",
				text = "Error:" .. name,
				font = beautiful.font_name .. " 15",
			},
			widget = wibox.container.margin,
			margins = {
				left = dpi(10),
				right = dpi(10),
			},
			id = "margins",
		},
		widget = wibox.container.background,
		bg = beautiful.bg_color,
		onclick = onclick_cmd,
		name = name,
		bg_color = beautiful.bg_color,
		bg_color_highlight = beautiful.bg_color_light,
		update = function(self, color, content)
			self:get_children_by_id("text")[1].markup = markup(color, content)
		end,
		hide = function(self)
			self:get_children_by_id("text")[1].markup = ""
			self:get_children_by_id("margins")[1].margins = 0
		end,
	})

	container:connect_signal("mouse::enter", function(self)
		self.bg = self.bg_color_highlight
	end)
	container:connect_signal("mouse::leave", function(self)
		notification_hide()
		self.bg = self.bg_color
	end)
	container:connect_signal("button::press", function(self)
		awful.spawn.easy_async(self.onclick, function(evil)
			notification_show(evil, self.color_default)
		end)
	end)
	return container
end


local clock_widget = createWidget("Clock", "")
awful.widget.watch([[date +'%a %b %d, %R']], 10, function(_, stout)
	clock_widget:get_children_by_id("text")[1].markup =
		markup(beautiful.mauve, stout)
end)


local cpu_widget = createWidget("CPU", CMD_CPU)
awesome.connect_signal("evil::cpu", function(evil_cpu_util, evil_cpu_temp)
	if evil_cpu_temp > 65 then
		cpu_widget:update(beautiful.red, evil_cpu_util .. "% " .. evil_cpu_temp .. "°C")
	elseif evil_cpu_temp > 60 then
		cpu_widget:update(beautiful.peach, evil_cpu_util .. "% " .. evil_cpu_temp .. "°C")
	else
		cpu_widget:update(beautiful.text, evil_cpu_util .. "% " .. evil_cpu_temp .. "°C")
	end
end)


local update_widget = wibox.widget.textbox()
awesome.connect_signal("evil::update", function(evil)
	if evil == true then
    update_widget.visible = true
		update_widget:set_markup(markup(beautiful.red, "Update(s) Available"))
	else
		update_widget.visible = false
	end
end)


local gpu_widget = createWidget("GPU", CMD_GPU)
awesome.connect_signal("evil::gpu", function(evil_gpu_util, evil_gpu_temp)
	if evil_gpu_temp > 0 then
		if evil_gpu_temp > 65 then
			gpu_widget:update(beautiful.red, evil_gpu_util .. "% " .. evil_gpu_temp .. "°C")
		elseif evil_gpu_temp > 55 then
			gpu_widget:update(beautiful.peach, evil_gpu_util .. "% " .. evil_gpu_temp .. "°C")
		else
			gpu_widget:update(beautiful.text, evil_gpu_util .. "% " .. evil_gpu_temp .. "°C")
		end
		gpu_widget.visible = true
	else
		gpu_widget.visible = false
	end
end)

local ram_widget = createWidget("MEM", CMD_MEM)
awesome.connect_signal("evil::ram", function(evil)
	local color = beautiful.text
	local val = string.format("%.0f", evil)
	if evil > 25000 then
		color = beautiful.color_critical
  elseif evil > 15000 then
    color = beautiful.color_warn
  elseif evil > 10000 then
    color = beautiful.color_high
	end
	ram_widget:update(color, val .. "mb")
end)

local disk_widget = createWidget("FS", CMD_DISK)
awesome.connect_signal("evil::disk_free", function(evil)
	disk_widget:update(beautiful.text, evil .. "gb")
end)

local bat_widget = createWidget("BAT", CMD_BAT)
awesome.connect_signal("evil::bat", function(evil_bat_perc)
	if evil_bat_perc then
		if evil_bat_perc > 50 then
			bat_widget:update(beautiful.text, evil_bat_perc .. "%")
		elseif evil_bat_perc > 30 then
			bat_widget:update(beautiful.peach, evil_bat_perc .. "%")
		else
			bat_widget:update(beautiful.red, evil_bat_perc .. "%")
		end
	else
		bat_widget:hide()
	end
end)

local net_widget = createWidget("NET", CMD_NET)
awesome.connect_signal("evil::net_now", function(evil)
	if evil then
		evil = evil / 1024
		if evil > 10000 then
			net_widget:update(beautiful.red, string.format("%04.0f", evil) .. "kb/s")
		elseif evil > 1000 then
			net_widget:update(beautiful.peach, string.format("%04.0f", evil) .. "kb/s")
		else
			net_widget:update(beautiful.text, string.format("%04.0f", evil) .. "kb/s")
		end
	end
end)

local netw_widget = createWidget("NETWORK", CMD_NET)
awesome.connect_signal("evil::net_ip4", function(evil)
	if evil then
			netw_widget:update(beautiful.text, evil)
	end
end)


--- MAIL ---
local CMD_MAIL_IMS = beautiful.terminal .. " -e neomutt -F ~/Sync/Rice/_private/mail-muttrcIMS"
local CMD_MAIL_MAIN = beautiful.terminal .. " -e neomutt -F ~/Sync/Rice/_private/mail-muttrcUni"

local mail_main = wibox.widget.textbox()
mail_main.forced_height = dpi(48)
mail_main.visible = false
mail_main:connect_signal("button::press", function()
	awful.spawn(CMD_MAIL_MAIN)
	mail_main.visible = false
end)
awesome.connect_signal("evil::mail_main", function(evil)
	if evil ~= "nop" then
		mail_main:set_markup(markup(beautiful.red, evil))
		mail_main.visible = true
	else
		mail_main.visible = false
	end
end)

local mail_ims = wibox.widget.textbox()
mail_ims.forced_height = dpi(48)
mail_ims.visible = false
mail_ims:connect_signal("button::press", function()
	awful.spawn(CMD_MAIL_IMS)
	mail_ims.visible = false
end)
awesome.connect_signal("evil::mail_ims", function(evil)
	if evil ~= "nop" then
		mail_ims:set_markup(markup(beautiful.red, evil))
		mail_ims.visible = true
	else
		mail_ims.visible = false
	end
end)

--- WEATHER ---
local weather_widget = createWidget("WEATHER", "")
awesome.connect_signal("evil::weather_now", function(evil)
	weather_widget:update(beautiful.accent_color, string.format("%+.0f", evil[2]) .. string.format("°C (%s)", evil[3]))
end)

local separator = wibox.widget.textbox(" ")

screen.connect_signal("request::desktop_decoration", function(s)
	-- Each screen has its own tag table.
	awful.tag({ " 1 ", " 2 ", " 3 "}, s, awful.layout.suit.tile)

	s.mytaglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = {
			awful.button({}, 1, function(t)
				t:view_only()
			end),
			awful.button({ beautiful.modkey }, 1, function(t)
				if client.focus then
					client.focus:move_to_tag(t)
				end
			end),
			awful.button({}, 3, awful.tag.viewtoggle),
			awful.button({ beautiful.modkey }, 3, function(t)
				if client.focus then
					client.focus:toggle_tag(t)
				end
			end),
			awful.button({}, 4, function(t)
				awful.tag.viewprev(t.screen)
			end),
			awful.button({}, 5, function(t)
				awful.tag.viewnext(t.screen)
			end),
		},
	})

	-- Create the wibox
	s.mywibox = awful.wibar({
		position = "top",
		screen = s,
		height = 32,
		border_width = 0,
		widget = {
			layout = wibox.layout.align.horizontal,
      expand = "none",
			{ -- Left widgets
				layout = wibox.layout.fixed.horizontal,
				s.mytaglist,
				separator,
				mail_ims,
				mail_main,
        -- netw_widget,
			},
      separator,
			{ -- Right widgets
				layout = wibox.layout.fixed.horizontal,
        update_widget,
				cpu_widget,
				gpu_widget,
				ram_widget,
				disk_widget,
        net_widget,
				-- weather_widget,
				bat_widget,
				clock_widget,
				wibox.widget.systray(),
			},
		},
	})
end)
