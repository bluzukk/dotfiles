local awful     = require("awful")
local beautiful = require("beautiful")
local gears     = require("gears")
local wibox     = require("wibox")
local dpi       = require("beautiful").xresources.apply_dpi

local markup    = require("helpers.markup")
local dashboard = require("modules.dashboard.init")

local mail_main = wibox.widget.textbox()
awesome.connect_signal("evil::mail_main", function(evil)
    mail_main:set_markup(markup(beautiful.color_critical, evil))
end)

local mail_ims = wibox.widget.textbox()
awesome.connect_signal("evil::mail_ims", function(evil)
    mail_ims:set_markup(markup(beautiful.color_critical, evil))
end)

local spr = wibox.widget.textbox("   ")

local tasklist_creator = require("modules.panel.tasklist")

local function create(s)
    local tasklist = tasklist_creator.create(s)

    local center_panel = awful.popup {
        screen = s,
        ontop = true,
        bg = beautiful.bg_color .. "0",
        -- bg = beautiful.bg_bar_outer,
        visible = true,
        opacity = 1,
        maximum_height = beautiful.bar_height,
        maximum_width = dpi(800),
        placement = function(c) awful.placement.top(c, { margins = { top = dpi(10) }}) end,
        shape = beautiful.corners,
        widget = {
            -- {
                {
                    {
                        layout = wibox.layout.fixed.horizontal,
                        mail_ims, mail_main,
                        tasklist,
                    },
                    layout = wibox.layout.align.horizontal,
                    align = "center",
                    forced_height = beautiful.bar_height,
                    shape = gears.shape.rect,
                },
                -- bg = beautiful.bg_bar_inner .. "0",
                shape  = beautiful.inner_corners,
                widget = wibox.container.background,
            -- },
            -- left   = dpi(5),
            -- right  = dpi(5),
            -- top    = dpi(5),
            -- bottom = dpi(5),
            -- widget = wibox.container.margin
        }
    }
    return center_panel
end

return {
    create = create
}

