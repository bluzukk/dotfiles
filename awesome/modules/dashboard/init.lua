local awful      = require("awful")
local beautiful  = require("beautiful")
local gears      = require("gears")
local wibox      = require("wibox")
local dpi        = beautiful.xresources.apply_dpi

-- Dashboard Modules
local greeter   = require("modules.dashboard.greeter")
local sliders   = require("modules.dashboard.sliders")
local calendar  = require("modules.dashboard.cal")
local weather   = require("modules.dashboard.weather")
local notes     = require("modules.dashboard.notes")
local system    = require("modules.dashboard.system")
local powermenu = require("modules.dashboard.powermenu")

local slider    = sliders.create()
local cal       = calendar.create()
local todo      = notes.create()
local greet     = greeter.create()
local htop      = system.create()
local powrmenu  = powermenu.create()

local weather_widget
if weather ~= -1 then
    weather_widget = weather()
end

local tab          = true   -- Handle tabs
local persist      = false  -- Handle hover vs. persist mode
local popup_redraw = false  -- Redraw once in popup mode

local dashboard = awful.popup {
    widget       = {},
    border_color = beautiful.border_focus,
    border_width = 0 or beautiful.border_width,
    placement    = function(self) awful.placement.top_left(self, { offset = { y = dpi(62), x = dpi(20) } }) end,
    -- placement    = awful.placement.center_left,
    shape        = beautiful.corners,
    ontop        = true,
    visible      = false,
    opacity      = beautiful.opacity+0.15,
}


local function update()
    dashboard.screen = awful.screen.focused()
    greet = greeter.create()
    if not persist then
        dashboard.widget = wibox.widget {
            {
                {
                    layout = wibox.layout.fixed.vertical,
                    greet,
                    slider,
                },
                layout = wibox.layout.flex.vertical,
                forced_width = beautiful.dashboard_width,
                forced_height = dpi(250),

            },
            widget = wibox.container.place
        }
    elseif tab then
        dashboard.widget = wibox.widget {
            {
                {
                    layout = wibox.layout.fixed.vertical,
                    greet,
                    slider,
                    weather_widget,
                    cal,
                    todo,
                },
                wibox.widget.textbox(""), -- sep
                {
                    layout = wibox.layout.flex.vertical,
                    powrmenu,
                },
                layout = wibox.layout.align.vertical,
                forced_width = beautiful.dashboard_width,
                forced_height = beautiful.dashboard_height,
            },
            widget = wibox.container.place
        }
    else
        dashboard.widget = wibox.widget {
            {
                {
                    layout = wibox.layout.fixed.vertical,
                    greet,
                    htop
                },
                wibox.widget.textbox(""), -- sep
                {
                    layout = wibox.layout.fixed.vertical,
                    powrmenu,
                },
                layout = wibox.layout.align.vertical,
                forced_width = beautiful.dashboard_width,
                forced_height = beautiful.dashboard_height,
            },
            widget = wibox.container.place,
        }
    end
end

-- First time setup
update()

-- Show / Hide / Popup Logic
local popup_timer = gears.timer {
    timeout = 0.75,
}

local function popup()
    if popup_redraw then update() end
    if not persist then
        popup_redraw = false
        dashboard.visible = true
        popup_timer:stop()
        popup_timer:start()
    end
end

local function show()
    persist = true
    popup_timer:stop()
    popup_redraw = false
    update()
    dashboard.visible = true
end

local function hide()
    popup_redraw = true
    persist = false
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

popup_timer:connect_signal("timeout", function()
    hide()
    popup_redraw = true
    popup_timer:stop()
end)

-- Manage tabs and redraw callbacks
awesome.connect_signal("dashboard::cal_redraw_needed", function()
    update()
end)

awesome.connect_signal("dashboard::mouse1", function()
    tab = not tab
    update()
end)

awesome.connect_signal("dashboard::mouse3", function()
    hide()
end)


dashboard:connect_signal("mouse::leave", function() hide() end)


local sidebar_activator = wibox({y = 10, width = 1, visible = true, ontop = false, opacity = 0, below = true, screen = screen.primary})
sidebar_activator.height = dpi(1000)
sidebar_activator:connect_signal("mouse::enter", function ()
    if dashboard.visible == false then
        show()
    end
end)

awful.placement.left(sidebar_activator)
sidebar_activator:buttons(
gears.table.join(
    awful.button({ }, 1, function ()
        awful.tag.viewprev()
    end),
    awful.button({ }, 5, function ()
        awful.tag.viewnext()
    end)
))


return {
    toggle = toggle,
    show = show,
    hide = hide,
    popup = popup
}
