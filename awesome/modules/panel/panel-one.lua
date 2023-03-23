local awful     = require("awful")
local beautiful = require("beautiful")
local gears     = require("gears")
-- local gfs       = require("gears.filesystem")
local wibox     = require("wibox")
local dpi       = require("beautiful").xresources.apply_dpi
local markup    = require("helpers.markup")


-- Widgets
local spr = "   "

local cpu = wibox.widget.textbox()
awesome.connect_signal("evil::cpu", function(evil_cpu_util, evil_cpu_temp)
    local color = beautiful.accent_color
    if evil_cpu_util > 75 or evil_cpu_temp > 50 then
        color = beautiful.color_critical
    end
    cpu.markup = markup(beautiful.main_color,
        markup(color, "CPU ") .. evil_cpu_util .. "% " .. evil_cpu_temp .. "°C" .. spr)
end)

local gpu = wibox.widget.textbox()
awesome.connect_signal("evil::gpu", function(evil_gpu_util, evil_gpu_temp, _, power)
    local color = beautiful.accent_color
    if evil_gpu_temp > 45 or power > 250 then
        color = beautiful.color_critical
    end

    if evil_gpu_temp > 0 then
        gpu.markup = markup(beautiful.main_color,
            markup(color, "GPU ") .. evil_gpu_util .. "% " .. evil_gpu_temp .. "°C" .. spr)
    end
end)

local bat = wibox.widget.textbox()
awesome.connect_signal("evil::bat", function(evil_bat_perc)
    local color = beautiful.accent_color
    if evil_bat_perc < 30 then
        color = beautiful.color_critical
    end

    if evil_bat_perc > 0 then
        bat.markup = markup(beautiful.main_color,
        markup(color, "BAT ") .. evil_bat_perc .. "%" .. spr)
    else
        bat.markup = ""
    end
end)

local disk_free = wibox.widget.textbox()
awesome.connect_signal("evil::disk_free", function(evil)
    local color = beautiful.accent_color
    if evil > 10000 then
        color = beautiful.color_critical
    end
    disk_free.markup = markup(beautiful.main_color,
        markup(color ,"FS ") .. evil .. "gb" .. spr)
end)

local ram_used = wibox.widget.textbox()
awesome.connect_signal("evil::ram", function(evil)
    local color = beautiful.accent_color
    if evil > 10000 then
        color = beautiful.color_critical
    end
    local val = string.format("%.0f", evil)
    ram_used.markup = markup(beautiful.main_color,
        markup(color ,"MEM ") .. val .. "mb" .. spr)
end)

local weather = wibox.widget.textbox()
awesome.connect_signal("evil::weather", function(evil)
    local temp = string.format("%.0f", evil.temp)
    weather:set_markup(markup(beautiful.main_color,
        -- markup(beautiful.accent_color, "IRL ") ..
        --  evil.weather[1].description .. " " ..  temp .. "°C"))
        markup(beautiful.accent_color, "IRL ") ..
            beautiful.uwu_map[evil.weather[1].description] .. " " ..  temp .. "°C") .. spr)
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

-- local textclock = awful.widget.watch("date +'%R:%S'", 1, function(widget, stdout)
-- 	widget:set_markup(
--         markup.fontfg(beautiful.font_name .. " 16", beautiful.accent_alt_color, markup.bold(stdout)))
-- end)

local textclock = awful.widget.watch("date +'%R'", 20, function(widget, stdout)
	widget:set_markup(
        markup.fontfg(beautiful.font_name .. " 17", beautiful.accent_alt_color, markup.bold(stdout)))
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

local mail_main = wibox.widget.textbox()
awesome.connect_signal("evil::mail_main", function(evil)
    mail_main:set_markup(markup(beautiful.color_critical, evil))
end)

local mail_ims = wibox.widget.textbox()
awesome.connect_signal("evil::mail_ims", function(evil)
    mail_ims:set_markup(markup(beautiful.color_critical, evil))
end)

local sep = wibox.widget.textbox(" ")
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
            -- startbutton,
            {
                taglist,
                left   = dpi(18),
                right  = dpi(18),
                top    = dpi(2),
                bottom = dpi(2),
                widget = wibox.container.margin
            },
        },
        {
            tasklist,
            mail_main,
            mail_ims,
            widget = wibox.layout.fixed.horizontal
        },
        {
            layout = wibox.layout.fixed.horizontal,
            cpu,
            gpu,
            ram_used,
            disk_free,
            weather,
            bat,
            net_now,
            systray,
            textclock, sep
        },
    }
    return panel
end

return {
    create = create
}
