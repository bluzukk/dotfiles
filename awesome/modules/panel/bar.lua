local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local dpi = require("beautiful").xresources.apply_dpi
local markup = require("helpers.markup")
local naughty = require("naughty")

local CMD_PROC_CPU = [[ bash -c "ps -Ao pcpu,comm,pid --sort=-pcpu | head -n 30" ]]
local CMD_PROC_MEM = [[ bash -c "ps -Ao pmem,comm,pid --sort=-pmem | head -n 30" ]]
local CMD_GPU = [[ nvidia-smi  ]]
local CMD_NET = [[ bash -c ". ~/.config/awesome/scripts/net-info" ]]
local CMD_BAT = [[ acpi  ]]
local CMD_FILE_SYSTEM = [[ df --output=target,pcent,avail,used / /home /tmp /run -h  ]]

awful.layout.layouts = {
	awful.layout.suit.tile.right,
	awful.layout.suit.tile.right,
	awful.layout.suit.tile.right,
}

local color_default = beautiful.bg_color
local color_hover = beautiful.bg_color_light

local notification
local function notification_hide()
	if notification then
		naughty.destroy(notification)
	end
end

local function notification_show(str, bg_color)
	naughty.destroy(notification)
	notification = naughty.notify({
		font = beautiful.font_name .. " 16",
		fg = beautiful.main_color,
		bg = bg_color,
		title = "",
		text = str,
	})
end

local function createWidget(title, onclick_cmd, _color_default, color_accent, font, is_elemental)
	local container = wibox.widget({
		{
			{
				widget = wibox.widget.textbox,
				id = "text",
				text = "Error:" .. title,
				font = font,
			},
			widget = wibox.container.margin,
			margins = {
				left = dpi(16),
				right = dpi(16),
			},
			id = "margins",
		},
		widget = wibox.container.background,
		bg = color_default,
		-- shape         = gears.shape.powerline,
		onclick = onclick_cmd,
		title = title,
		color_default = _color_default,
		color_accent = color_accent,
		forced_height = dpi(48),
		update = function(self, color, content)
			self:get_children_by_id("text")[1].markup = markup(color, title)
				.. ""
				.. markup(beautiful.main_color, content)
		end,
		hide = function(self)
			self:get_children_by_id("text")[1].markup = ""
			self:get_children_by_id("margins")[1].margins = 0
		end,
	})
	container:connect_signal("mouse::enter", function(self)
		self.bg = self.color_accent
	end)
	container:connect_signal("mouse::leave", function(self)
		notification_hide()
		self.bg = self.color_default
	end)

	container:connect_signal("button::press", function(self)
		if is_elemental then
			self.onclick:toggle()
		else
			awful.spawn.easy_async(self.onclick, function(evil)
				notification_show(evil, self.color_default)
			end)
		end
	end)
	return container
end

local function set_wallpaper(s)
	-- Wallpaper
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		-- If wallpaper is a function, call it with the screen
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
	end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local weather_widget = createWidget("", CMD_WEATHER, color_default, color_hover, beautiful.font)
awesome.connect_signal("evil::weather", function(evil)
	local temp = string.format("%.0f", evil.temp)
	weather_widget:update(
		beautiful.accent_color,
		temp .. "°C " .. beautiful.uwu_map[evil.weather[1].description] .. ""
	)
end)
local calendar = awful.widget.calendar_popup.month({
	font = beautiful.font,
	spacing = 2,
	week_numbers = true,
	start_sunday = true,
	position = "tc",
	screen = awful.screen.focused(),
})
local clock_widget = createWidget("", calendar, color_default, color_hover, beautiful.font, true)
awful.widget.watch("date +'%R'", 1, function(_, stdout)
	local day = os.date("%A")
	local day_map = {
		["Monday"] = "Mowonday",
		["Tuesday"] = "Tuwesday",
		["Wednesday"] = "Wudnesday",
		["Thursday"] = "Thuwsday",
		["Friday"] = "Fiwday",
		["Saturday"] = "Satuwday",
		["Sunday"] = "Suwnday",
	}
	clock_widget:get_children_by_id("text")[1].markup =
		markup(beautiful.main_color, day_map[day] .. ", " .. stdout:gsub("\n", ""))
	-- markup(beautiful.main_color, stdout:gsub("\n", ""))
end)

-- calendar:attach(clock_widget, "tc")

local cpu_widget = createWidget("CPU ", CMD_PROC_CPU, color_default, color_hover, beautiful.font)
awesome.connect_signal("evil::cpu", function(evil_cpu_util, evil_cpu_temp)
	local color = beautiful.main_color
	if evil_cpu_temp > 50 then
		color = beautiful.color_critical
	end
	cpu_widget:update(color, evil_cpu_util .. "% " .. evil_cpu_temp .. "°C")
end)

local gpu_widget = createWidget("GPU ", CMD_GPU, color_default, color_hover, beautiful.font)
awesome.connect_signal("evil::gpu", function(evil_gpu_util, evil_gpu_temp)
	local color = beautiful.main_color
	if evil_gpu_temp > 50 then
		color = beautiful.color_critical
		gpu_widget.visible = true
	end
	if evil_gpu_temp > 0 then
		gpu_widget:update(color, evil_gpu_util .. "% " .. evil_gpu_temp .. "°C")
		gpu_widget.visible = true
	else
		gpu_widget.visible = false
	end
end)

local ram_widget = createWidget("MEM ", CMD_PROC_MEM, color_default, color_hover, beautiful.font)
awesome.connect_signal("evil::ram", function(evil)
	local color = beautiful.main_color
	if evil > 25000 then
		color = beautiful.color_critical
	end
	local val = string.format("%.0f", evil)
	ram_widget:update(color, val .. "mb")
end)

local disk_widget = createWidget("FS ", CMD_FILE_SYSTEM, color_default, color_hover, beautiful.font)
awesome.connect_signal("evil::disk_free", function(evil)
	disk_widget:update(beautiful.main_color, evil .. "gb")
end)

local bat_widget = createWidget("BAT ", CMD_BAT, color_default, color_hover, beautiful.font)
awesome.connect_signal("evil::bat", function(evil_bat_perc)
	local color = beautiful.main_color
	if evil_bat_perc then
		if evil_bat_perc < 30 then
			color = beautiful.color_critical
		end
		bat_widget:update(color, evil_bat_perc .. "%")
	else
		bat_widget:hide()
	end
end)

local net_widget = createWidget("NET ", CMD_NET, color_default, color_hover, beautiful.font)
awesome.connect_signal("evil::net_now", function(evil)
	if evil then
		evil = string.format("%04.0f", evil / 1024)
		net_widget:update(beautiful.main_color, evil .. "kb/s")
	end
end)

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
		notification_show("New Mail", beautiful.bg_color)
		mail_main:set_markup(markup(beautiful.accent_color, evil))
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
		mail_ims:set_markup(markup(beautiful.accent_color, evil))
		mail_ims.visible = true
	else
		mail_ims.visible = false
	end
end)

screen.connect_signal("request::desktop_decoration", function(s)
	-- Each screen has its own tag table.
	awful.tag({ " ", " ", " " }, s, awful.layout.layouts[1])

	-- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt()

	if s == screen[1] then
		s.mywibox = awful.wibar({
			position = "top",
			screen = s,
			height = dpi(42),
			widget = {
				layout = wibox.layout.align.horizontal,
				expand = "none",
				{ -- Left widgets
					layout = wibox.layout.fixed.horizontal,
					-- expand = "outside",
					-- clock_widget,
					weather_widget,
					mail_main,
					mail_ims,
				},
				clock_widget,
				-- s.mytasklist, -- Middle widget
				{ -- Right widgets
					cpu_widget,
					gpu_widget,
					ram_widget,
					disk_widget,
					bat_widget,
					net_widget,
					aling = "right",
					layout = wibox.layout.fixed.horizontal,
					wibox.widget.systray(),
				},
			},
		})
	else
		s.mywibox = awful.wibar({
			position = "top",
			screen = s,
			widget = {
				layout = wibox.layout.align.horizontal,
				expand = "none",
				{ -- Left widgets
					layout = wibox.layout.fixed.horizontal,
					-- expand = "outside",
					-- clock_widget,
				},
				clock_widget,
				-- s.mytasklist, -- Middle widget
				{ -- Right widgets
					aling = "right",
					layout = wibox.layout.fixed.horizontal,
					wibox.widget.systray(),
				},
			},
		})
	end
end)
