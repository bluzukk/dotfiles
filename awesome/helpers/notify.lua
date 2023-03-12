-- Naive notification implementation I use from time to time
local awful     = require("awful")
local beautiful = require("beautiful")
local gears     = require("gears")
local wibox     = require("wibox")

local markup    = require("helpers.markup")

local TIMEOUT_DEFAULT = 2

local notification_widget = wibox.widget {
    {
        widget = wibox.widget.textbox,
        forced_height = 20,
    },
    {
        {
            id = 'title',
            font = beautiful.font_name .. ' 24',
            align = 'center',
            widget = wibox.widget.textbox,
            text = "some title"
        },
        widget = wibox.container.place,
        spacing = 20,
        spacing_widget = 20,
    },
    {
        {
            id = 'text',
            font = beautiful.font_name .. ' 18',
            text = "s0me text",
            widget = wibox.widget.textbox,
            bottom = 0,
        },
        align = 'left',
        widget = wibox.container.place,
        height = 80,
        width = 400,

    },
    {
        widget = wibox.widget.textbox,
        forced_height = 20,
    },
    spacing = 20,
    layout  = wibox.layout.fixed.vertical,
    update  = function(self, title, text)
        -- self:get_children_by_id('icon')[1]:set_image(ASSETS .. "dashboard-img.jpg")
        self:get_children_by_id('title')[1]:set_markup(markup(beautiful.accent_color, "  " .. title .. "  "))
        self:get_children_by_id('text')[1]:set_markup(markup(beautiful.main_color, text))
    end,
}

local notifications = awful.popup {
    widget       = notification_widget,
    border_color = beautiful.border_focus,
    border_width = 2 or beautiful.border_width,
    placement    = function(self) awful.placement.top(self, { offset = { y = 40 } }) end,
    shape        = beautiful.shape,
    ontop        = true,
    visible      = false,
    opacity      = beautiful.opacity,
}

local timer = gears.timer {
    timeout = TIMEOUT_DEFAULT,
}
timer:connect_signal("timeout", function()
        notifications.visible = false
        timer:stop()
    end
)

local function show(title, text, timeout, placement)
    if timeout then
        timer.timeout = timeout
    else
        timer.timeout = TIMEOUT_DEFAULT
    end

    if placement == "right" then
        notifications.placement = function(self) awful.placement.right(self, { offset = { y = 40 } }) end
    else
        notifications.placement = function(self) awful.placement.top(self, { offset = { y = 40 } }) end
    end

    notification_widget:update(title, text)
    notifications.visible = true
    timer:start()
end

local function hide()
    notifications.visible = false
    timer:stop()
end


return {
    show = show,
    hide = hide
}
