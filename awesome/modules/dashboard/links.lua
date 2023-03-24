local awful      = require("awful")
local beautiful  = require("beautiful")
local gears      = require("gears")
local gfs        = require("gears.filesystem")
-- local naughty   = require("naughty")
local wibox      = require("wibox")
local dpi        = beautiful.xresources.apply_dpi

local markup     = require("helpers.markup")

local CMD_GH     = [[ librewolf github.com/bluzukk ]]
local CMD_PWROFF = [[ bash -c "VULKAN_DEVICE_INDEX=1 WINEPREFIX=~/Games/.wow wine ~/Games/WoW/ClassicWoW/_classic_/WowClassic.exe" ]]
local CMD_LOCK   = [[ st ]]

local ICONS_PATH = gfs.get_configuration_dir() .. "assets/powermenu/"


local function create_button(text, icon_name)
    local img = gears.color.recolor_image(
        ICONS_PATH .. icon_name, beautiful.accent_alt_color)
    local button = wibox.widget
        {
            {
                {
                    wibox.widget.textbox(" "),
                    {
                        id            = "image",
                        image         = img,
                        resize        = true,
                        widget        = wibox.widget.imagebox,
                        shape         = gears.shape.circle,
                        forced_height = dpi(32),
                    },
                    {
                        id = "text",
                        font = beautiful.font_name .. " 14",
                        markup = markup(beautiful.accent_color, " " .. text),
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                    forced_width = beautiful.dashboard_width,
                },
                widget = wibox.container.place,
                halign = "center",
                valign = "center",
                forced_height = dpi(42),
            },
            widget = wibox.container.background,
            bg     = beautiful.bg_color_light,
            shape  = gears.shape.rounded_rect,
        }
    button:connect_signal("button::press", function(c) c:set_bg(beautiful.accent_color) end)
    button:connect_signal("button::release", function(c) c:set_bg(beautiful.bg_color) end)
    button:connect_signal("mouse::enter", function(c) c:set_bg(beautiful.bg_color) end)
    button:connect_signal("mouse::leave", function(c) c:set_bg(beautiful.bg_color_light) end)
    return button
end

local function create()
    local poweroff_button   = create_button("WoW", "shutdown.svg")
    local reboot_button     = create_button("GitHub", "reboot.svg")
    local lock_button       = create_button("Settings", "lock.svg")

    poweroff_button.buttons = gears.table.join(
        awful.button({}, 1, function()
            awful.spawn(CMD_PWROFF)
        end)
    )
    reboot_button.buttons   = gears.table.join(
        awful.button({}, 1, function()
            awful.spawn(CMD_GH)
        end)
    )
    lock_button.buttons     = gears.table.join(
        awful.button({}, 1, function()
            awful.spawn(CMD_LOCK)
        end)
    )

    local powermenu         = wibox.widget {
        {
            {
                {
                    layout = wibox.layout.flex.vertical,
                    spacing = dpi(24),
                    poweroff_button,
                    reboot_button,
                    lock_button,
                },
                widget = wibox.container.place,
                halign = "center",
                valign = "center",
                forced_height = dpi(600),
                forced_width = dpi(100)
            },
            widget = wibox.container.background,
            bg     = beautiful.bg_color_light,
            shape  = gears.shape.rounded_rect
        },
        widget  = wibox.container.margin,
        margins = {
            left   = beautiful.dashboard_margin,
            right  = beautiful.dashboard_margin,
            bottom = beautiful.dashboard_margin,
            top    = beautiful.dashboard_margin / 2,
        },
    }
    return powermenu
end

return {
    create = create
}
