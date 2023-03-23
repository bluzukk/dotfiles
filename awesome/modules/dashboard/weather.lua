local awful            = require("awful")
local watch            = require("awful.widget.watch")
local json             = require("helpers.json")
local naughty          = require("naughty")
local wibox            = require("wibox")
local gears            = require("gears")
local beautiful        = require("beautiful")
local markup           = require("helpers.markup")
local gfs              = require("gears.filesystem")

local util             = require("helpers.util")
local config           = require("config.settings")

local xresources       = require("beautiful.xresources")
local dpi              = xresources.apply_dpi

local ICONS_DIR_UWU    = gfs.get_configuration_dir() .. "assets/weather-underground-icons/"
local GET_FORECAST_CMD = [[bash -c "curl -s --show-error -X GET '%s'"]]

local LAT              = util.read_line(LAT)
if not LAT then
    Print("Weather: latitude missing")
    return -1
end

local LONG = util.read_line(LONG)
if not LONG then
    Print("Weather: longtiude missing")
    return -1
end

local API = util.read_line(API_KEY)
if not API then
    Print("Weather: API-Key missing")
    return -1
end

local LCLE = {
    warning_title = "Weather Widget",
    parameter_warning = "Required parameters are not set: ",
    feels_like = "  but feels like ",
    wind = "Wind: ",
    humidity = "Humidity: ",
    uv = "UV: "
}

local function show_warning(message)
    naughty.notify {
        preset = naughty.config.presets.critical,
        title = LCLE.warning_title,
        text = message
    }
end


local weather_widget = {}
local warning_shown = false
local tooltip = awful.tooltip {
    mode = 'outside',
    preferred_positions = { 'bottom' }
}

local icon_map = {
    ["01d"] = "clear-sky",
    ["02d"] = "few-clouds",
    ["03d"] = "scattered-clouds",
    ["04d"] = "broken-clouds",
    ["09d"] = "shower-rain",
    ["10d"] = "rain",
    ["11d"] = "thunderstorm",
    ["13d"] = "snow",
    ["50d"] = "mist",
    ["01n"] = "clear-sky-night",
    ["02n"] = "few-clouds-night",
    ["03n"] = "scattered-clouds-night",
    ["04n"] = "broken-clouds-night",
    ["09n"] = "shower-rain-night",
    ["10n"] = "rain-night",
    ["11n"] = "thunderstorm-night",
    ["13n"] = "snow-night",
    ["50n"] = "mist-night"
}

local function gen_temperature_str(temp, fmt_str)
    local temp_str = string.format(fmt_str, temp)
    local s = temp_str .. '°C'
    return s
end

local separator_vertical = wibox.widget {
    widget = wibox.widget.separator,
    orientation = "vertical",
    span_ratio = 1,
    thickness = dpi(10),
    color = beautiful.bg_color
}

local separator_horizontal = wibox.widget {
    widget = wibox.widget.separator,
    orientation = "horizontal",
    span_ratio = 1,
    thickness = dpi(2),
    color = beautiful.bg_color
}

local tab = true
local result = ""

local function worker(user_args)
    --- Validate required parameters
    local api_key = API
    local font_name = beautiful.font_name
    local units = 'metric'
    local icons_extension = '.png'
    local timeout = 600

    local owm_one_cal_api =
    ('https://api.openweathermap.org/data/2.5/onecall' ..
    '?lat=' .. LAT .. '&lon=' .. LONG .. '&appid=' .. api_key ..
    '&units=' .. units .. '&exclude=minutely' ..
    (show_daily_forecast == false and ',daily' or '') ..
    '&lang=en')

    local daily_forecast_widget_one = {
        layout = wibox.layout.flex.horizontal,
        update = function(self, forecast, timezone_offset)
            local count = #self
            for i = 0, count do self[i] = nil end
            for i, day in ipairs(forecast) do
                local img = ICONS_DIR_UWU .. icon_map[day.weather[1].icon] .. icons_extension
                img = gears.color.recolor_image(img, beautiful.accent_color)
                if i > 3 then break end

                local day_forecast = wibox.widget {
                    {
                        text = " ",
                        align = 'center',
                        font = font_name .. ' 6',
                        widget = wibox.widget.textbox
                    },
                    {
                        markup = markup(beautiful.accent_alt_color,
                        os.date('%a', tonumber(day.dt) + tonumber(timezone_offset))),
                        align = 'center',
                        font = font_name .. ' 13',
                        widget = wibox.widget.textbox
                    },
                    {
                        {
                            {
                                image = img,
                                resize = true,
                                forced_width = 36,
                                forced_height = 36,
                                widget = wibox.widget.imagebox
                            },
                            align = 'center',
                            layout = wibox.container.place
                        },
                        layout = wibox.layout.fixed.vertical
                    },
                    {
                        {
                            markup = markup(beautiful.main_color, gen_temperature_str(day.temp.day, '%.0f', false, units)),
                            align = 'center',
                            font = font_name .. ' 12',
                            widget = wibox.widget.textbox
                        },
                        {
                            markup = markup(beautiful.main_color,
                            gen_temperature_str(day.temp.night, '%.0f', false, units)),
                            align = 'center',
                            font = font_name .. ' 12',
                            widget = wibox.widget.textbox
                        },
                        layout = wibox.layout.fixed.vertical
                    },
                    spacing = 3,
                    layout = wibox.layout.fixed.vertical
                }
                table.insert(self, day_forecast)
            end
        end
    }

    local daily_forecast_widget_two = {
        layout = wibox.layout.flex.horizontal,
        update = function(self, forecast, timezone_offset)
            local count = #self
            for i = 0, count do self[i] = nil end
            for i, day in ipairs(forecast) do
                local img = ICONS_DIR_UWU .. icon_map[day.weather[1].icon] .. icons_extension
                img = gears.color.recolor_image(img, beautiful.accent_color)
                if i > 3 and i < 7 then

                    local day_forecast = wibox.widget {
                        {
                            text = " ",
                            align = 'center',
                            font = font_name .. ' 6',
                            widget = wibox.widget.textbox
                        },
                        {
                            markup = markup(beautiful.accent_alt_color,
                            os.date('%a', tonumber(day.dt) + tonumber(timezone_offset))),
                            align = 'center',
                            font = font_name .. ' 13',
                            widget = wibox.widget.textbox
                        },
                        {
                            {
                                {
                                    image = img,
                                    resize = true,
                                    forced_width = 36,
                                    forced_height = 36,
                                    widget = wibox.widget.imagebox
                                },
                                align = 'center',
                                layout = wibox.container.place
                            },
                            layout = wibox.layout.fixed.vertical
                        },
                        {
                            {
                                markup = markup(beautiful.main_color, gen_temperature_str(day.temp.day, '%.0f', false, units)),
                                align = 'center',
                                font = font_name .. ' 12',
                                widget = wibox.widget.textbox
                            },
                            {
                                markup = markup(beautiful.main_color,
                                gen_temperature_str(day.temp.night, '%.0f', false, units)),
                                align = 'center',
                                font = font_name .. ' 12',
                                widget = wibox.widget.textbox
                            },
                            layout = wibox.layout.fixed.vertical
                        },
                        spacing = 3,
                        layout = wibox.layout.fixed.vertical
                    }
                    table.insert(self, day_forecast)
                end
            end
        end
    }

    local spr = wibox.widget.textbox("   ")
    local current_weather_widget = wibox.widget {
        {
            spr,
            {
                id = 'icon',
                resize = true,
                widget = wibox.widget.imagebox,
                forced_width = dpi(56),
                forced_height = dpi(56)
            },
            {
                id = "temp",
                align = 'left',
                widget = wibox.widget.textbox,
                -- forced_height = dpi(30),
            },
            align = 'center',
            layout = wibox.layout.fixed.horizontal
        },
        {
            id = "description",
            align = 'center',
            font = beautiful.font_name .. " 13",
            widget = wibox.widget.textbox,
        },
        {
            font = beautiful.font_name .. " 12",
            id = "feels_like_temp",
            align = 'center',
            widget = wibox.widget.textbox,
        },
        layout = wibox.layout.fixed.vertical,
        update = function(self, weather)
            self:get_children_by_id('temp')[1]:set_markup(markup.fontfg(beautiful.font_name .. " 18",
            beautiful.accent_color, "<b>  " .. gen_temperature_str(weather.temp, '%.0f', false, units) .. "</b>"))
            self:get_children_by_id('feels_like_temp')[1]:set_markup(markup(beautiful.accent_color_dark,
            LCLE.feels_like .. gen_temperature_str(weather.feels_like, '%.0f', false, units)))
            self:get_children_by_id('description')[1]:set_markup(markup(beautiful.accent_color,
            beautiful.uwu_map[weather.weather[1].description]))
            -- Print(weather.weather[1].description)
            local image = ICONS_DIR_UWU .. icon_map[weather.weather[1].icon] .. icons_extension
            image = gears.color.recolor_image(image, beautiful.accent_alt_color)
            self:get_children_by_id('icon')[1]:set_image(image)
        end
    }

    weather_widget = wibox.widget {
        widget = wibox.container.margin
    }


    local function update_widget(widget, stdout, stderr)
        if stderr ~= '' then
            if not warning_shown then
                if (stderr ~= 'curl: (52) Empty reply from server'
                    and stderr ~= 'curl: (28) Failed to connect to api.openweathermap.org port 443: Connection timed out'
                    and stderr:find('^curl: %(18%) transfer closed with %d+ bytes remaining to read$') ~= nil
                    ) then
                    show_warning(stderr)
                end
                warning_shown = true
                tooltip:add_to_object(widget)
            end
            return
        end

        warning_shown = false
        if stdout ~= "" then
            tooltip:remove_from_object(widget)
            result = json.decode(stdout)
        end

        awesome.emit_signal("evil::weather", result.current)
        current_weather_widget:update(result.current)
        daily_forecast_widget_one:update(result.daily, result.timezone_offset)
        daily_forecast_widget_two:update(result.daily, result.timezone_offset)

        local upper_widget = current_weather_widget
        local lower_widget = daily_forecast_widget_one
        if not tab then
            upper_widget = daily_forecast_widget_two
            lower_widget = daily_forecast_widget_one
        end


        widget:setup(
        {
            {
                {
                    layout = wibox.layout.fixed.vertical,
                    spr,
                    lower_widget,
                    spr,
                    upper_widget,
                },
                widget = wibox.container.background,
                bg = beautiful.bg_color_light,
                shape = gears.shape.rounded_rect,
            },
            forced_height = dpi(145),
            widget = wibox.container.margin,
            margins = {
                left = config.dashboard_margin,
                right = config.dashboard_margin,
                bottom = config.dashboard_margin,
                top = config.dashboard_margin,
            },
        })
    end

    watch(
    string.format(GET_FORECAST_CMD, owm_one_cal_api),
    2000, -- API limit is 1k req/day; day has 1440 min; every 2 min is good
    update_widget, weather_widget
    )

    weather_widget:buttons(gears.table.join(awful.button({}, 1, function()
        tab = not tab
        update_widget(weather_widget, "", "")
    end)))

    return weather_widget
end

return setmetatable(weather_widget, { __call = function(_, ...) return worker(...) end })
