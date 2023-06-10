-------------------------------------------------------------------------------
-- Left panel: Clock and Weather                                             --
-------------------------------------------------------------------------------

local awful         = require("awful")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
-- local gfs       = require("gears.filesystem")
local wibox         = require("wibox")
local dpi           = require("beautiful").xresources.apply_dpi
local markup        = require("helpers.markup")

local CMD_WEATHER   = [[ echo "implement me =("  ]]
local CMD_CLOCK     = left_popup

local color_default = beautiful.bg_color
local color_hover   = beautiful.bg_color_light5
if beautiful.transparent_bar then
  color_default = beautiful.bg_color .. "0"
  color_hover   = beautiful.bg_color
end

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
local function createWidget(title, onclick_cmd, _color_default, color_accent, font, is_elemental)
  local container = wibox.widget {
    {
      {
        widget = wibox.widget.textbox,
        id = "text",
        text = "Error:" .. title,
        font = font
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
    -- shape         = gears.shape.powerline,
    onclick       = onclick_cmd,
    title         = title,
    color_default = _color_default,
    color_accent  = color_accent,
    forced_height = dpi(40),
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

local weather_widget = createWidget("", CMD_WEATHER, color_default, color_hover, beautiful.font)
awesome.connect_signal("evil::weather", function(evil)
  local temp = string.format("%.0f", evil.temp)
  weather_widget:update(beautiful.accent_color,
    temp .. "°C " .. beautiful.uwu_map[evil.weather[1].description] .. "")
end)

local clock_widget = createWidget("", CMD_CLOCK, color_default, color_hover,
  beautiful.font_name .. " 16", true)

awful.widget.watch("date +'%R'", 1, function(_, stdout)
  local day = os.date("%A")
  clock_widget:get_children_by_id('text')[1].markup =
      markup(beautiful.accent_alt_color, markup.bold(day .. ", " .. stdout:gsub("\n", "")))
end)

local function create(s)
  local panel = awful.popup {
    screen    = s,
    ontop     = true,
    opacity   = beautiful.opacity,
    -- bg        = bg_color,
    placement = function(c) awful.placement.top_left(c, { margins = { left = dpi(20), top = dpi(10) } }) end,
    shape     = beautiful.corners,
    widget    = {
      layout = wibox.layout.fixed.horizontal,
      clock_widget,
      weather_widget,
    }
  }
  return panel
end

return {
  create = create
}
