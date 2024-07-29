-------------------------------------------------------------------------------
-- Client Keybinds and Signals                                               --
-------------------------------------------------------------------------------
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")

local modkey = require("config.settings").modkey

clientkeys = gears.table.join(
  awful.key({ modkey }, "f", function(c)
    c.fullscreen = not c.fullscreen
    if c.fullscreen and c.class == "st" then
      c.opacity = 1
    elseif c.fullscreen == false and c.class == "st" then
      c.opacity = 1
    end
    c:raise()
  end, { description = "toggle fullscreen", group = "client" }),
  awful.key({ modkey }, "q", function(c)
    c:kill()
  end, { description = "close", group = "client" }),
  awful.key({ modkey }, "e", awful.client.floating.toggle, { description = "toggle floating", group = "client" }),
  awful.key({ modkey, "Control" }, "Return", function(c)
    c:swap(awful.client.getmaster())
  end, { description = "move to master", group = "client" }),
  awful.key({ modkey }, "o", function(c)
    c:move_to_screen()
  end, { description = "move to screen", group = "client" }),
  awful.key({ modkey }, "i", function(c)
    c.ontop = not c.ontop
  end, { description = "toggle keep on top", group = "client" }),
  awful.key({ modkey }, "n", function(c)
    -- The client currently has the input focus, so it cannot be
    -- minimized, since minimized clients can't have the focus.
    c.minimized = true
  end, { description = "minimize", group = "client" })
)

clientbuttons = gears.table.join(
  awful.button({}, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
  end),
  awful.button({ modkey }, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
    awful.mouse.client.move(c)
  end),
  awful.button({ modkey }, 3, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
    awful.mouse.client.resize(c)
  end)
)

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
  -- All clients will match this rule.
  {
    rule = {},
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen,
      size_hints_honor = false,
    },
  },

  -- Floating clients.
  -- {
  --     rule_any = {
  --         instance = {
  --             -- "example",
  --         },
  --         class = {
  --             "Sxiv",
  --         },
  --         name = {
  --             -- "example",
  --         },
  --         role = {
  --             "pop-up",
  --         }
  --     },
  --     properties = { floating = true }
  -- },

  -- Add titlebars to normal clients and dialogs
  {
    rule_any = { type = { "normal", "dialog" } },
    properties = { titlebars_enabled = true },
  },

  {
    rule = { class = "st" },
    properties = { opacity = 0.97 },
  },
}

client.connect_signal("manage", function(c)
  if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
  c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("property::urgent", function(c)
  c.minimized = false
  c:jump_to()
end)

client.connect_signal("focus", function(c)
  c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
  c.border_color = beautiful.border_normal
end)

client.connect_signal("manage", function(c)
  c.shape = beautiful.shape
end)
