local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local dpi = require("beautiful").xresources.apply_dpi

local color_default = beautiful.bg_color
local color_hover = beautiful.bg_color_light5
if beautiful.transparent_bar then
	color_default = beautiful.bg_color .. "0"
	color_hover = beautiful.bg_color
end

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
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
		awful.tag.viewnext(t.screen)
	end),
	awful.button({}, 5, function(t)
		awful.tag.viewprev(t.screen)
	end)
)

local function create_boxes(s)
	-- Helper function that updates a taglist item
	local update_taglist_blocks = function(item, tag, _)
		if tag.selected then
			item.bg = beautiful.accent_color
			item.opacity = 1
		elseif tag.urgent then
			item.bg = beautiful.color_critical
			item.opacity = 1
		elseif #tag:clients() > 0 then
			item.bg = beautiful.accent_color
			item.opacity = 0.42
		else
			item.opacity = 0
		end
	end

	-- Create a taglist for every screen
	s.mytaglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = taglist_buttons,
		layout = {
			spacing = 10,
			spacing_widget = {
				color = "#0000000",
				shape = gears.shape.circle,
				widget = wibox.widget.separator,
			},
			layout = wibox.layout.flex.horizontal,
		},
		widget_template = {
			widget = wibox.container.background,
			create_callback = function(self, tag, index, _)
				update_taglist_blocks(self, tag, index)
			end,
			update_callback = function(self, tag, index, _)
				update_taglist_blocks(self, tag, index)
			end,
		},
	})

	-- Create the taglist wibox
	s.taglist_box = awful.wibar({
		screen = s,
		visible = true,
		ontop = false,
		type = "dock",
		height = dpi(10),
		position = "top",
		-- width = dpi(800),
		bg = "#0000000",
		opacity = 0.50,
		shape = gears.shape.rect,
	})
	s.taglist_box:setup({
		widget = s.mytaglist,
	})

	return s.taglist_box
end

local function update_taglist(widget, tag, _, _)
	widget:connect_signal("mouse::enter", function()
		widget.bg = color_hover
	end)
	widget:connect_signal("mouse::leave", function()
		widget.bg = color_default
	end)
	if tag == awful.tag.selected() then
		-- color for currently active tag
		widget:get_children_by_id("tag_bg")[1].bg = beautiful.accent_color
		widget:get_children_by_id("tag_element")[1].forced_width = dpi(20)
		if #tag:clients() == 0 and dashboard.isSticky() then
			dashboard.show()
		else
			dashboard.hide()
		end
	else
		-- if #tag:clients() > 0 then
		--     widget:get_children_by_id('tag_bg')[1].bg = beautiful.main_color
		-- else
		--     -- Hide tags which do not have clients
		--     widget:get_children_by_id('tag_element')[1].forced_width = dpi(20)
		--     widget:get_children_by_id('tag_bg')[1].bg = beautiful.bg_color
		-- end

		-- color for other tags
		widget:get_children_by_id("tag_bg")[1].bg = beautiful.main_color
		widget:get_children_by_id("tag_element")[1].forced_width = dpi(20)
	end
end

-- Create a taglist for every screen
local function create(s)
	return awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,

		widget_template = {
			{
				{
					{
						id = "tag_element",
						widget = wibox.widget.textbox,
					},
					{
						id = "tag_name",
						widget = wibox.widget.textbox,
					},
					id = "tag_bg",
					shape = beautiful.corners,
					widget = wibox.container.background,
				},
				left = dpi(15),
				right = dpi(15),
				top = dpi(10),
				bottom = dpi(10),
				widget = wibox.container.margin,
			},
			id = "background_role",
			widget = wibox.container.background,
			bg = "000000",
			update_callback = update_taglist,
			create_callback = update_taglist,
		},
		buttons = taglist_buttons,
	})
end

for s in screen do
	create(s)
	create_boxes(s)
end
return {
	create = create,
	create_boxes = create_boxes,
}
