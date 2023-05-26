local awful     = require("awful")
local beautiful = require("beautiful")
local gears     = require("gears")
local wibox     = require("wibox")

local spr = wibox.widget.textbox(" ")

local tasklist_buttons = gears.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
                "request::activate",
                "tasklist",
                {raise = true}
            )
        end
    end)
)

local function create(s)
    return awful.widget.tasklist {
        screen   = s,
        filter   = awful.widget.tasklist.filter.minimizedcurrenttags,
        buttons  = tasklist_buttons,
        style    = {
            shape  = gears.shape.rect,
        },
        layout   = {
            spacing = 15,
            spacing_widget = {
                {
                    forced_width = 10,
                    widget       = wibox.widget.separator,
                },
                opacity = 0,
                widget = wibox.container.place,
            },
            layout  = wibox.layout.flex.horizontal
        },
        widget_template = {
            {
                spr,
                {
                    id     = 'text_role',
                    widget = wibox.widget.textbox,
                    align  = "center"
                },
                spr,
                forced_width = 300,
                layout = wibox.layout.flex.horizontal
            },
            id     = 'background_role',
            widget = wibox.container.background,
        },
    }
end

return {
    create = create
}
