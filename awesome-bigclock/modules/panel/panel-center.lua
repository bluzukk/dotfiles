local awful             = require("awful")
local beautiful         = require("beautiful")
local wibox             = require("wibox")
local dpi               = require("beautiful").xresources.apply_dpi
local markup            = require("helpers.markup")

local CMD_MAIL_IMS      = beautiful.terminal .. " -e neomutt -F ~/Sync/Rice/_private/mail-muttrcIMS"
local CMD_MAIL_MAIN     = beautiful.terminal .. " -e neomutt -F ~/Sync/Rice/_private/mail-muttrcUni"

local mail_main         = wibox.widget.textbox()
mail_main.forced_height = dpi(48)
mail_main.visible       = false
mail_main:connect_signal("button::press", function()
  awful.spawn(CMD_MAIL_MAIN)
  mail_main.visible = false
end)
awesome.connect_signal("evil::mail_main", function(evil)
  if evil ~= "nop" then
    mail_main:set_markup(markup(beautiful.accent_color, evil))
    mail_main.visible = true
  else
    mail_main.visible = false
  end
end)

local mail_ims = wibox.widget.textbox()
mail_ims.forced_height = dpi(48)
mail_ims.visible = false
mail_ims:connect_signal("button::press", function()
  awful.spawn(CMD_MAIL_IMS)
  mail_ims.visible = false
end)
awesome.connect_signal("evil::mail_ims", function(evil)
  if evil ~= "nop" then
    mail_ims:set_markup(markup(beautiful.accent_color, evil))
    mail_ims.visible = true
  else
    mail_ims.visible = false
  end
end)

local spr   = wibox.widget.textbox(" ")

local panel = awful.popup({
  screen = s,
  ontop = true,
  opacity = beautiful.opacity,
  -- bg        = bg_color,
  placement = function(c)
    awful.placement.top(c, { margins = { top = dpi(15) } })
  end,
  shape = beautiful.corners,
  widget = {
    -- tasklist,
    mail_main,
    mail_ims,
    widget = wibox.layout.fixed.horizontal,
  },
})

return panel
