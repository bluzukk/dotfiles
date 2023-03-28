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
local linkz     = require("modules.dashboard.links")
local launcher  = require("modules.dashboard.launcher")

local slider    = sliders.create()
local cal       = calendar.create()
local todo      = notes.create()
local greet     = greeter.create()
local htop      = system.create()
local powrmenu  = powermenu.create()
local links     = linkz.create()
local shortcut  = launcher.create()

local weather_widget
if weather ~= -1 then
    weather_widget = weather()
end

local is_sticky = false
local dashboard = awful.popup {
    widget       = {},
    border_color = beautiful.border_focus,
    border_width = 0 or beautiful.border_width,
    -- placement    = awful.placement.centered,
    shape        = beautiful.corners,
    ontop        = true,
    visible      = false,
    opacity      = beautiful.opacity,
    -- bg = "#0000000"
}

local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        c:emit_signal(
            "request::activate",
            "tasklist",
            { raise = true }
        )
    end)
)


local function createContainer(widget)
    return wibox.widget {
        {
            {
                widget,
                widget = wibox.container.place,
                halign = "center",
                valign = "center",
                -- forced_height = dpi(100),
                -- forced_width = dpi(450),
            },
            widget = wibox.container.background,
            bg = beautiful.bg_color_light,
            shape = gears.shape.rounded_rect
        },
        widget = wibox.container.margin,
        margins = {
            left = beautiful.dashboard_margin,
            right = beautiful.dashboard_margin,
            bottom = beautiful.dashboard_margin,
            top = beautiful.dashboard_margin,
        },
    }
end

local tasklist  = awful.widget.tasklist {
    screen          = screen[1],
    filter          = awful.widget.tasklist.filter.allscreen,
    buttons         = tasklist_buttons,
    style           = {
        shape = gears.shape.rect,
    },
    layout          = {
        spacing        = 15,
        spacing_widget = {
            {
                forced_width = 10,
                widget       = wibox.widget.separator,
            },
            opacity = 0,
            widget = wibox.container.place,
        },
        layout         = wibox.layout.flex.vertical
    },
    widget_template = {
        {
            {
                id     = 'text_role',
                widget = wibox.widget.textbox,
                align  = "center"
            },
            forced_width = 300,
            layout = wibox.layout.flex.vertical
        },
        id     = 'background_role',
        widget = wibox.container.background,
        bg = beautiful.bg_color_light
    },
}

tasklist = createContainer(tasklist)

local stretcher = {
    wibox.widget.textbox,
    widget = wibox.container.place,
    forced_height = dpi(100),
    content_fill_vertical = false
}

local markup    = require("helpers.markup")
local up        = awful.widget.watch("uptime -p", 180, function(widget, stdout)
    widget:set_markup(
        markup.fontfg(beautiful.font_name .. " 16", beautiful.accent_color, stdout))
end)

local uptime    = createContainer(up)


local function update()
    awful.placement.centered(dashboard, { offset = { y = dpi(10) } })
    dashboard.screen = awful.screen.focused()
    greet = greeter.create()
    dashboard.widget = wibox.widget {
        {
            {
                layout = wibox.layout.align.horizontal,
                {
                    greet,
                    slider,
                    shortcut,
                    htop,
                    -- stretcher,
                    uptime,
                    layout = wibox.layout.fixed.vertical
                },
                {
                    weather_widget,
                    cal,
                    todo,
                    layout = wibox.layout.fixed.vertical
                },
                {
                    tasklist,
                    links,
                    -- tasklist,
                    powrmenu,
                    layout = wibox.layout.align.vertical
                },
            },
            layout = wibox.layout.fixed.horizontal,
            forced_width = dpi(1420),
            forced_height = dpi(800),
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


-- dashboard:connect_signal("mouse::leave", function() hide() end)

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
-- sidebar_activator:connect_signal("mouse::enter", function()
--     if dashboard.visible == false then
--         show()
--     else
--         hide()
--     end
-- end)
--
-- sidebar_activator:buttons(
--     gears.table.join(
--         awful.button({}, 1, function()
--             awful.tag.viewprev()
--         end),
--         awful.button({}, 5, function()
--             awful.tag.viewnext()
--         end)
--     ))
--
local function isVisible()
    return dashboard.visible
end

local function isSticky()
    return is_sticky
end

local function toggleSticky()
    is_sticky = not is_sticky
end

return {
    toggle = toggle,
    show = show,
    hide = hide,
    isVisible = isVisible,
    isSticky = isSticky,
    toggleSticky = toggleSticky,
}
