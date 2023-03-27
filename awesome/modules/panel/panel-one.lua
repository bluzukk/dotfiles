-------------------------------------------------------------------------------
-- Main Panel including Taglist/Tasklist and Systeminformation               --
-------------------------------------------------------------------------------

local awful           = require("awful")
local beautiful       = require("beautiful")
local gears           = require("gears")
local naughty         = require("naughty")
-- local gfs       = require("gears.filesystem")
local wibox           = require("wibox")
local dpi             = require("beautiful").xresources.apply_dpi
local markup          = require("helpers.markup")

local CMD_PROC_CPU    = [[ bash -c "ps -Ao pcpu,comm,pid --sort=-pcpu | head -n 30" ]]
local CMD_PROC_MEM    = [[ bash -c "ps -Ao pmem,comm,pid --sort=-pmem | head -n 30" ]]
local CMD_GPU         = [[ nvidia-smi  ]]
local CMD_NET         = [[ echo "implement me =("  ]]
local CMD_BAT         = [[ echo "implement me =("  ]]
local CMD_WEATHER     = [[ echo "implement me =("  ]]
local CMD_FILE_SYSTEM = [[ echo "implement me =("  ]]
local CMD_CLOCK       = powermenu

local notification
local function notification_hide()
    if notification then
        naughty.destroy(notification)
    end
end

local function notification_show(str, bg_color)
    naughty.destroy(notification)
    notification = naughty.notify({
        font = beautiful.font_name .. " 16",
        fg = beautiful.main_color,
        bg = bg_color,
        title = "",
        text = str,
    })
end

-- Widgets
local function createWidget(title, onclick_cmd, color_default, color_accent, is_elemental)
    local container = wibox.widget {
        {
            {
                widget = wibox.widget.textbox,
                id = "text",
                text = "Error:" .. title
            },
            widget  = wibox.container.margin,
            margins = {
                left  = dpi(16),
                right = dpi(16),
            },
            id      = "margins"
        },
        widget        = wibox.container.background,
        bg            = color_default,
        shape         = gears.shape.powerline,
        onclick       = onclick_cmd,
        title         = title,
        color_default = color_default,
        color_accent  = color_accent,
        update        = function(self, color, content)
            self:get_children_by_id('text')[1].markup =
                markup(color, title) .. "" ..
                markup(beautiful.main_color, content)
        end,
        hide          = function(self)
            self:get_children_by_id('text')[1].markup = ""
            self:get_children_by_id('margins')[1].margins = 0
        end

    }
    container:connect_signal("mouse::enter", function(self)
        self.bg = self.color_accent
    end)
    container:connect_signal("mouse::leave", function(self)
        notification_hide()
        self.bg = self.color_default
    end)

    container:connect_signal("button::press", function(self)
        if is_elemental then
            self.onclick.toggle()
        else
            awful.spawn.easy_async(self.onclick,
                function(evil)
                    notification_show(evil, self.color_default)
                end)
        end
    end)
    return container
end


local cpu_widget = createWidget("CPU ", CMD_PROC_CPU, beautiful.bg_color, beautiful.bg_color_light10)
awesome.connect_signal("evil::cpu", function(evil_cpu_util, evil_cpu_temp)
    local color = beautiful.accent_color
    if evil_cpu_util > 75 or evil_cpu_temp > 50 then
        color = beautiful.color_critical
    end
    cpu_widget:update(color, evil_cpu_util .. "% " .. evil_cpu_temp .. "°C")
end)


local gpu_widget = createWidget("GPU ", CMD_GPU, beautiful.bg_color, beautiful.bg_color_light10)
awesome.connect_signal("evil::gpu", function(evil_gpu_util, evil_gpu_temp)
    local color = beautiful.accent_color
    if evil_gpu_temp > 45 then
        color = beautiful.color_critical
    end
    if evil_gpu_temp > 0 then
        gpu_widget:update(color, evil_gpu_util .. "% " .. evil_gpu_temp .. "°C")
    end
end)

local ram_widget = createWidget("MEM ", CMD_PROC_MEM, beautiful.bg_color, beautiful.bg_color_light10)
awesome.connect_signal("evil::ram", function(evil)
    local color = beautiful.accent_color
    if evil > 25000 then
        color = beautiful.color_critical
    end
    local val = string.format("%.0f", evil)
    ram_widget:update(color, val .. "mb")
end)

local disk_widget = createWidget("FS ", CMD_FILE_SYSTEM, beautiful.bg_color, beautiful.bg_color_light10)
awesome.connect_signal("evil::disk_free", function(evil)
    local color = beautiful.accent_color
    disk_widget:update(color, evil .. "gb")
end)

local weather_widget = createWidget("IRL ", CMD_WEATHER, beautiful.bg_color, beautiful.bg_color_light10)
awesome.connect_signal("evil::weather", function(evil)
    local temp = string.format("%.0f", evil.temp)
    weather_widget:update(beautiful.accent_color, beautiful.uwu_map[evil.weather[1].description] .. " " .. temp .. "°C")
end)

local bat_widget = createWidget("BAT ", CMD_BAT, beautiful.bg_color, beautiful.bg_color_light10)
awesome.connect_signal("evil::bat", function(evil_bat_perc)
    local color = beautiful.accent_color
    if evil_bat_perc then
        if evil_bat_perc < 30 then
            color = beautiful.color_critical
        end
        bat_widget:update(color, evil_bat_perc .. "%")
    else
        bat_widget:hide()
    end
end)

local net_widget = createWidget("", CMD_NET, beautiful.bg_color, beautiful.bg_color_light10)
awesome.connect_signal("evil::net_now", function(evil)
    if evil then
        evil = string.format("%04.0f", evil / 1024)
        net_widget:update(beautiful.accent_alt_color, evil .. "kb/s")
    end
end)

local systray = wibox.widget {
    {
        {
            wibox.widget.systray(),
            layout = wibox.layout.fixed.horizontal
        },
        left   = dpi(20),
        right  = dpi(20),
        top    = dpi(0),
        bottom = dpi(0),
        widget = wibox.container.margin
    },
    widget = wibox.container.background,
    bg     = beautiful.bg_color_light5,
    shape  = gears.shape.powerline,
}

local clock_widget = createWidget("", CMD_CLOCK, beautiful.bg_color_light, beautiful.bg_color_light10, true)
awful.widget.watch("date +'%R'", 20, function(_, stdout)
    clock_widget:update(beautiful.accent_alt_color, markup.bold(stdout))
end)

local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
                "request::activate",
                "tasklist",
                { raise = true }
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
            layout = wibox.layout.flex.horizontal,
            -- startbutton,
            {
                taglist,
                left   = dpi(18),
                right  = dpi(18),
                top    = dpi(2),
                bottom = dpi(2),
                widget = wibox.container.margin,
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
            cpu_widget,
            gpu_widget,
            ram_widget,
            disk_widget,
            weather_widget,
            bat_widget,
            net_widget,
            systray,
            clock_widget,
        },
    }
    return panel
end

return {
    create = create
}
