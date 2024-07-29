local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local dpi = beautiful.xresources.apply_dpi
local util = require("helpers.util")
local markup = require("helpers.markup")
local noty = require("naughty")

local CMD_GET_VOL = [[ bash -c ".config/awesome/scripts/volume" ]]
local CMD_GET_MIC = [[ bash -c ".config/awesome/scripts/microphone"]]

local volume_popup = awful.popup({
	widget = {},
	placement = function(c)
		awful.placement.top_right(c, { margins = { top = 32 } })
	end,
	ontop = true,
	visible = false,
})

local volume_widget = wibox.widget({
	{
		{
			id = "text",
			widget = wibox.widget.textbox,
			font = beautiful.font_name .. " 32",
			color = beautiful.accent_color,
		},
		-- {
		-- 	id = "volume_bar",
		-- 	max_value = 100,
		-- 	widget = wibox.widget.progressbar,
		-- 	forced_height = dpi(16),
		-- 	background_color = beautiful.bg_color,
		-- 	color = beautiful.accent_color .. "33",
		-- },
		layout = wibox.layout.fixed.vertical,
	},
	forced_height = dpi(100),
	forced_width = dpi(300),
	layout = wibox.layout.fixed.vertical,
	update = function(self)
		util.async(CMD_GET_VOL, function(volume)
			local vol = tonumber(volume:sub(1, #volume - 2))
			-- if vol == 100 then
			-- 	self:get_children_by_id("volume_bar")[1].color = beautiful.red
			-- else
			-- 	self:get_children_by_id("volume_bar")[1].color = beautiful.mauve
			-- end
			-- self:get_children_by_id("volume_bar")[1].value = vol
			self:get_children_by_id("text")[1].markup = markup(beautiful.mauve, "VOLUME: " .. vol .. "%")
		end)
	end,
})

local mic_widget = wibox.widget({
	{
		{
			id = "text_mic",
			widget = wibox.widget.textbox,
			font = beautiful.font_name .. " 32",
			color = beautiful.accent_color,
		},
		-- {
		-- 	id = "mic_bar",
		-- 	max_value = 100,
		-- 	widget = wibox.widget.progressbar,
		-- 	forced_height = dpi(16),
		-- 	background_color = beautiful.bg_color,
		-- 	color = beautiful.accent_color .. "33",
		-- },
		layout = wibox.layout.fixed.vertical,
	},
	forced_height = dpi(100),
	forced_width = dpi(300),
	layout = wibox.layout.fixed.vertical,
	update = function(self)
		util.async(CMD_GET_MIC, function(volume)
			local vol = tonumber(volume:sub(1, #volume - 2))
			self:get_children_by_id("text_mic")[1].markup = markup(beautiful.mauve, "MIC VOL: " .. vol .. "%")
		end)
	end,
})

awesome.connect_signal("volume::redraw_needed", function()
	volume_widget:update()
	volume_widget.visible = true
	mic_widget.visible = false
	VOLUME.popup()
end)
awesome.connect_signal("microphone::redraw_needed", function()
	mic_widget:update()
	volume_widget.visible = false
	mic_widget.visible = true
	VOLUME.popup()
end)

volume_popup.widget = wibox.widget({
	widget = wibox.container.place,
	layout = wibox.layout.stack,
	forced_height = dpi(40),
	volume_widget,
	mic_widget,
})

-- Show / Hide / Popup Logic
local popup_timer = gears.timer({
	timeout = 0.67,
})

local function popup()
	volume_popup.visible = true
	volume_popup.screen = awful.screen.focused()
	popup_timer:stop()
	popup_timer:start()
end
popup_timer:connect_signal("timeout", function()
	volume_popup.visible = false
	popup_timer:stop()
end)

return {
	popup = popup,
}
