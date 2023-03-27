local beautiful  = require("beautiful")
local awful      = require("awful")
local wibox      = require("wibox")
local gfs        = require("gears.filesystem")
local gears      = require("gears")
local dpi        = beautiful.xresources.apply_dpi

local markup     = require("helpers.markup")

local ICONS_PATH = gfs.get_configuration_dir() .. "assets/powermenu/"

local function create_button(text, icon_name, cmd)
    local img      = gears.color.recolor_image(
        ICONS_PATH .. icon_name, beautiful.accent_alt_color)
    local button   = wibox.widget
        {
            {
                {
                    {
                        {
                            image         = img,
                            resize        = true,
                            widget        = wibox.widget.imagebox,
                            shape         = gears.shape.circle,
                            forced_height = dpi(48),
                        },
                        {
                            id = "text",
                            font = beautiful.font_name .. " 16",
                            markup = markup(beautiful.accent_color, " " .. text),
                            widget = wibox.widget.textbox,
                        },
                        layout = wibox.layout.fixed.horizontal,
                        forced_width = beautiful.dashboard_width,
                    },
                    widget = wibox.container.place,
                    halign = "center",
                    valign = "center",
                },
                widget  = wibox.container.margin,
                margins = {
                    left   = dpi(100),
                    right  = dpi(5),
                    bottom = dpi(5),
                    top    = dpi(10),
                },
            },
            forced_height = dpi(150),
            widget = wibox.container.background,
            bg     = beautiful.bg_color_light,
        }

    button.buttons = gears.table.join(
        awful.button({}, 1, function()
            awful.spawn(cmd)
        end)
    )

    button:connect_signal("button::press", function(c) c:set_bg(beautiful.accent_color) end)
    button:connect_signal("button::release", function(c) c:set_bg(beautiful.bg_color_light10) end)
    button:connect_signal("mouse::enter", function(c) c:set_bg(beautiful.bg_color_light10) end)
    button:connect_signal("mouse::leave", function(c) c:set_bg(beautiful.bg_color_light) end)
    return button
end

local powermenu_widget = wibox.widget {
    {
        {
            -- wibox.widget.textbox(""),
            create_button("Pwroff", "shutdown.svg", "poweroff"),
            create_button("Reb0ot", "reboot.svg", "reboot"),
            create_button("L0ck", "lock.svg", "lock"),
            layout = wibox.layout.flex.vertical,
            spacing = dpi(50)
        },
        align = 'center',
        valign = 'center',
        widget = wibox.container.place,
    },
    layout        = wibox.layout.flex.vertical,
    forced_height = dpi(800),
    forced_width  = dpi(1420),
}

local powermenu = awful.popup {
    widget        = powermenu_widget,
    border_color  = beautiful.border_focus,
    border_width  = 3 or beautiful.border_width,
    placement     = awful.placement.centered,
    shape         = beautiful.corners,
    ontop         = true,
    visible       = false,
    opacity       = beautiful.opacity,
}

local function toggle()
    if not powermenu.visible then
        powermenu.visible = true
    else
        powermenu.visible = false
    end
end

return {
    toggle = toggle
}
