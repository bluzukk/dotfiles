local beautiful  = require("beautiful")
local gears      = require("gears")
local wibox      = require("wibox")
local dpi        = beautiful.xresources.apply_dpi

local util      = require("helpers.util")
local markup    = require("helpers.markup")

local config = require("config.settings")

local CMD_CPU_USE  = [[ bash -c "ps -Ao pcpu --sort=-pcpu | head -n 6" ]]
local CMD_CPU_NAME = [[ bash -c "ps -Ao comm --sort=-pcpu | head -n 6" ]]

local CMD_MEM_USE  = [[ bash -c "ps -Ao pmem --sort=-pmem | head -n 6" ]]
local CMD_MEM_NAME = [[ bash -c "ps -Ao comm --sort=-pmem | head -n 6" ]]

local function create_graph(max)
    return wibox.widget {
        max_value = max,
        step_width = 3,
        step_spacing = 1,
        step_shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 13)
end,
        widget = wibox.widget.graph,
        background_color = beautiful.bg_color_light,
        color = beautiful.accent_alt_color_dark,
        forced_height = dpi(75),
    }
end

local cpu_graph = create_graph(100)
local mem_graph = create_graph(100)
local gpu_graph = create_graph(100)
local net_graph = create_graph(5000)


local separator_vertical = wibox.widget {
    widget = wibox.widget.separator,
    orientation = "vertical",
    forced_width = 20,
    span_ratio = 1,
    thickness = 10,
    color = beautiful.bg_color
}

local function create_widget_container(header, graph)
    local widget = {
        {
            {
                {
                    align = 'left',
                    widget = wibox.widget.textbox,
                    forced_height = dpi(40),
                },
                {
                    id = "left_content_header",
                    align = 'left',
                    markup =
                        markup.fontfg(beautiful.font_name .. " 18", beautiful.accent_color, markup.bold(header)),
                    widget = wibox.widget.textbox,
                    forced_height = dpi(20),
                },
                {
                    id = "left_content",
                    align = 'left',
                    widget = wibox.widget.textbox,
                    forced_height = dpi(50),
                },
                layout = wibox.layout.fixed.vertical,
            },
            {
                graph,
                widget = wibox.container.margin,
                margins = {
                    right = dpi(25),
                    bottom = 0,
                    top = 0,
                },
            },
            layout = wibox.layout.fixed.vertical,
        },
        separator_vertical,
        {
            id = "right_content",
            font = beautiful.font,
            align = 'left',
            widget = wibox.widget.textbox,
            forced_width = dpi(230),
        },
        layout = wibox.layout.fixed.horizontal,
    }
    -- Put everything in a margin container
    return wibox.widget {
        {
            {
                widget = wibox.container.place,
                halign = "center",
                valign = "center",
                forced_height = dpi(175),
                widget,
            },
            widget = wibox.container.background,
            bg = beautiful.bg_color_light,
            shape = gears.shape.rounded_rect
        },
        widget = wibox.container.margin,
        margins = {
            left = config.dashboard_margin,
            right = config.dashboard_margin,
            bottom = 0,
            top = config.dashboard_margin/3,
        },
    }
end

local cpu_widget
local mem_widget
local gpu_widget
local net_widget

local function create()
    cpu_widget = create_widget_container("CPU", cpu_graph)
    mem_widget = create_widget_container("MEM", mem_graph)
    gpu_widget = create_widget_container("GPU", gpu_graph)
    net_widget = create_widget_container("NET", net_graph)

    -- Wrap everything nicely
    return wibox.widget {
        layout = wibox.layout.fixed.vertical,
        cpu_widget,
        mem_widget,
        gpu_widget,
        net_widget,
    }
end


local cpu_util = 0
awesome.connect_signal("evil::cpu", function(evil_cpu_util, evil_cpu_temp)
    cpu_util = evil_cpu_util
    cpu_widget:get_children_by_id("left_content")[1].markup =
        markup.fontfg(beautiful.font_name .. " 15", beautiful.accent_color_dark,
            cpu_util .. "% " .. evil_cpu_temp ..  "°C")
end)

local gpu_util = 0
awesome.connect_signal("evil::gpu", function(evil_gpu_util, evil_gpu_temp, evil_gpu_clock, evil_gpu_power)
    gpu_util = evil_gpu_util
    gpu_widget:get_children_by_id("left_content")[1].markup =
        markup.fontfg(beautiful.font_name .. " 15", beautiful.accent_color_dark,
            gpu_util .. "% " .. evil_gpu_temp ..  "°C")
    gpu_widget:get_children_by_id("right_content")[1].markup =
        markup.fontfg(beautiful.font_name .. " 14", beautiful.main_color, "       " .. evil_gpu_clock .. " MHz\n") ..
        markup.fontfg(beautiful.font_name .. " 14", beautiful.main_color, "       " .. evil_gpu_power .. " Watt")
end)

local net_now = 0
awesome.connect_signal("evil::net_now", function(evil)
    if evil then
        net_now = evil/1024
        net_widget:get_children_by_id("left_content")[1].markup =
        markup.fontfg(beautiful.font_name .. " 15", beautiful.accent_color_dark,
        string.format("%04.0f", net_now)
        .. "kb/s")
    end
end)

local net_total_down = 0
awesome.connect_signal("evil::net_total", function(evil)
    net_total_down = evil
end)

local net_total_up = 0
awesome.connect_signal("evil::net_total_up", function(evil)
    net_total_up = evil
end)

local net_ip4 = ""
awesome.connect_signal("evil::net_ip4", function(evil)
    if evil ~= "" then
        net_ip4 = evil
    else
        net_ip4 = "No IP4 :("
    end
end)

local net_ssid = ""
awesome.connect_signal("evil::net_ssid", function(evil)
    if evil ~= "" then
        net_ssid = evil
    else
        net_ssid = "No WiFi :("
    end
end)


local mem_perc = ""
local mem_util = ""
awesome.connect_signal("evil::ram", function(evil)
    mem_util = string.format("%.0f", tonumber(evil))
    mem_perc = string.format("%.0f", tonumber((mem_util / 15500) * 100))
    mem_widget:get_children_by_id("left_content")[1].markup =
        markup.fontfg(beautiful.font_name .. " 15", beautiful.accent_color_dark,
            mem_perc .. "% " .. mem_util ..  "mb")
end)


local function read_top()
    local cpu_top_names = util.read_cmd(CMD_CPU_NAME)
    local cpu_top_perc  = util.read_cmd(CMD_CPU_USE)

    local cpu_top = "\n"
    for k,v in pairs(cpu_top_names) do
        if k ~= 1 then
            local usage = string.format("%3.0f", tonumber(cpu_top_perc[k]) - 0.5)
            cpu_top = cpu_top .. "  " .. usage .. "% " .. v:sub(1, 12) .. "\n"
        end
    end

    local mem_top_names = util.read_cmd(CMD_MEM_NAME)
    local mem_top_perc  = util.read_cmd(CMD_MEM_USE)
    local mem_top = "\n"
    for k,v in pairs(mem_top_names) do
        if k ~= 1 then
            local usage = string.format("%3.0f", tonumber(mem_top_perc[k]) - 0.5)
            mem_top = mem_top .. "  " .. usage .. "% " .. v:sub(1, 12) .. "\n"
        end
    end

    return cpu_top, mem_top
end

-- Redraw graphs at the same time
local timer = gears.timer {
    timeout = 5,
    autostart = true
}
timer:connect_signal("timeout", function()
    cpu_graph:add_value(cpu_util)
    mem_graph:add_value(mem_perc)
    gpu_graph:add_value(gpu_util)
    net_graph:add_value(net_now)

    local cpu_top, mem_top = read_top()
    cpu_widget:get_children_by_id("right_content")[1].markup = cpu_top
    mem_widget:get_children_by_id("right_content")[1].markup = mem_top

    cpu_widget:get_children_by_id("right_content")[1].markup =
        markup.fontfg(beautiful.font_name .. " 14", beautiful.main_color,  cpu_top)
    mem_widget:get_children_by_id("right_content")[1].markup =
        markup.fontfg(beautiful.font_name .. " 14", beautiful.main_color,  mem_top)
    net_widget:get_children_by_id("right_content")[1].markup =
        markup.fontfg(beautiful.font_name .. " 14", beautiful.main_color,
            "    " .. net_ip4 .. "\n" .. "      ↑ ".. net_total_up .. "mb\n       ↓ " .. net_total_down .. "mb")
end)


return {
    create = create
}
