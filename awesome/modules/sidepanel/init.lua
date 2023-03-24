local awful      = require("awful")
local beautiful  = require("beautiful")
local gears      = require("gears")
local wibox      = require("wibox")
local dpi        = beautiful.xresources.apply_dpi

-- Dashboard Modules
local greeter   = require("modules.sidepanel.greeter")
local sliders   = require("modules.sidepanel.sliders")
-- local calendar  = require("modules.sidepanel.cal")
-- local weather   = require("modules.sidepanel.weather")
-- local notes     = require("modules.sidepanel.notes")
-- local system    = require("modules.sidepanel.system")
-- local powermenu = require("modules.sidepanel.powermenu")
-- local launcher  = require("modules.sidepanel.launcher")

local slider    = sliders.create()
-- local cal       = calendar.create()
-- local todo      = notes.create()
-- local greet     = greeter.create()
-- local htop      = system.create()
-- local powrmenu  = powermenu.create()
-- local shortcut  = launcher.create()

local weather_widget
-- if weather ~= -1 then
--     weather_widget = weather()
-- end

local tab          = true   -- Handle tabs
local persist      = false  -- Handle hover vs. persist mode
local popup_redraw = false  -- Redraw once in popup mode

local sidepanel = awful.popup {
    widget       = {},
    border_color = beautiful.border_focus,
    border_width = 0 or beautiful.border_width,
    placement    = awful.placement.stretch_down,
    -- placement    = awful.placement.centered,
    shape        = beautiful.corners,
    ontop        = true,
    visible      = false,
    opacity      = beautiful.opacity,
}

local stretcher = {
    wibox.widget.textbox,
    widget = wibox.container.place,
    content_fill_vertical = true
}

local function update()
    sidepanel.screen = awful.screen.focused()
    -- greet = greeter.create()
    if not persist then
        sidepanel.widget = wibox.widget {
            {
                {
                    layout = wibox.layout.fixed.vertical,
                    -- greet,
                    slider,
                },
                layout = wibox.layout.flex.vertical,
                forced_width = beautiful.sidepanel_width,
                forced_height = dpi(90),

            },
            widget = wibox.container.place
        }
        sidepanel.placement = nil
        awful.placement.top(sidepanel, { offset = { y = dpi(50)} })
    elseif tab then
        sidepanel.widget = wibox.widget {
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
                forced_width = beautiful.sidepanel_width,
            },
            widget = wibox.container.place
        }
        -- awful.placement.centered(sidepanel, { offset = { y = dpi(-50)} })
        sidepanel.placement = awful.placement.stretch_down
    else
        sidepanel.widget = wibox.widget {
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
                forced_width = beautiful.sidepanel_width,
            },
            widget = wibox.container.place,
        }
        -- awful.placement.centered(sidepanel, { offset = { y = dpi(-50)} })
        sidepanel.placement = awful.placement.stretch_down
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
        sidepanel.visible = true
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
    sidepanel.visible = true
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
    sidepanel.visible = false
    calendar.reset()
    cal = calendar.create()
end

local function toggle()
    if sidepanel.visible then
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
awesome.connect_signal("sidepanel::cal_redraw_needed", function()
    update()
end)

awesome.connect_signal("sidepanel::redraw_needed", function()
    update()
end)

awesome.connect_signal("sidepanel::mouse1", function()
    tab = not tab
    update()
end)

awesome.connect_signal("sidepanel::mouse3", function()
    hide()
end)


sidepanel:connect_signal("mouse::leave", function() hide() end)


-- local sidebar_activator = wibox({
--     width = 20,
--     visible = true,
--     ontop = true,
--     opacity = 0,
--     below = true,
--     screen = screen.primary,
--     bg = beautiful.accent_color,
--     placement = awful.placement.top,
-- })
--
-- sidebar_activator.height = dpi(35)
-- sidebar_activator:connect_signal("mouse::enter", function ()
--     if sidepanel.visible == false then
--         show()
--     end
-- end)
--
-- sidebar_activator:buttons(
-- gears.table.join(
-- awful.button({ }, 1, function ()
--     awful.tag.viewprev()
-- end),
-- awful.button({ }, 5, function ()
--     awful.tag.viewnext()
-- end)
-- ))

local function isVisible()
    return sidepanel.visible
end

return {
    toggle = toggle,
    show = show,
    hide = hide,
    popup = popup,
    isVisible = isVisible
}
