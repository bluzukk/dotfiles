local awful     = require("awful")
local beautiful = require("beautiful")
local gears     = require("gears")
local gfs       = require("gears.filesystem")
-- local naughty   = require("naughty")
local wibox     = require("wibox")
local dpi       = beautiful.xresources.apply_dpi

local markup    = require("helpers.markup")


local CMD_REBOOT       = [[ reboot  ]]
local CMD_PWROFF       = [[ poweroff ]]
local CMD_LOCK         = [[ st ]]

local ICONS_PATH       = gfs.get_configuration_dir() .. "assets/powermenu/"

-- Dont accidentally click
-- Use double click :)
local reboot_clicked   = false
local poweroff_clicked = false
local lock_clicked     = false

local timer_poweroff   = gears.timer {
  timeout = 0.2,
}
timer_poweroff:connect_signal("timeout", function()
  poweroff_clicked = false
  timer_poweroff:stop()
end)

local timer_reboot = gears.timer {
  timeout = 0.2,
}
timer_reboot:connect_signal("timeout", function()
  reboot_clicked = false
  timer_reboot:stop()
end)

local timer_lock = gears.timer {
  timeout = 0.2,
}
timer_lock:connect_signal("timeout", function()
  lock_clicked = false
  timer_lock:stop()
end)


local function create_button(text, icon_name)
  local img = gears.color.recolor_image(
    ICONS_PATH .. icon_name, beautiful.accent_alt_color)
  local button = wibox.widget
      -- {
      {
        {
          {
            -- wibox.widget.textbox(" "),
            {
              id            = "image",
              image         = img,
              resize        = true,
              widget        = wibox.widget.imagebox,
              forced_height = dpi(20),
            },
            -- {
            --     id = "text",
            --     font = beautiful.font_name .. " 14",
            --     markup = markup(beautiful.accent_color, " " .. text),
            --     widget = wibox.widget.textbox,
            --
            -- },
            --     layout = wibox.layout.fixed.horizontal,
            --     forced_width = beautiful.dashboard_width,
            -- },
            widget = wibox.container.place,
            halign = "center",
            valign = "center",
          },
          widget  = wibox.container.margin,
          margins = {
            left   = dpi(10),
            right  = dpi(10),
            bottom = dpi(6),
            top    = dpi(6),
          }
        },
        -- forced_width = dpi(60),
        widget = wibox.container.background,
        bg     = beautiful.bg_color_light,
        shape  = gears.shape.rounded_rect,

      }
  button:connect_signal("button::press", function(c) c:set_bg(beautiful.accent_color) end)
  button:connect_signal("button::release", function(c) c:set_bg(beautiful.bg_color) end)
  button:connect_signal("mouse::enter", function(c) c:set_bg(beautiful.bg_color_light10) end)
  button:connect_signal("mouse::leave", function(c) c:set_bg(beautiful.bg_color_light) end)
  return button
end

local function create()
  local poweroff_button   = create_button("", "shutdown.svg")
  local reboot_button     = create_button("", "reboot.svg")
  local lock_button       = create_button("", "lock.svg")

  -- local poweroff_button = create_button("Pwroff", "shutdown.svg")
  -- local reboot_button   = create_button("Rebo0t", "reboot.svg" )
  -- local lock_button     = create_button("L0ck", "lock.svg")
  --
  poweroff_button.buttons = gears.table.join(
    awful.button({}, 1, function()
      if poweroff_clicked then
        awful.spawn(CMD_PWROFF)
      end
      poweroff_clicked = true
      timer_poweroff:start()
    end)
  )
  reboot_button.buttons   = gears.table.join(
    awful.button({}, 1, function()
      if reboot_clicked then
        awful.spawn(CMD_REBOOT)
      end
      reboot_clicked = true
      timer_reboot:start()
    end)
  )
  lock_button.buttons     = gears.table.join(
    awful.button({}, 1, function()
      if lock_clicked then
        awful.spawn(CMD_LOCK)
      end
      lock_clicked = true
      timer_lock:start()
    end)
  )

  local powermenu         = wibox.widget {
    {
      layout = wibox.layout.fixed.horizontal,
      -- forced_width = dpi(100),
      spacing = dpi(10),
      lock_button,
      reboot_button,
      poweroff_button,
    },
    widget  = wibox.container.margin,
    margins = {
      -- left   = beautiful.dashboard_margin,
      right = beautiful.dashboard_margin,
      -- bottom = beautiful.dashboard_margin,
      top   = beautiful.dashboard_margin,
    }
  }
  return powermenu
end

return {
  create = create
}
