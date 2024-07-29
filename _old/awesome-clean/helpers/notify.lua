local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local xrdb = xresources.get_current_theme()
local dpi = xresources.apply_dpi
local markup = require("helpers.markup")

-- local TIMEOUT_DEFAULT     = 2

local notification_widget = wibox.widget({
	{
		-- {
		--   {
		--     id = 'title',
		--     font = beautiful.font_name .. ' 20',
		--     align = 'center',
		--     widget = wibox.widget.textbox,
		--     text = "some title"
		--   },
		--   widget = wibox.container.place,
		--   spacing = dpi(20),
		--   spacing_widget = dpi(20),
		-- },
		{
			id = "text",
			font = beautiful.font_name .. " 16",
			text = "s0me text",
			widget = wibox.widget.textbox,
		},
		widget = wibox.container.margin,
		margins = {
			left = dpi(20),
			right = dpi(20),
			bottom = dpi(20),
			top = dpi(20),
		},
	},
	spacing = dpi(20),
	layout = wibox.layout.fixed.vertical,
	update = function(self, title, text)
		self:get_children_by_id("text")[1]:set_markup(markup(beautiful.main_color, text))
	end,
})

local notifications = awful.popup({
	widget = notification_widget,
	-- border_color = beautiful.border_focus,
	border_width = dpi(0),
	placement = function(self)
		awful.placement.top_right(self, { offset = { y = dpi(70), x = dpi(-30) } })
	end,
	shape = beautiful.shape,
	ontop = true,
	visible = false,
	opacity = beautiful.opacity,
})

local function show(title, text)
	-- if timeout then
	--   timer.timeout = timeout
	-- else
	--   timer.timeout = TIMEOUT_DEFAULT
	-- end

	notification_widget:update(title, text)
	notifications.visible = true
	-- timer:start()
end

local function hide()
	notifications.visible = false
	-- timer:stop()
end

return {
	show = show,
	hide = hide,
}
