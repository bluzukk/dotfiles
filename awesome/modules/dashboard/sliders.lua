local beautiful  = require("beautiful")
local gears      = require("gears")
local wibox      = require("wibox")
local dpi        = beautiful.xresources.apply_dpi

local util       = require("helpers.util")
local markup     = require("helpers.markup")

local CMD_GET_VOL = [[ bash -c "~/.config/awesome/scripts/volume.sh" ]]
local CMD_GET_MIC = [[ bash -c "~/.config/awesome/scripts/microphone.sh" ]]

local volume_widget = wibox.widget {
    {
        {
            widget = wibox.widget.textbox,
            markup = markup.fontfg(beautiful.font_name .. " 12", beautiful.accent_alt_color_dark,
            markup.bold("vol "))
        },
        {
            id        = "volume_bar",
            max_value = 100,
            widget    = wibox.widget.progressbar,
            shape = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, 13)
            end,
            forced_width = beautiful.panel_right_width*0.67,
            background_color = beautiful.bg_color,
            bar_border_width = 10,
            color = beautiful.accent_alt_color_dark,
            margins = {
                top = 4,
                bottom = 2,
                left = dpi(15),
            }
        },
        layout = wibox.layout.fixed.horizontal
    },
    forced_height = 15,
    layout = wibox.layout.fixed.vertical,
    update = function(self)
        util.async(CMD_GET_VOL, function(volume)
            self:get_children_by_id('volume_bar')[1].value = tonumber(volume:sub(1, #volume-2))
        end)
    end,
}

local mic_widget = wibox.widget {
    {
        {
            widget = wibox.widget.textbox,
            markup = markup.fontfg(beautiful.font_name .. " 12", beautiful.accent_color_dark,
            markup.bold("mic "))
        },
        {
            id        = "mic_bar",
            max_value = 100,
            widget    = wibox.widget.progressbar,
            shape = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, 13)
            end,
            forced_width = beautiful.panel_right_width*0.67,
            background_color = beautiful.bg_color,
            bar_border_width = 10,
            color = beautiful.accent_color_dark,
            margins = {
                top = 4,
                bottom = 2,
                left = dpi(15)
            }
        },
        layout = wibox.layout.fixed.horizontal
    },
    forced_height = 15,
    layout = wibox.layout.fixed.vertical,
    update = function(self)
        util.async(CMD_GET_MIC, function(volume)
            self:get_children_by_id('mic_bar')[1].value = tonumber(volume:sub(1, #volume-2))
        end)
    end,
}

awesome.connect_signal("volume::redraw_needed", function()
    volume_widget:update()
end)
awesome.connect_signal("microphone::redraw_needed", function()
    mic_widget:update()
end)

local function create()
    volume_widget:update()
    mic_widget:update()

    local sliders = {
        volume_widget,
        mic_widget,
        layout = wibox.layout.fixed.vertical,
        align = 'left',
        spacing = dpi(15),
        widget = wibox.container.place,
    }

    local container = wibox.widget {
        {
            {
                widget = wibox.container.place,
                halign = "center",
                valign = "center",
                forced_height = dpi(75),
                sliders
            },
            widget = wibox.container.background,
            bg = beautiful.bg_color_light,
            shape = gears.shape.rounded_rect
        },
        widget = wibox.container.margin,
        margins = {
            left = beautiful.dashboard_margin/2,
            right = beautiful.dashboard_margin/2,
            bottom = 0,
            top = beautiful.dashboard_margin/4,
        },
    }
    return container
end

return {
    create = create,
}
