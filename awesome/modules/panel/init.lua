local awful     = require("awful")
local beautiful = require("beautiful")
local gears     = require("gears")
local wibox     = require("wibox")
local dpi       = require("beautiful").xresources.apply_dpi

awful.layout.layouts = {
    awful.layout.suit.tile.right,
    awful.layout.suit.tile.right,
    awful.layout.suit.floating,
}

local tags = {" ", " ", " "}
local setupdone = false

local function create_screens()
    awful.screen.connect_for_each_screen(function(s)
        awful.tag(tags, s, awful.layout.layouts)
        -- Ghost wibar for spacing
        s.mywibox = awful.wibar {
            screen   = s,
            width    = dpi(100),
            height   = beautiful.bar_height,
            bg       = beautiful.accent_color .. "0",
            shape    = beautiful.corner,
            margins = {
                top    = dpi(10),
                bottom = dpi(-8),
            },
            widget = {
                layout = wibox.layout.fixed.horizontal,
                align = "bottom",
                forced_height = beautiful.bar_height,
                shape = gears.shape.rect,
            }
        }
        s.panel_left = require("modules.panel.panel-left").create(s)
        s.panel_center = require("modules.panel.panel-center").create(s)
        s.panel_right  = require("modules.panel.panel-right").create(s)
        s.box = require("modules.panel.taglist").create_boxes(s)
        s.box.visible = false
        s.zenmode = false
    end)
    setupdone = true
end

local function updateBarsVisibility()
    if setupdone then
        for s in screen do
            if not s.zenmode then
                if s.selected_tag then
                    s.panel_left.visible = not s.selected_tag.fullscreenMode
                    s.panel_center.visible = not s.selected_tag.fullscreenMode
                    s.panel_right.visible = not s.selected_tag.fullscreenMode
                end
            end
        end
    end
end

tag.connect_signal('property::selected',
function()
    updateBarsVisibility()
end)

client.connect_signal('property::fullscreen',
function(c)
    c.screen.selected_tag.fullscreenMode = c.fullscreen
    updateBarsVisibility()
end)

client.connect_signal('unmanage',
function(c)
    if c.fullscreen then
        c.screen.selected_tag.fullscreenMode = false
        updateBarsVisibility()
    end
end)

local function toggle_zenmode()
    for s in screen do
        s.zenmode = not s.zenmode
        s.box.visible = not s.box.visible
        s.panel_left.visible = not s.panel_left.visible
        s.panel_right.visible = not s.panel_right.visible
        s.mywibox.visible = not s.mywibox.visible
    end
end

return {
    create_screens = create_screens,
    toggle_zenmode = toggle_zenmode
}
