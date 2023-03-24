local awful      = require("awful")
local beautiful  = require("beautiful")
local gears      = require("gears")
local gfs        = require("gears.filesystem")
-- local naughty   = require("naughty")
local wibox      = require("wibox")
local dpi        = beautiful.xresources.apply_dpi

local markup     = require("helpers.markup")

local CMD_BROWSE     = [[ librewolf  ]]
local CMD_GAME =
[[ bash -c "VULKAN_DEVICE_INDEX=1 WINEPREFIX=~/Games/.wow wine ~/Games/WoW/ClassicWoW/_classic_/WowClassic.exe" ]]
local CMD_MUSIC   = [[ librewolf https://www.youtube.com/watch?v=AjIwBNxv3FE ]]

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
    local game_button     = create_button("UwU", "")
    local browse_button   = create_button("Br0wse", "")
    local music_button    = create_button("Mus1c", "")

    game_button.buttons   = gears.table.join(
        awful.button({}, 1, function()
            awful.spawn(CMD_GAME)
        end)
    )
    browse_button.buttons = gears.table.join(
        awful.button({}, 1, function()
            awful.spawn(CMD_BROWSE)
        end)
    )
    music_button.buttons  = gears.table.join(
        awful.button({}, 1, function()
            awful.spawn(CMD_MUSIC)
        end)
    )

    local apps            = wibox.widget {
        {
            {
                {
                    layout = wibox.layout.flex.vertical,
                    spacing = dpi(10),
                    {
                        widget = wibox.widget.textbox(),
                        markup = markup.fontfg(beautiful.font_name .. " 20", beautiful.accent_alt_color,
                            "  APPS")
                    },
                    game_button,
                    browse_button,
                    music_button,
                },
                widget = wibox.container.place,
                halign = "center",
                valign = "center",
                -- forced_height = dpi(600),
                forced_width = dpi(300)
            },
            widget = wibox.container.background,
            bg     = beautiful.bg_color_light,
            shape  = gears.shape.rounded_rect
        },
        widget  = wibox.container.margin,
        margins = {
            left  = beautiful.dashboard_margin,
            right = beautiful.dashboard_margin,
            -- bottom = beautiful.dashboard_margin,
            top   = beautiful.dashboard_margin,
        },
    }

    local power           = wibox.widget {
        {
            {
                {
                    layout = wibox.layout.flex.vertical,
                    spacing = dpi(10),
                    {
                        widget = wibox.widget.textbox(),
                        markup = markup.fontfg(beautiful.font_name .. " 20", beautiful.accent_alt_color,
                            "  APPS")
                    },
                    game_button,
                    browse_button,
                    music_button,
                },
                widget = wibox.container.place,
                halign = "center",
                valign = "center",
                -- forced_height = dpi(600),
                forced_width = dpi(300)
            },
            widget = wibox.container.background,
            bg     = beautiful.bg_color_light,
            shape  = gears.shape.rounded_rect
        },
        widget  = wibox.container.margin,
        margins = {
            left  = beautiful.dashboard_margin,
            right = beautiful.dashboard_margin,
            -- bottom = beautiful.dashboard_margin,
            top   = beautiful.dashboard_margin,
        },
    }
    local links           = wibox.widget {
        apps,
        layout = wibox.layout.align.vertical
    }
    return links
end

return {
    create = create
}
