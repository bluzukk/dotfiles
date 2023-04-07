local awful     = require("awful")
local beautiful = require("beautiful")
local gears     = require("gears")
local wibox     = require("wibox")
local markup    = require("helpers.markup")
local dpi       = beautiful.xresources.apply_dpi

-- Dashboard Modules
local greeter   = require("modules.sideboard.greeter")
local sliders   = require("modules.sideboard.sliders")
local calendar  = require("modules.sideboard.cal")
local weather   = require("modules.sideboard.weather")
local notes     = require("modules.sideboard.notes")
local system    = require("modules.sideboard.system")
local powermenu = require("modules.sideboard.powermenu")
local linkz     = require("modules.sideboard.links")
local launcher  = require("modules.sideboard.launcher")

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
local sideboard = awful.popup {
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
                forced_height = dpi(100),
                -- forced_width = dpi(450),
            },
            widget = wibox.container.background,
            bg = beautiful.bg_color_light,
            shape = gears.shape.rounded_rect
        },
        widget = wibox.container.margin,
        margins = {
            left = beautiful.sideboard_margin,
            right = beautiful.sideboard_margin,
            bottom = beautiful.sideboard_margin,
            top = beautiful.sideboard_margin,
        },
    }
end

local hour = os.date("%H")
local minutes = os.date("%M")
local day = os.date("%A")


local textclock = awful.widget.watch("date +'%R:%S'", 1, function(widget, stdout)
    widget:set_markup(
        markup.fontfg(beautiful.font_name .. " 32", beautiful.accent_alt_color, markup.bold(stdout)))
end)

local clock = wibox.widget {
    layout = wibox.layout.fixed.vertical,
    {
        widget = wibox.widget.textbox,
        font   = beautiful.font_name .. " 22",
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
    content_fill_vertical = true
}

local markup    = require("helpers.markup")
local up        = awful.widget.watch("uptime -p", 180, function(widget, stdout)
    widget:set_markup(
        markup.fontfg(beautiful.font_name .. " 16", beautiful.accent_color, stdout))
end)

local uptime    = createContainer(up)


local function update()
    awful.placement.top_right(sideboard, { offset = { y = dpi(35) } })
    sideboard.screen = awful.screen.focused()
    greet = greeter.create()
    sideboard.widget = wibox.widget {
        {
            {
                layout = wibox.layout.align.horizontal,
                {
                    greet,
                    slider,
                    htop,
                    uptime,
                    stretcher,
                    layout = wibox.layout.fixed.vertical
                },
            },
            layout = wibox.layout.fixed.horizontal,
            forced_width = dpi(520),
            -- forced_height = dpi(800),
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
    sideboard.visible = true
    awful.placement.stretch_down(sideboard)
end

local function hide()
    -- cls = client.get(awful.screen.selected_tag)
    -- for _, c in ipairs(cls) do
    --     -- c.hidden = false
    --     c.opacity = 1
    --     -- c.minimized = false
    -- end
    sideboard.visible = false
    calendar.reset()
    cal = calendar.create()
end

local function toggle()
    if sideboard.visible then
        hide()
    else
        show()
    end
end

-- Manage tabs and redraw callbacks
awesome.connect_signal("sideboard::cal_redraw_needed", function()
    update()
end)

awesome.connect_signal("sideboard::redraw_needed", function()
    update()
end)

awesome.connect_signal("sideboard::mouse3", function()
    hide()
end)


-- sideboard:connect_signal("mouse::leave", function() hide() end)

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
--     if sideboard.visible == false then
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
    return sideboard.visible
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
