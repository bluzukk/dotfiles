local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local dpi = beautiful.xresources.apply_dpi

local markup = require("helpers.markup")

local CMD_NIGHT_MODE_ON = [[ redshift -l 0:0 yy-t 4500:4500 -r ]]
local CMD_NIGHT_MODE_OFF = [[ killall redshift; redshift -x]]

local function update_buttons(c, is_on)
	if is_on then
		c:get_children_by_id("text")[1].markup = markup(beautiful.accent_alt_color, " On  ")
		-- c:set_bg(beautiful.bg_color_light10)
	else
		c:get_children_by_id("text")[1].markup = markup(beautiful.accent_color, " Off  ")
		-- c:set_bg(beautiful.bg_color_light)
	end
end

local function create_button(task, text_on, text_off, cmd_on, cmd_off)
	local button = wibox.widget({

		{
			{
				{
					resize = true,
					widget = wibox.widget.textbox,
					markup = markup(beautiful.accent_color, task),
					forced_height = dpi(32),
					forced_width = dpi(400),
				},
				{
					id = "text",
					resize = true,
					widget = wibox.widget.textbox,
					forced_height = dpi(32),
					forced_width = dpi(400),
				},
				layout = wibox.layout.fixed.vertical,
			},
			widget = wibox.container.margin,
			top = dpi(5),
			left = dpi(5),
			right = dpi(5),
			bottom = dpi(10),
		},
		widget = wibox.container.background,
		bg = beautiful.bg_color_light1,
		shape = gears.shape.rounded_rect,
		task = task,
		text_on = text_on,
		text_off = text_off,
		cmd_on = cmd_on,
		cmd_off = cmd_off,
		enabled = false,
	})
	button:connect_signal("button::press", function(c)
		c.enabled = not c.enabled
		update_buttons(c, c.enabled)
		if c.enabled then
			awful.spawn.with_shell(c.cmd_on)
		else
			awful.spawn.with_shell(c.cmd_off)
		end
	end)

	-- button:connect_signal("button::release", function(c)
	-- 	if c.enabled then
	-- 		c:set_bg(beautiful.accent_alt_color)
	-- 	else
	-- 		c:set_bg(beautiful.bg_color_light)
	-- 	end
	-- end)
	button:connect_signal("mouse::enter", function(c)
		-- if c.enabled then
		-- 	c:set_bg(beautiful.accent_alt_color)
		-- else
		-- 	c:set_bg(beautiful.bg_color_light10)
		-- end
		c:set_bg(beautiful.bg_color_light10)
	end)
	button:connect_signal("mouse::leave", function(c)
		-- if c.enabled then
		-- 	c:set_bg(beautiful.bg_color_light10)
		-- else
		-- 	c:set_bg(beautiful.accent_color)
		-- end
		c:set_bg(beautiful.bg_color_light1)
	end)

	update_buttons(button, false)

	return button
end

local bluelight_button = create_button(" Night Mode", "  ON", "  OFF", CMD_NIGHT_MODE_ON, CMD_NIGHT_MODE_OFF)

local function create()
	local apps = wibox.widget({
		{
			{
				{
					layout = wibox.layout.flex.horizontal,
					bluelight_button,
					kill_button,
				},
				widget = wibox.container.place,
				-- halign = "center",
				-- valign = "center",
				forced_height = dpi(300),
				forced_width = dpi(300),
			},
			widget = wibox.container.background,
			-- bg = beautiful.bg_color_light,
			shape = gears.shape.rounded_rect,
		},
		widget = wibox.container.margin,
		margins = {
			left = beautiful.dashboard_margin,
			right = beautiful.dashboard_margin,
			bottom = beautiful.dashboard_margin,
			-- top = beautiful.dashboard_margin/2,
		},
	})

	local links = wibox.widget({
		apps,
		-- browse,
		-- locations,
		layout = wibox.layout.align.vertical,
	})
	return links
end

return {
	create = create,
}
