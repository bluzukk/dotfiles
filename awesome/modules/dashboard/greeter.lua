local awful     = require("awful")
local beautiful = require("beautiful")
local gears     = require("gears")
local gfs       = require("gears.filesystem")
local naughty   = require("naughty")
local wibox     = require("wibox")
local dpi       = beautiful.xresources.apply_dpi

local util      = require("helpers.util")
local markup    = require("helpers.markup")


local USER_IMAGE =  gfs.get_configuration_dir() .. "assets/fallback/avatar.png"
if util.file_exists(AVATAR) then
    USER_IMAGE = AVATAR
else
    naughty.notify{title = "Avatar Missing"}
end

local USERNAME = "no username"
local HOSTNAME = "no hostname"
util.async("whoami", function (evil) USERNAME = evil end)
util.async("cat /etc/hostname", function (evil) HOSTNAME = evil end)

local font_name = beautiful.font_name
local greeter

local function create()
    local hour = os.date("%H")
    local minutes = os.date("%M")
    local day = os.date("%A")

    local user = {
        {
            markup =
                markup.fontfg(font_name .. " 18", beautiful.accent_color, "" .. USERNAME) ..
                markup.fontfg(font_name .. " 15", beautiful.accent_color_dark, " @" .. HOSTNAME),
            widget = wibox.widget.textbox,
        },
        widget = wibox.container.margin,
        margins = {
            left = dpi(-10),
            top = dpi(12),
        },
    }

    local image = {
        {
            image  = USER_IMAGE,
            resize = true,
            widget = wibox.widget.imagebox,
            shape = gears.shape.circle,
            forced_height = dpi(100),
        },
        widget = wibox.container.background,
        shape = gears.shape.circle
    }

    local clock = wibox.widget {
        {
            id = "clock",
            markup =
                markup.bold(markup.fontfg(font_name .. " 24", beautiful.accent_alt_color, markup.bold(day) .. "\n"))..
                markup.fontfg(font_name .. " 24", beautiful.main_color, markup.bold(hour .. ":" .. minutes)),
            align  = 'center',
            valign = 'center',
            widget = wibox.widget.textbox,

        },
        widget = wibox.container.margin,
        margins = {
            left = dpi(0),
            right = dpi(40),
            top = dpi(0)
        },
    }

    greeter = wibox.widget {
        {
            {
                {
                    layout = wibox.layout.align.horizontal,
                    image,
                    user,
                    clock,
                },
                widget = wibox.container.place,
                halign = "center",
                valign = "center",
                forced_height = dpi(133),
            },
            widget = wibox.container.background,
            bg = beautiful.bg_color_light,
            shape = gears.shape.rounded_rect
        },
        widget = wibox.container.margin,
        margins = {
            left = beautiful.dashboard_margin,
            right = beautiful.dashboard_margin,
            bottom = beautiful.dashboard_margin/6,
            top = beautiful.dashboard_margin/2,
        },
    }

    greeter.buttons = gears.table.join(
        greeter.buttons,
        awful.button({}, 1, function()
            awesome.emit_signal("dashboard::mouse1")
        end),
        awful.button({}, 3, function()
            awesome.emit_signal("dashboard::mouse3")
        end))

    return greeter
end

return {
    create = create
}
