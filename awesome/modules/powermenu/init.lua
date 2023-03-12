
local beautiful = require("beautiful")
local awful     = require("awful")
local wibox     = require("wibox")
local gfs       = require("gears.filesystem")
local gears     = require("gears")

local markup    = require("helpers.markup")
local notify    = require("helpers.notify")

local powermenu_widget = wibox.widget {

    {
        {
            id = 'icon',
            image = AVATAR,
            resize = true,
            forced_width = 470,
            forced_height = 350,
            widget = wibox.widget.imagebox,
            shape = gears.shape.circle,
            opacity = 0.2,
        },
        align = 'center',
        widget = wibox.container.place,
        forced_height = 120,
        forced_width = 120,
    },
    layout = wibox.layout.fixed.vertical,

    update = function(self)
        -- self:get_children_by_id('greeter')[1]:set_markup("Hi " .. markup(beautiful.accent_color, username) .. " :)")
    end,
}

local powermenu = awful.popup {
    widget       = powermenu_widget,
    border_color = beautiful.border_focus,
    border_width = 0 or beautiful.border_width,
    placement    = awful.placement.centered,
    shape        = beautiful.corners,
    ontop        = true,
    visible      = false,
    forced_height       = 1000,
    opacity      = beautiful.opacity,
}

local function toggle()
    if not powermenu.visible then
        powermenu_widget:update()
        powermenu.visible = true
    else
        powermenu.visible = false
    end
end

return {
    toggle = toggle
}
