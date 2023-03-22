local awful     = require("awful")
local beautiful = require("beautiful")
local gears     = require("gears")
-- local gfs       = require("gears.filesystem")
local wibox     = require("wibox")
local dpi       = require("beautiful").xresources.apply_dpi

local markup    = require("helpers.markup")

-- Widgets
local spr = wibox.widget.textbox(" ")

-- local ICONS_PATH =  gfs.get_configuration_dir() .. "assets/powermenu/"
-- local img =  gears.color.recolor_image(
--     ICONS_PATH .. "arrow.png", beautiful.accent_alt_color)
-- local menubutton = wibox.widget{
    --     widget = wibox.widget.imagebox,
    --     image = img,
    --     resize = true,
    --     forced_height = 10,
    -- }

    local textclock = awful.widget.watch("date +'%R'", 10, function(widget, stdout)
        widget:set_markup(
        markup.fontfg(beautiful.font, beautiful.accent_color, "  " ..
        markup.bold(stdout) .. "    "))
    end)

    local net_ip4 = wibox.widget.textbox()
    awesome.connect_signal("evil::net_ip4", function(evil)
        net_ip4:set_markup(markup(beautiful.accent_color, evil))
    end)

    local net_ssid = wibox.widget.textbox()
    awesome.connect_signal("evil::net_ssid", function(evil)
        net_ssid:set_markup(markup(beautiful.accent_color, evil))
    end)

    local net_total = wibox.widget.textbox()
    awesome.connect_signal("evil::net_total", function(evil)
        net_total:set_markup(markup(beautiful.main_color, evil .. "mb"))
    end)

    local net_now = wibox.widget.textbox()
    awesome.connect_signal("evil::net_now", function(evil)
        if evil then
            evil = string.format("%04.0f", evil/1024)
            net_now:set_markup(markup(beautiful.accent_alt_color, evil .. "kb/s"))
        end
    end)

    local function create(s)
        local taglist = require("modules.panel.taglist").create(s)
        -- local tasklist = require("modules.panel.tasklist").create(s)

        return awful.popup {
            screen = s,
            ontop = true,
            bg = beautiful.bg_bar_outer,
            visible = true,
            opacity = beautiful.opacity,
            maximum_width = dpi(200),
            height = dpi(50),
            maximum_height = beautiful.panel_height,
            placement = function(c) awful.placement.top_left(c, { margins = {left = dpi(20), top = dpi(10) }}) end,
            shape = beautiful.corners,
            widget = {
                {
                    {
                        {
                            layout = wibox.layout.fixed.horizontal,
                            -- menubutton,
                            taglist, spr,
                            -- net_ip4, spr,
                            -- net_total, spr,
                            -- net_now, spr,
                            -- net_ssid,
                        },
                        layout = wibox.layout.align.horizontal,
                        align = "center",
                        forced_height = beautiful.bar_height,
                        shape = gears.shape.rect,

                    },
                    bg = beautiful.bg_bar_inner,
                    shape  = beautiful.inner_corners,
                    widget = wibox.container.background,
                    forced_height = dpi(30),
                },
                left   = dpi(5),
                right  = dpi(5),
                top    = dpi(5),
                bottom = dpi(5),
                widget = wibox.container.margin
            }
        }
    end

    return {
        create = create
    }
