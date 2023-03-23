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
-- local notes     = require("modules.dashboard.notes")
local system    = require("modules.dashboard.system")
local powermenu = require("modules.dashboard.powermenu")
local launcher  = require("modules.dashboard.launcher")

local slider    = sliders.create()
local cal       = calendar.create()
-- local todo      = notes.create()
local greet     = greeter.create()
local htop      = system.create()
local powrmenu  = powermenu.create()
local shortcut  = launcher.create()

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
    -- placement    = awful.placement.stretch_down,
    placement    = awful.placement.centered,
    shape        = beautiful.corners,
    ontop        = true,
    visible      = false,
    opacity      = beautiful.opacity,
}

local stretcher = {
    wibox.widget.textbox,
    widget = wibox.container.place,
    content_fill_vertical = false
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
                forced_height = dpi(200),

            },
            widget = wibox.container.place
        }
        dashboard.placement = nil
        awful.placement.top_left(dashboard, { offset = { y = dpi(35)} })
    elseif tab then
        dashboard.widget = wibox.widget {
            {
                {
                    layout = wibox.layout.fixed.vertical,
                    greet,
                    slider,
                    shortcut,
                    {
                        cal,
                        weather_widget,
                        layout = wibox.layout.align.horizontal
                    },
                    -- todo,
                },
                stretcher,
                {
                    layout = wibox.layout.flex.vertical,

                    powrmenu,
                },
                layout = wibox.layout.align.vertical,
                forced_width = beautiful.dashboard_width,
            },
            widget = wibox.container.place
        }
        awful.placement.centered(dashboard, { offset = { y = dpi(-50)} })
        -- dashboard.placement = awful.placement.stretch_down
    else
        dashboard.widget = wibox.widget {
            {
                {
                    layout = wibox.layout.fixed.vertical,
                    greet,
                    htop
                },
                stretcher,
                {
                    layout = wibox.layout.fixed.vertical,
                    powrmenu,
                },
                layout = wibox.layout.align.vertical,
                forced_width = beautiful.dashboard_width,
            },
            widget = wibox.container.place,
        }
        awful.placement.centered(dashboard, { offset = { y = dpi(-50)} })
        -- dashboard.placement = awful.placement.stretch_down
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
    -- cls = client.get(awful.screen.focused())
    -- for _, c in ipairs(cls) do
    --     -- c.hidden = true
    --     c.opacity = 0
    --     -- c.minimized = true
    -- end
    persist = true
    popup_timer:stop()
    popup_redraw = false
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

awesome.connect_signal("dashboard::redraw_needed", function()
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


local sidebar_activator = wibox({
    width = 20,
    visible = true,
    ontop = true,
    opacity = 0,
    below = true,
    screen = screen.primary,
    bg = beautiful.accent_color,
    placement = awful.placement.top,
})

-- sidebar_activator.height = dpi(35)
-- sidebar_activator:connect_signal("mouse::enter", function ()
--     if dashboard.visible == false then
--         show()
--     end
-- end)
--
sidebar_activator:buttons(
gears.table.join(
awful.button({ }, 1, function ()
    awful.tag.viewprev()
end),
awful.button({ }, 5, function ()
    awful.tag.viewnext()
end)
))

local function isVisible()
    return dashboard.visible
end

return {
    toggle = toggle,
    show = show,
    hide = hide,
    popup = popup,
    isVisible = isVisible
}
