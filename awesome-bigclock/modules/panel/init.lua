local awful          = require("awful")
local beautiful      = require("beautiful")
local gears          = require("gears")
local wibox          = require("wibox")
local dpi            = require("beautiful").xresources.apply_dpi

awful.layout.layouts = {
  awful.layout.suit.tile.right,
  awful.layout.suit.tile.right,
  awful.layout.suit.tile.right,
}

local tags           = { " ", " ", " " }

local function create_screens()
  awful.screen.connect_for_each_screen(function(s)
    awful.tag(tags, s, awful.layout.layouts)

    -- Zenmode taglist
    s.box         = require("modules.panel.zenmode").create_boxes(s)
    s.box.visible = false
    s.zenmode     = false

    s.mywibox     = awful.wibar {
      screen  = s,
      width   = dpi(100),
      height  = dpi(30),
      bg      = beautiful.accent_color .. "0",
      shape   = beautiful.corner,
      margins = {
        top = dpi(5),
        -- bottom = dpi(20),
      },
      widget  = {
        layout = wibox.layout.fixed.horizontal,
        align = "bottom",
        forced_height = beautiful.bar_height,
        shape = gears.shape.rect,
      }
    }
  end)
end

local function toggle_zenmode()
  for s in screen do
    s.zenmode     = not s.zenmode
    s.box.visible = not s.box.visible
    if beautiful.enable_one_bar then
      s.panel.visible = not s.panel.visible
    else
      awesome.emit_signal("zenmode", s.zenmode)
      s.mywibox.visible = not s.mywibox.visible
    end
  end
end

return {
  create_screens = create_screens,
  toggle_zenmode = toggle_zenmode
}
