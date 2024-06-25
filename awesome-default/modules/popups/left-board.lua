local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local dpi = beautiful.xresources.apply_dpi

-- Dashboard Modules
local greeter = require("modules.popups.widgets.greeter")
local weather = require("modules.popups.widgets.weather")
local calendar = require("modules.popups.widgets.cal")
-- local sliders = require("modules.popups.widgets.sliders")
-- local notes = require("modules.popups.widgets.notes")
-- local system = require("modules.popups.widgets.system")
-- local powermenu = require("modules.popups.widgets.powermenu")
local linkz = require("modules.popups.widgets.links")


local greet = greeter.create()
local cal = calendar.create()
-- local slider = sliders.create()
-- local todo = notes.create()
-- local htop = system.create()
-- local powrmenu = powermenu.create()
local links = linkz.create()

local weather_widget
if weather ~= -1 then
  weather_widget = weather()
end

local is_sticky = false
local board = awful.popup({
  widget = {},
  border_color = beautiful.border_focus,
  border_width = 0 or beautiful.border_width,
  placement = function(c)
    awful.placement.left(c, { margins = { left = dpi(20), top = dpi(60) } })
  end,
  shape = beautiful.corners,
  ontop = true,
  visible = false,
  opacity = 1,
  bg = beautiful.bg_color,
})

-- local tasklist_buttons = gears.table.join(awful.button({}, 1, function(c)
--   c:emit_signal("request::activate", "tasklist", { raise = true })
-- end))

-- local function createContainer(widget)
--   return wibox.widget({
--     {
--       {
--         widget,
--         widget = wibox.container.place,
--         halign = "center",
--         valign = "center",
--         forced_height = dpi(100),
--         -- forced_width = dpi(450),
--       },
--       widget = wibox.container.background,
--       bg = beautiful.bg_color_light,
--       shape = gears.shape.rounded_rect,
--     },
--     widget = wibox.container.margin,
--     margins = {
--       left = beautiful.dashboard_margin,
--       right = beautiful.dashboard_margin,
--       bottom = beautiful.dashboard_margin,
--       top = beautiful.dashboard_margin,
--     },
--   })
-- end

-- local day = os.date("%A")
-- local textclock = awful.widget.watch("date +'%R:%S'", 1, function(widget, stdout)
--   widget:set_markup(markup.fontfg(beautiful.font_name .. " 32", beautiful.accent_alt_color, markup.bold(stdout)))
-- end)
-- local clock = wibox.widget({
--   layout = wibox.layout.fixed.vertical,
--   {
--     widget = wibox.widget.textbox,
--     font = beautiful.font_name .. " 22",
--     markup = markup(beautiful.accent_color, markup.bold(day)),
--   },
--   textclock,
-- })
-- local clock = createContainer(clock)

-- local up = awful.widget.watch("uptime -p", 180, function(widget, stdout)
--   widget:set_markup(markup.fontfg(beautiful.font_name .. " 16", beautiful.accent_color, stdout))
-- end)
-- local uptime = createContainer(up)

local function update()
  greet = greeter.create()
  board.widget = wibox.widget({
    {
      {
        greet,
        weather_widget,
        -- cal,
        links,
        layout = wibox.layout.fixed.vertical,
      },
      layout = wibox.layout.fixed.horizontal,
      forced_width = dpi(510),
      forced_height = dpi(650),
    },
    widget = wibox.container.place,
  })
end

-- First time setup
update()

local function show()
  update()
  board.visible = true
end

local function hide()
  board.visible = false
  calendar.reset()
  cal = calendar.create()
end

local function toggle()
  if board.visible then
    hide()
  else
    show()
  end
end

-- Manage tabs and redraw callbacks
awesome.connect_signal("dashboard::redraw_needed", function()
  update()
end)

awesome.connect_signal("dashboard::mouse3", function()
  hide()
end)

local function isVisible()
  return board.visible
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
