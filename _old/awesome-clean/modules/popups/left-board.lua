local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local dpi = beautiful.xresources.apply_dpi
local gears = require("gears")
local markup = require("helpers.markup")

-- Dashboard Modules
local greeter = require("modules.popups.widgets.greeter")
local weather = require("modules.popups.widgets.weather")
local buttons = require("modules.popups.widgets.buttons").create()

local weather_widget
if weather ~= -1 then
	weather_widget = weather()
end

local is_sticky = false
local board = awful.popup({
	widget = {},
	border_color = beautiful.border_focus,
	border_width = 0 or beautiful.border_width,
	placement = function(c)
		awful.placement.top(c, { margins = { top = dpi(100) } })
	end,
	shape = beautiful.corners,
	ontop = true,
	visible = false,
	opacity = 1,
	bg = beautiful.bg_color,
})

local function createContainer(widget)
	return wibox.widget({
		{
			{
				widget,
				widget = wibox.container.place,
				halign = "center",
				valign = "center",
				forced_height = dpi(100),
				-- forced_width = dpi(450),
			},
			widget = wibox.container.background,
			bg = beautiful.bg_color_light,
			shape = gears.shape.rounded_rect,
		},
		widget = wibox.container.margin,
		margins = {
			left = beautiful.dashboard_margin,
			right = beautiful.dashboard_margin,
			bottom = beautiful.dashboard_margin,
			top = beautiful.dashboard_margin,
		},
	})
end

local function update()
	local greet = greeter.create()
	board.widget = wibox.widget({
		{
			{
				{
					greet,
					weather_widget,
					buttons,
					layout = wibox.layout.fixed.vertical,
				},
				layout = wibox.layout.fixed.horizontal,
			},
			layout = wibox.layout.fixed.horizontal,
			forced_width = dpi(450),
			forced_height = dpi(400),
		},
		widget = wibox.container.place,
	})
end

-- First time setup
update()

local function show()
	update()
	board.visible = true
	board.screen = awful.screen.focused()
end

local function hide()
	board.visible = false
end

local function toggle()
	if board.visible then
		hide()
	else
		show()
	end
end

-- Manage tabs and redraw callbacks
awesome.connect_signal("dashboard::redraw_needed", function()
	update()
end)

awesome.connect_signal("dashboard::mouse3", function()
	hide()
end)

local function isVisible()
	return board.visible
end

local function isSticky()
	return is_sticky
end

local function toggleSticky()
	is_sticky = not is_sticky
end

return {
	toggle = toggle,
	show = show,
	hide = hide,
	isVisible = isVisible,
	isSticky = isSticky,
	toggleSticky = toggleSticky,
}
