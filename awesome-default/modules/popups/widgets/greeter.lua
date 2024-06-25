local awful     = require("awful")
local beautiful = require("beautiful")
local gears     = require("gears")
local wibox     = require("wibox")
local dpi       = beautiful.xresources.apply_dpi

local markup    = require("helpers.markup")

local uwu       = wibox.widget.textbox()

local uwuww     = "" ..
    '⢕⢕⢕⢕⢕⢕⣕⢕⢕⠕⠁⢕⢕⢕⢕⢕⢕⢕⢕⠅⡄⢕⢕⢕⢕⢕⢕⢕⢕⢕\n' ..
    '⢕⢕⢕⢕⢕⠅⢗⢕⠕⣠⠄⣗⢕⢕⠕⢕⢕⢕⠕⢠⣿⠐⢕⢕⢕⠑⢕⢕⠵⢕\n' ..
    '⢕⢕⢕⢕⠁⢜⠕⢁⣴⣿⡇⢓⢕⢵⢐⢕⢕⠕⢁⣾⢿⣧⠑⢕⢕⠄⢑⢕⠅⢕\n' ..
    '⢕⢕⠵⢁⠔⢁⣤⣤⣶⣶⣶⡐⣕⢽⠐⢕⠕⣡⣾⣶⣶⣶⣤⡁⢓⢕⠄⢑⢅⢑\n' ..
    '⠍⣧⠄⣶⣾⣿⣿⣿⣿⣿⣿⣷⣔⢕⢄⢡⣾⣿⣿⣿⣿⣿⣿⣿⣦⡑⢕⢤⠱⢐\n' ..
    '⢠⢕⠅⣾⣿⠋⢿⣿⣿⣿⠉⣿⣿⣷⣦⣶⣽⣿⣿⠈⣿⣿⣿⣿⠏⢹⣷⣷⡅⢐\n' ..
    '⣔⢕⢥⢻⣿⡀⠈⠛⠛⠁⢠⣿⣿⣿⣿⣿⣿⣿⣿⡀⠈⠛⠛⠁⠄⣼⣿⣿⡇⢔\n' ..
    '⢕⢕⢽⢸⢟⢟⢖⢖⢤⣶⡟⢻⣿⡿⠻⣿⣿⡟⢀⣿⣦⢤⢤⢔⢞⢿⢿⣿⠁⢕\n' ..
    '⢕⢕⠅⣐⢕⢕⢕⢕⢕⣿⣿⡄⠛⢀⣦⠈⠛⢁⣼⣿⢗⢕⢕⢕⢕⢕⢕⡏⣘⢕\n' ..
    '⢕⢕⠅⢓⣕⣕⣕⣕⣵⣿⣿⣿⣾⣿⣿⣿⣿⣿⣿⣿⣷⣕⢕⢕⢕⢕⡵⢀⢕⢕\n' ..
    '⢑⢕⠃⡈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢃⢕⢕⢕\n' ..
    '⣆⢕⠄⢱⣄⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⢁⢕⢕⠕⢁\n' ..
    '⣿⣦⡀⣿⣿⣷⣶⣬⣍⣛⣛⣛⡛⠿⠿⠿⠛⠛⢛⣛⣉⣭⣤⣂⢜⠕⢑⣡⣴⣿'

uwu.markup      =
    markup.fontfg(beautiful.font_name .. " 7", beautiful.accent_color, "\n") ..
    markup.fontfg(beautiful.font_name .. " 7", beautiful.accent_color, uwuww)

local font_name = beautiful.font_name

local function create()
  local hour = os.date("%H")
  local minutes = os.date("%M")
  local day = os.date("%A")

  local user = {
    {
      markup =
          markup.fontfg(font_name .. " 42", beautiful.accent_color, "" .. markup.bold(hour .. ":" .. minutes)) ..
          markup.fontfg(font_name .. " 30", beautiful.accent_color_dark, "\n" .. markup.bold(day)),
      widget = wibox.widget.textbox,
    },
    widget = wibox.container.margin,
    margins = {
      left = dpi(50),
      right = dpi(20),
      top = dpi(00),
    },
  }

  local image = {
    uwu,
    widget = wibox.container.margin,
    margins = {
      left = dpi(20),
      -- top = dpi(10),
      bottom = dpi(10)
    },
  }

  local greeter = wibox.widget {
    {
      {
        {
          layout = wibox.layout.fixed.horizontal,
          image,
          user,
          {
            layout = wibox.layout.align.vertical,
            -- clock,
            -- textclock,
          },
        },
        widget = wibox.container.place,
        halign = "left",
        valign = "center",
        forced_height = dpi(150),
        forced_width = dpi(480),
      },
      widget = wibox.container.background,
      -- bg = beautiful.bg_color_light,
      shape = gears.shape.rounded_rect
    },
    widget = wibox.container.margin,
    margins = {
      left = beautiful.dashboard_margin,
      right = beautiful.dashboard_margin,
      -- bottom = beautiful.dashboard_margin,
      top = beautiful.dashboard_margin,
    },
  }

  greeter.buttons = gears.table.join(
    greeter.buttons,
    awful.button({}, 1, function()
      awesome.emit_signal("dashboard::mouse1")
    end),
    awful.button({}, 3, function()
      awesome.emit_signal("dashboard::mouse3")
    end))

  return greeter
end

return {
  create = create
}
