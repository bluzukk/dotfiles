local awful     = require("awful")
local beautiful = require("beautiful")
local gears     = require("gears")
local wibox     = require("wibox")
local dpi       = beautiful.xresources.apply_dpi

local markup    = require("helpers.markup")


local font_name = beautiful.font_name
local date

local function create()
    local day = os.date("%A")

    local clock = wibox.widget {
        {
            id     = "clock",
            markup =
                markup.bold(markup.fontfg(font_name .. " 20", beautiful.accent_alt_color,
                "     " .. markup.bold(day) .. "\n")),
            align  = 'center',
            valign = 'center',
            widget = wibox.widget.textbox,
        },
        widget = wibox.container.margin,
        margins = {
            left = dpi(0),
            right = dpi(20),
            top = dpi(0)
        },
    }

    local textclock = awful.widget.watch("date +'%R:%S'", 1, function(widget, stdout)
	    widget:set_markup(
            markup.fontfg(beautiful.font_name .. " 40", beautiful.accent_alt_color, markup.bold(stdout)))
        end)
    date = wibox.widget {
        {
            {
                {
                    layout = wibox.layout.fixed.horizontal,
                    textclock,
                    clock,
                },
                widget = wibox.container.place,
                halign = "center",
                valign = "center",
                forced_height = dpi(100),
                forced_width = dpi(450),
            },
            widget = wibox.container.background,
            bg = beautiful.bg_color_light,
            shape = gears.shape.rounded_rect
        },
        widget = wibox.container.margin,
        margins = {
            left = beautiful.dashboard_margin,
            right = beautiful.dashboard_margin,
            -- bottom = beautiful.dashboard_margin,
            top = beautiful.dashboard_margin,
        },
    }

    return date
end

return {
    create = create
}
