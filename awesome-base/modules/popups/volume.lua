-------------------------------------------------------------------------------
-- Popup indicating speaker and microphone volume changes                    --
-------------------------------------------------------------------------------
local awful         = require("awful")
local beautiful     = require("beautiful")
local gears         = require("gears")
local wibox         = require("wibox")
local dpi           = beautiful.xresources.apply_dpi
local util          = require("helpers.util")

local CMD_GET_VOL   = [[ bash -c "volume" ]]
local CMD_GET_MIC   = [[ bash -c "microphone" ]]

local volume_popup  = awful.popup {
  widget       = {},
  border_color = beautiful.border_focus,
  border_width = 0 or beautiful.border_width,
  placement    = function(c) awful.placement.top(c, { margins = { top = dpi(10) } }) end,
  shape        = beautiful.corners,
  ontop        = true,
  visible      = false,
  opacity      = beautiful.opacity,
}

local volume_widget = wibox.widget {
  {
    {
      id               = "volume_bar",
      max_value        = 100,
      widget           = wibox.widget.progressbar,
      forced_width     = beautiful.panel_right_width * 0.67,
      background_color = beautiful.bg_color_light10,
      color            = beautiful.accent_color,
      margins          = {
        top = dpi(4),
        bottom = dpi(4),
        left = dpi(15),
        right = dpi(15),
      }
    },
    layout = wibox.layout.fixed.horizontal
  },
  forced_height = dpi(12),
  layout = wibox.layout.fixed.vertical,
  update = function(self)
    util.async(CMD_GET_VOL, function(volume)
      local vol = tonumber(volume:sub(1, #volume - 2))
      if vol == 100 then
        self:get_children_by_id('volume_bar')[1].color = beautiful.color_critical
      else
        self:get_children_by_id('volume_bar')[1].color = beautiful.accent_color
      end
      self:get_children_by_id('volume_bar')[1].value = vol
    end)
  end
}

local mic_widget    = wibox.widget {
  {
    {
      id               = "mic_bar",
      max_value        = 100,
      widget           = wibox.widget.progressbar,
      forced_width     = beautiful.panel_right_width * 0.67,
      background_color = beautiful.bg_color_light10,
      color            = beautiful.accent_alt_color,
      margins          = {
        top = dpi(4),
        bottom = dpi(4),
        left = dpi(15),
        right = dpi(15),
      }
    },
    layout = wibox.layout.fixed.horizontal
  },
  forced_height = dpi(12),
  layout = wibox.layout.fixed.vertical,
  update = function(self)
    util.async(CMD_GET_MIC, function(volume)
      local vol = tonumber(volume:sub(1, #volume - 2))
      if vol == 100 then
        self:get_children_by_id('mic_bar')[1].color = beautiful.color_critical
      else
        self:get_children_by_id('mic_bar')[1].color = beautiful.accent_alt_color
      end
      self:get_children_by_id('mic_bar')[1].value = vol
    end)
  end
}

awesome.connect_signal("volume::redraw_needed", function()
  volume_widget:update()
  volume_widget.visible = true
  mic_widget.visible    = false
end)
awesome.connect_signal("microphone::redraw_needed", function()
  mic_widget:update()
  volume_widget.visible = false
  mic_widget.visible    = true
end)

local sliders = {
  volume_widget,
  mic_widget,
  layout = wibox.layout.fixed.vertical,
  align = 'left',
  spacing = dpi(0),
  widget = wibox.container.place,
}

volume_popup.widget = wibox.widget {
  {
    {
      widget = wibox.container.place,
      halign = "center",
      valign = "center",
      forced_height = dpi(40),
      sliders
    },
    widget = wibox.container.background,
    bg = beautiful.bg_color,
    shape = gears.shape.rounded_rect
  },
  widget = wibox.container.margin,
  margins = {
    left = beautiful.dashboard_margin,
    right = beautiful.dashboard_margin,
    bottom = dpi(2),
    top = dpi(2),
  },
}

-- Show / Hide / Popup Logic
local popup_timer = gears.timer {
  timeout = 0.75,
}

local function popup()
  volume_popup.visible = true
  popup_timer:stop()
  popup_timer:start()
end
popup_timer:connect_signal("timeout", function()
  volume_popup.visible = false
  popup_timer:stop()
end)

return {
  popup = popup,
}
