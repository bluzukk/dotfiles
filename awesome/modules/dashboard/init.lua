local awful     = require("awful")
local beautiful = require("beautiful")
local gears     = require("gears")
local wibox     = require("wibox")
local dpi       = beautiful.xresources.apply_dpi

-- Dashboard Modules
local greeter   = require("modules.dashboard.greeter")
local sliders   = require("modules.dashboard.sliders")
local calendar  = require("modules.dashboard.cal")
local weather   = require("modules.dashboard.weather")
local notes     = require("modules.dashboard.notes")
local system    = require("modules.dashboard.system")
local powermenu = require("modules.dashboard.powermenu")
local launcher  = require("modules.dashboard.launcher")

local slider    = sliders.create()
local cal       = calendar.create()
local todo      = notes.create()
local greet     = greeter.create()
local htop      = system.create()
local powrmenu  = powermenu.create()
local shortcut  = launcher.create()

local weather_widget
if weather ~= -1 then
    weather_widget = weather()
end


local dashboard = awful.popup {
    widget       = {},
    border_color = beautiful.border_focus,
    border_width = 0 or beautiful.border_width,
    -- placement    = awful.placement.stretch_down,
    placement    = awful.placement.centered,
    shape        = beautiful.corners,
    ontop        = true,
    visible      = false,
    opacity      = beautiful.opacity,
}

local stretcher    = {
    wibox.widget.textbox,
    widget = wibox.container.place,
    content_fill_vertical = false
}

local function update()
    dashboard.screen = awful.screen.focused()
    greet = greeter.create()
    dashboard.widget = wibox.widget {
        {
            {
                layout = wibox.layout.fixed.horizontal,
                {
                    greet,
                    slider,
                    htop,
                    layout = wibox.layout.align.vertical
                },
                {
                    weather_widget,
                    cal,
                    layout = wibox.layout.fixed.vertical
                },
                shortcut,

                todo,
            },

            layout = wibox.layout.align.horizontal,
            forced_width = dpi(1300),
            forced_height = dpi(720),
        },
        widget = wibox.container.place
    }
end

-- First time setup
update()


local function show()
    -- cls = client.get(awful.screen.focused())
    -- for _, c in ipairs(cls) do
    --     -- c.hidden = true
    --     c.opacity = 0
    --     -- c.minimized = true
    -- end
    update()
    dashboard.visible = true
end

local function hide()
    -- cls = client.get(awful.screen.selected_tag)
    -- for _, c in ipairs(cls) do
    --     -- c.hidden = false
    --     c.opacity = 1
    --     -- c.minimized = false
    -- end
    dashboard.visible = false
    calendar.reset()
    cal = calendar.create()
end

local function toggle()
    if dashboard.visible then
        hide()
    else
        show()
    end
end

-- Manage tabs and redraw callbacks
awesome.connect_signal("dashboard::cal_redraw_needed", function()
    update()
end)

awesome.connect_signal("dashboard::redraw_needed", function()
    update()
end)

awesome.connect_signal("dashboard::mouse3", function()
    hide()
end)


dashboard:connect_signal("mouse::leave", function() hide() end)

local function isVisible()
    return dashboard.visible
end

return {
    toggle = toggle,
    show = show,
    hide = hide,
    isVisible = isVisible
}
