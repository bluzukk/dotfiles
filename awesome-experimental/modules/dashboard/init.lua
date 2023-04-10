local awful     = require("awful")
local beautiful = require("beautiful")
local gears     = require("gears")
local wibox     = require("wibox")
local markup    = require("helpers.markup")
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

local is_sticky = true
local dashboard_left = awful.popup {
    widget       = {},
    border_color = beautiful.border_focus,
    border_width = 0 or beautiful.border_width,
    -- placement    = awful.placement.centered,
    shape        = beautiful.corners,
    ontop        = true,
    visible      = false,
    opacity      = beautiful.opacity,
    bg = "#0000000"
}

local dashboard_right = awful.popup {
    widget       = {},
    border_color = beautiful.border_focus,
    border_width = 0 or beautiful.border_width,
    -- placement    = awful.placement.centered,
    shape        = beautiful.corners,
    ontop        = true,
    visible      = false,
    opacity      = beautiful.opacity,
    bg = "#0000000"
}

local dashboard_center = awful.popup {
    widget       = {},
    border_color = beautiful.border_focus,
    border_width = 0 or beautiful.border_width,
    -- placement    = awful.placement.centered,
    shape        = beautiful.corners,
    ontop        = true,
    visible      = false,
    opacity      = beautiful.opacity,
    bg = "#0000000"
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
                forced_height = dpi(100),
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

local hour = os.date("%H")
local minutes = os.date("%M")
local day = os.date("%A")


local textclock = awful.widget.watch("date +'%R:%S'", 1, function(widget, stdout)
    widget:set_markup(
        markup.fontfg(beautiful.font_name .. " 40", beautiful.accent_alt_color, markup.bold(stdout)))
end)

local clock = wibox.widget {
    layout = wibox.layout.fixed.vertical,
    {
        widget = wibox.widget.textbox,
        font   = beautiful.font_name .. " 38",
        markup = markup(beautiful.accent_color, markup.bold(day))
    },
    textclock,
}


local clock = createContainer(clock)

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
    awful.placement.top_left(dashboard_left, { offset = { y = dpi(50) } })
    awful.placement.top(dashboard_center, { offset = { y = dpi(50) } })
    awful.placement.top_right(dashboard_right, { offset = { y = dpi(50) } })
    dashboard_left.screen = awful.screen.focused()
    dashboard_center.screen = awful.screen.focused()
    dashboard_right.screen = awful.screen.focused()
    greet = greeter.create()
    dashboard_left.widget = wibox.widget {
        {
            {
                layout = wibox.layout.align.horizontal,
                {
                    clock,
                    weather_widget,
                    cal,
                    layout = wibox.layout.fixed.vertical
                },
            },
            layout = wibox.layout.fixed.horizontal,
            forced_width = dpi(500),
            forced_height = dpi(800),
        },
        widget = wibox.container.place
    }
    dashboard_center.widget = wibox.widget {
        {
            {
                layout = wibox.layout.align.horizontal,
                {
                    greet,
                    -- todo,
                    layout = wibox.layout.fixed.vertical
                },
            },
            layout = wibox.layout.fixed.horizontal,
            forced_width = dpi(500),
            forced_height = dpi(800),
        },
        widget = wibox.container.place
    }
    dashboard_right.widget = wibox.widget {
        {
            {
                layout = wibox.layout.align.horizontal,
                {
                    shortcut,
                    -- tasklist,
                    links,
                    powrmenu,
                    layout = wibox.layout.align.vertical
                },
            },
            layout = wibox.layout.fixed.horizontal,
            forced_width = dpi(500),
            forced_height = dpi(900),
        },
        widget = wibox.container.place
    }
end

-- First time setup
update()



local function show()
    cls = client.get(awful.screen.focused())
    for _, c in ipairs(cls) do
        -- c.hidden = true
        c.opacity = 0
        -- c.minimized = true
    end
    update()
    dashboard_left.visible = true
    dashboard_center.visible = true
    dashboard_right.visible = true
end

local function hide()
    cls = client.get(awful.screen.selected_tag)
    for _, c in ipairs(cls) do
        -- c.hidden = false
        c.opacity = 1
        -- c.minimized = false
    end
    dashboard_left.visible = false
    dashboard_center.visible = false
    dashboard_right.visible = false
    calendar.reset()
    cal = calendar.create()
end

local function toggle()
    if dashboard_left.visible then
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
