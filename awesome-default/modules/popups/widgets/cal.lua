local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local dpi = beautiful.xresources.apply_dpi

local date = os.date("*t")
local current_month = date.month

local container

local function update() end

local function create()
  local cal = {
    date = date,
    spacing = 2,
    widget = wibox.widget.calendar.month,
    fn_embed = function(widget, flag)
      widget.font = beautiful.font_name .. " 17"

      local colors = {
        header = beautiful.accent_color,
        focus = current_month == date.month and beautiful.accent_color,
        weekday = beautiful.accent_alt_color,
        normal = beautiful.main_color,
      }

      local color = colors[flag] or beautiful.main_color

      return {
        {
          widget,
          margins = dpi(5),
          widget = wibox.container.margin,
        },
        -- bg = flag == 'focus'
        --     and current_month == date.month
        --     and beautiful.accent_color,
        fg = color,
        widget = wibox.container.background,
        shape = flag == "focus" and gears.shape.rect,
      }
    end,
  }

  container = {
    {
      {
        widget = wibox.container.place,
        halign = "center",
        valign = "center",
        bg = beautiful.accent_color,
        cal,
      },
      forced_height = dpi(350),
      forced_width = dpi(400),
      widget = wibox.container.background,
      -- bg = beautiful.bg_color_light,
      shape = gears.shape.rounded_rect,
    },
    widget = wibox.container.margin,
    margins = {
      left = beautiful.dashboard_margin,
      right = beautiful.dashboard_margin,
      bottom = beautiful.dashboard_margin,
      top = beautiful.dashboard_margin,
    },
  }

  -- Mouse bindings
  local function switch_month(i)
    date.month = date.month + i
    update()
  end

  container.buttons = gears.table.join(
    container.buttons,
    awful.button({}, 1, function()
      switch_month(1)
      awesome.emit_signal("dashboard::redraw_needed")
    end),
    awful.button({}, 3, function()
      switch_month(-1)
      awesome.emit_signal("dashboard::redraw_needed")
    end)
  )

  return container
end

local function reset()
  date = os.date("*t")
end

return {
  create = create,
  reset = reset,
}
