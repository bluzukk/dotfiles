-------------------------------------------------------------------------------
-- Left panel: Clock and Weather                                             --
-------------------------------------------------------------------------------

local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
-- local gfs       = require("gears.filesystem")
local wibox = require("wibox")
local dpi = require("beautiful").xresources.apply_dpi
local markup = require("helpers.markup")

local CMD_MAIL_IMS = beautiful.terminal .. " -e neomutt -F ~/Sync/Rice/_private/mail-muttrcIMS"
local CMD_MAIL_MAIN = beautiful.terminal .. " -e neomutt -F ~/Sync/Rice/_private/mail-muttrcUni"

local color_default = beautiful.bg_color
local color_hover = beautiful.bg_color_light5
if beautiful.transparent_bar then
  color_default = beautiful.bg_color .. "0"
  color_hover = beautiful.bg_color
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
local function createWidget(onclick_cmd, _color_default, color_accent, font, is_elemental)
  local container = wibox.widget({
    {
      {
        widget = wibox.widget.textbox,
        id = "text",
        text = "NONE",
        font = font or beautiful.font,
      },
      widget = wibox.container.margin,
      margins = {
        left = dpi(16),
        right = dpi(16),
      },
      id = "margins",
    },
    widget = wibox.container.background,
    bg = _color_default or color_default,
    onclick = onclick_cmd,
    color_default = _color_default or color_default,
    color_accent = color_accent or color_hover,
    forced_height = dpi(40),
    update = function(self, color, content)
      self:get_children_by_id("text")[1].markup = markup(color, content)
    end,
    hide = function(self)
      self:get_children_by_id("text")[1].markup = ""
      self:get_children_by_id("margins")[1].margins = 0
      self.visible = false
    end,
  })
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
      awful.spawn.easy_async(self.onclick, function(evil)
        notification_show(evil, self.color_default)
      end)
    end
  end)
  container:hide()
  return container
end

-- local mail_main = createWidget(CMD_MAIL_MAIN)
-- awesome.connect_signal("evil::mail_main", function(evil)
--   if evil == "nop" then
--     mail_main:hide()
--   else
--     mail_main:update(beautiful.color_critical, evil)
--   end
-- end)
--
-- local mail_ims = createWidget(CMD_MAIL_IMS)
-- awesome.connect_signal("evil::mail_ims", function(evil)
--   if evil == "nop" then
--     mail_ims:hide()
--   else
--     mail_ims:update(beautiful.color_critical, evil)
--   end
-- end)

local mail_main = wibox.widget.textbox()
mail_main:connect_signal("button::press", function(_)
  awful.spawn(CMD_MAIL_MAIN)
end)
awesome.connect_signal("evil::mail_main", function(evil)
  if evil ~= "nop" then
    mail_main.forced_height = dpi(48)
    mail_main:set_markup(markup(beautiful.accent_color, evil))
  end
end)

local mail_ims = wibox.widget.textbox()
mail_ims:connect_signal("button::press", function(_)
  awful.spawn(CMD_MAIL_IMS)
end)
awesome.connect_signal("evil::mail_ims", function(evil)
  if evil ~= "nop" then
    mail_ims.forced_height = dpi(48)
    mail_ims:set_markup(markup(beautiful.accent_color, evil))
  end
end)

-- local playerctl_widget = require("modules.playerctl.panel-widget")

local function create(s)
  local panel = awful.popup({
    screen = s,
    ontop = true,
    opacity = beautiful.opacity,
    -- bg        = bg_color,
    placement = function(c)
      awful.placement.top(c, { margins = { top = beautiful.useless_gap } })
    end,
    shape = beautiful.corners,
    widget = {
      -- playerctl_widget,
      mail_main,
      mail_ims,
      widget = wibox.layout.fixed.horizontal,
    },
  })
  return panel
end

return {
  create = create,
}
