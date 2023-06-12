local awful     = require("awful")
local beautiful = require("beautiful")
local gears     = require("gears")
local wibox     = require("wibox")
local dpi       = require("beautiful").xresources.apply_dpi

local markup    = require("helpers.markup")
local dashboard = require("modules.dashboard.init")

local spr       = wibox.widget.textbox(" ")

local cpu_temp  = wibox.widget.textbox()
local cpu_util  = wibox.widget.textbox()
awesome.connect_signal("evil::cpu", function(evil_cpu_util, evil_cpu_temp)
  cpu_temp.markup = markup(beautiful.main_color, evil_cpu_temp .. "°C")
  cpu_util.markup = markup(beautiful.main_color, evil_cpu_util .. "%")
end)

local gpu_util = wibox.widget.textbox()
local gpu_temp = wibox.widget.textbox()
awesome.connect_signal("evil::gpu", function(evil_gpu_util, evil_gpu_temp)
  gpu_temp.markup = markup(beautiful.main_color, evil_gpu_temp .. "°C")
  gpu_util.markup = markup(beautiful.main_color, evil_gpu_util .. "%")
end)


local disk_free = wibox.widget.textbox()
awesome.connect_signal("evil::disk_free", function(evil)
  disk_free.markup = markup(beautiful.accent_color, evil .. "gb")
end)

local ram_used = wibox.widget.textbox()
awesome.connect_signal("evil::ram", function(evil)
  local val = string.format("%.0f", evil)
  ram_used:set_markup(markup(beautiful.main_color, val .. "mb"))
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
  weather:set_markup(markup(beautiful.main_color, temp .. "°C"))
end)

local systray = wibox.widget {
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


local function create(s)
  local right_panel = awful.popup {
    screen = s,
    ontop = true,
    opacity = beautiful.opacity,
    bg = beautiful.bg_bar_outer,
    placement = function(c)
      awful.placement.top_right(c,
        { margins = { right = dpi(beautiful.useless_gap * 2), top = dpi(10) } })
    end,
    shape = beautiful.corners,
    widget =
    {
      {
        {
          {
            layout = wibox.layout.fixed.horizontal,
            align = "center",
            spr,
            spr,
            cpu_temp,
            spr,
            cpu_util,
            spr,
            gpu_temp,
            spr,
            gpu_util,
            spr,
            ram_used,
            spr,
            weather,
            spr,
            disk_free,
            spr,
          },
          spr,
          {
            layout = wibox.layout.fixed.horizontal,
            systray,
            spr,
            textclock,
            spr,
          },

          layout = wibox.layout.align.horizontal,
          align = "center",
          forced_height = beautiful.bar_height,
          shape = gears.shape.rect,
          forced_width = beautiful.panel_right_width,
        },
        bg            = beautiful.bg_bar_inner,
        shape         = beautiful.inner_corners,
        widget        = wibox.container.background,
        forced_height = dpi(30),
      },
      left   = dpi(5),
      right  = dpi(5),
      top    = dpi(5),
      bottom = dpi(5),
      widget = wibox.container.margin
    }
  }
  right_panel.buttons = gears.table.join(
    right_panel.buttons,
    awful.button({}, 1, function()
      dashboard.toggle()
    end)
  )
  return right_panel
end

return {
  create = create
}
