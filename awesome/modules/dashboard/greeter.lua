local awful     = require("awful")
local beautiful = require("beautiful")
local gears     = require("gears")
local gfs       = require("gears.filesystem")
local naughty   = require("naughty")
local wibox     = require("wibox")
local dpi       = beautiful.xresources.apply_dpi

local util      = require("helpers.util")
local markup    = require("helpers.markup")


local USER_IMAGE = gfs.get_configuration_dir() .. "assets/fallback/avatar.png"
if util.file_exists(AVATAR) then
    USER_IMAGE = AVATAR
else
    naughty.notify { title = "Avatar Missing" }
end
local uwu = wibox.widget.textbox()

local uwuww                = "" ..
    ' ⣐⢕⢕⢕⢕⢕⢕⢕⢕⠅⢗⢕⢕⢕⢕⢕⢕⢕⠕⠕⢕⢕⢕⢕⢕⢕⢕⢕⢕\n' ..
    '⢐⢕⢕⢕⢕⢕⣕⢕⢕⠕⠁⢕⢕⢕⢕⢕⢕⢕⢕⠅⡄⢕⢕⢕⢕⢕⢕⢕⢕⢕\n' ..
    '⢕⢕⢕⢕⢕⠅⢗⢕⠕⣠⠄⣗⢕⢕⠕⢕⢕⢕⠕⢠⣿⠐⢕⢕⢕⠑⢕⢕⠵⢕\n' ..
    '⢕⢕⢕⢕⠁⢜⠕⢁⣴⣿⡇⢓⢕⢵⢐⢕⢕⠕⢁⣾⢿⣧⠑⢕⢕⠄⢑⢕⠅⢕\n' ..
    '⢕⢕⠵⢁⠔⢁⣤⣤⣶⣶⣶⡐⣕⢽⠐⢕⠕⣡⣾⣶⣶⣶⣤⡁⢓⢕⠄⢑⢅⢑\n' ..
    '⠍⣧⠄⣶⣾⣿⣿⣿⣿⣿⣿⣷⣔⢕⢄⢡⣾⣿⣿⣿⣿⣿⣿⣿⣦⡑⢕⢤⠱⢐\n' ..
    '⢠⢕⠅⣾⣿⠋⢿⣿⣿⣿⠉⣿⣿⣷⣦⣶⣽⣿⣿⠈⣿⣿⣿⣿⠏⢹⣷⣷⡅⢐\n' ..
    '⣔⢕⢥⢻⣿⡀⠈⠛⠛⠁⢠⣿⣿⣿⣿⣿⣿⣿⣿⡀⠈⠛⠛⠁⠄⣼⣿⣿⡇⢔\n' ..
    '⢕⢕⢽⢸⢟⢟⢖⢖⢤⣶⡟⢻⣿⡿⠻⣿⣿⡟⢀⣿⣦⢤⢤⢔⢞⢿⢿⣿⠁⢕\n' ..
    '⢕⢕⠅⣐⢕⢕⢕⢕⢕⣿⣿⡄⠛⢀⣦⠈⠛⢁⣼⣿⢗⢕⢕⢕⢕⢕⢕⡏⣘⢕\n' ..
    '⢕⢕⠅⢓⣕⣕⣕⣕⣵⣿⣿⣿⣾⣿⣿⣿⣿⣿⣿⣿⣷⣕⢕⢕⢕⢕⡵⢀⢕⢕\n' ..
    '⢑⢕⠃⡈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢃⢕⢕⢕\n' ..
    '⣆⢕⠄⢱⣄⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⢁⢕⢕⠕⢁\n' ..
    '⣿⣦⡀⣿⣿⣷⣶⣬⣍⣛⣛⣛⡛⠿⠿⠿⠛⠛⢛⣛⣉⣭⣤⣂⢜⠕⢑⣡⣴⣿\n'

uwu.markup  =
    markup.fontfg(beautiful.font_name .. " 7", beautiful.accent_color, "\n") ..
    markup.fontfg(beautiful.font_name .. " 7", beautiful.accent_color, uwuww)


local USERNAME = "no username"
local HOSTNAME = "no hostname"
util.async("whoami", function(evil) USERNAME = evil end)
util.async("cat /etc/hostname", function(evil) HOSTNAME = evil end)

local font_name = beautiful.font_name
local greeter

-- local textclock = awful.widget.watch("date +'  %R:%S'", 1, function(widget, stdout)
--     widget:set_markup(
--         markup.fontfg(beautiful.font_name .. " 32", beautiful.accent_alt_color, markup.bold(stdout)))
-- end)

local function create()
    local hour = os.date("%H")
    local minutes = os.date("%M")
    local day = os.date("%A")

    local user = {
        {
            markup =
                markup.fontfg(font_name .. " 16", beautiful.accent_color, "" .. USERNAME) ..
                markup.fontfg(font_name .. " 14", beautiful.accent_color_dark, " @" .. HOSTNAME),
            widget = wibox.widget.textbox,
        },
        widget = wibox.container.margin,
        margins = {
            left = dpi(10),
            right = dpi(20),
            top = dpi(12),
        },
    }

    local image = {
            uwu,
        widget = wibox.container.margin,
        margins = {
            left = dpi(20),
            top = dpi(10),
            bottom = dpi(10)
        },
    }

    local clock = wibox.widget {
        {
            id     = "clock",
            markup =
                markup.bold(markup.fontfg(font_name .. " 24", beautiful.accent_color,
                    "     " .. markup.bold(day))),
            align  = 'center',
            valign = 'center',
            widget = wibox.widget.textbox,
        },
        widget = wibox.container.margin,
        margins = {
            left = dpi(0),
            right = dpi(00),
            top = dpi(10)
        },
    }

    greeter = wibox.widget {
        {
            {
                {
                    layout = wibox.layout.fixed.horizontal,
                    image,
                    user,
                    {
                        layout = wibox.layout.align.vertical,
                        -- clock,
                        textclock,
                    },
                },
                widget = wibox.container.place,
                halign = "center",
                valign = "center",
                forced_height = dpi(200),
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
