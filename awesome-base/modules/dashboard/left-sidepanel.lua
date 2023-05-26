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

local is_sticky = false
local dashboard = awful.popup {
  widget       = {},
  border_color = beautiful.border_focus,
  border_width = 0 or beautiful.border_width,
  placement    = function(c) awful.placement.top_left(c, { margins = { left = dpi(20), top = dpi(50) } }) end,
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
      left = beautiful.dashboard_margin,
      right = beautiful.dashboard_margin,
      bottom = beautiful.dashboard_margin,
      top = beautiful.dashboard_margin,
    },
  }
end

-- local hour = os.date("%H")
-- local minutes = os.date("%M")
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


local clock  = createContainer(clock)

local up     = awful.widget.watch("uptime -p", 180, function(widget, stdout)
  widget:set_markup(
    markup.fontfg(beautiful.font_name .. " 16", beautiful.accent_color, stdout))
end)

local uptime = createContainer(up)

local function update()
  greet = greeter.create()
  dashboard.widget = wibox.widget {
    {
      {
        cal,
        weather_widget,
        layout = wibox.layout.fixed.vertical
      },
      layout = wibox.layout.fixed.horizontal,
      forced_width = dpi(500),
      forced_height = dpi(800),
    },
    widget = wibox.container.place
  }
end

-- First time setup
update()

local function show()
  update()
  dashboard.visible = true
end

local function hide()
  dashboard.visible = false
  calendar.reset()
  cal = calendar.create()
end

local function toggle()
  if dashboard.visible then
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
