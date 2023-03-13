local awful     = require("awful")
local beautiful = require("beautiful")
local gears     = require("gears")
-- local gfs       = require("gears.filesystem")
local wibox     = require("wibox")
local dpi       = require("beautiful").xresources.apply_dpi

local markup    = require("helpers.markup")

-- Widgets
local spr = wibox.widget.textbox(" ")
local bar = wibox.widget.textbox("|")

local cpu = wibox.widget.textbox()
awesome.connect_signal("evil::cpu", function(evil_cpu_util, evil_cpu_temp)
    local color = beautiful.accent_color
    if evil_cpu_util > 75 or evil_cpu_temp > 50 then
        color = beautiful.color_critical
    end
    cpu.markup = markup(beautiful.main_color,
        markup(color, "CPU ") .. evil_cpu_util .. "% " .. evil_cpu_temp .. "°C")
end)

local gpu = wibox.widget.textbox()
awesome.connect_signal("evil::gpu", function(evil_gpu_util, evil_gpu_temp, _, power)
    local color = beautiful.accent_color
    if evil_gpu_temp > 45 or power > 250 then
        color = beautiful.color_critical
    end

    gpu.markup = markup(beautiful.main_color,
        markup(color, "GPU ") .. evil_gpu_util .. "% " .. evil_gpu_temp .. "°C")
end)


local disk_free = wibox.widget.textbox()
awesome.connect_signal("evil::disk_free", function(evil)
    local color = beautiful.accent_color
    if evil > 10000 then
        color = beautiful.color_critical
    end
    disk_free.markup = markup(beautiful.main_color,
        markup(color ,"FS ") .. evil .. "gb")
end)

local ram_used = wibox.widget.textbox()
awesome.connect_signal("evil::ram", function(evil)
    local color = beautiful.accent_color
    if evil > 10000 then
        color = beautiful.color_critical
    end
    local val = string.format("%.0f", evil)
    ram_used.markup = markup(beautiful.main_color,
        markup(color ,"MEM ") .. val .. "mb")
end)

local uwu_map = {
    ["clear sky"] = "clear skywu",
    ["few clouds"] = "few cloudwu",
    ["scattered clouds"] = "little cloudwu",
    ["broken clouds"] = "much cloudwu",
    ["overcast clouds"] = "only cloudwu",
    ["light rain"] = "little rainwu",
    ["shower rain"] = "stronk rainwu",
    ["rain"] = "rain ",
    ["thunderstorm"] = "thunderstorm",
    ["snow"] = "snow",
    ["light snow"] = "little snowu",
    ["rain and snow"] = "rainwu snowu",
    ["mist"] = "mist",
}

local weather = wibox.widget.textbox()
awesome.connect_signal("evil::weather", function(evil)
    local temp = string.format("%.0f", evil.temp)
    weather:set_markup(markup(beautiful.main_color,
        markup(beautiful.accent_color, "IRL ") ..
        uwu_map[evil.weather[1].description] .. " " ..  temp .. "°C"))
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

local systray = wibox.widget{
    {
        wibox.widget.systray(),
        layout = wibox.layout.fixed.horizontal
    },
        left   = dpi(10),
        right  = dpi(10),
        top    = dpi(3),
        bottom = dpi(3),
        widget = wibox.container.margin
}

local textclock = awful.widget.watch("date +'%R'", 10, function(widget, stdout)
	widget:set_markup(
        markup.fontfg(beautiful.font, beautiful.accent_alt_color, markup.bold(stdout)))
end)

local tasklist_buttons = gears.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
                "request::activate",
                "tasklist",
                {raise = true}
            )
        end
    end)
)


-- local myawesomemenu = {
--    { "restart", awesome.restart },
--    { "quit", function() awesome.quit() end },
-- }
--
-- local dashboard = require("modules.dashboard.init")
-- local panels = require("modules.panel.init")
-- local mymainmenu = awful.menu({ items = {
--         { "awesome", myawesomemenu, beautiful.awesome_icon },
--         { "open terminal", beautiful.terminal },
--         { "Dashboard",  dashboard.toggle},
--         { "Zenmode",  panels.toggle_zenmode}
--     }
--  })

-- local mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
--                                      menu = mymainmenu })

local function create(s)
    local panel = awful.wibar({
        position = "top",
        screen = s,
        height = dpi(35),
        bg = beautiful.bg_color,
        opacity = beautiful.opacity
    })
    local taglist = require("modules.panel.taglist").create(s)
    local tasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.minimizedcurrenttags, tasklist_buttons)

    -- Add widgets to the wibox
    panel:setup {
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            -- mylauncher,
            {
                taglist,
                left   = dpi(18),
                right  = dpi(18),
                top    = dpi(2),
                bottom = dpi(2),
                widget = wibox.container.margin
            },
        },
        tasklist,
        {
            layout = wibox.layout.fixed.horizontal,
            cpu, spr, bar, spr,
            gpu, spr, bar, spr,
            ram_used, spr, bar, spr,
            disk_free, spr, bar, spr,
            weather, spr, bar,
            systray, spr,
            textclock, spr,
        },
    }
    return panel
end

return {
    create = create
}
