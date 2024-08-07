-------------------------------------------------------------------------------
-- Client Keybinds and Signals                                               --
-------------------------------------------------------------------------------
local awful = require("awful")
local cfg = require("beautiful")
local gears = require("gears")
local helpers = require("helpers.util")
local modkey = require("config.settings").modkey

clientkeys = gears.table.join(

	awful.key({ modkey }, "f", function(c)
		c.fullscreen = not c.fullscreen
		if c.fullscreen and c.class == "kitty" then
			c.opacity = 1
		elseif c.fullscreen == false and c.class == "kitty" then
			c.opacity = 0.975
		end
		c:raise()
	end),

	awful.key({ modkey }, "q", function(c)
		c:kill()
	end),

	awful.key({ modkey }, "e", awful.client.floating.toggle),

	awful.key({ modkey, "Control" }, "Return", function(c)
		c:swap(awful.client.getmaster())
	end),

	-- move client to other screen
	awful.key({ modkey }, "o", function(c)
		c:move_to_screen()
	end),

	-- client alway on top
	-- awful.key({ modkey }, "i", function(c)
	-- 	c.ontop = not c.ontop
	-- end),

	awful.key({ modkey }, "n", function(c)
		c.minimized = true
	end)
)

clientbuttons = gears.table.join(
	awful.button({}, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
	end),
	awful.button({ modkey }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.move()
	end),
	awful.button({ modkey }, 3, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.resize(c)
	end),
	awful.button({ modkey }, 4, function()
		helpers.useless_gaps_resize(-10)
	end),
	awful.button({ modkey }, 5, function()
		helpers.useless_gaps_resize(10)
	end)
	-- awful.button({ modkey }, 1, function(c)
	-- 	c:emit_signal("request::activate", "mouse_click", { raise = true })
	-- 	awful.mouse.client.move(c)
	-- c.floating = true
	-- end)
)

awful.rules.rules = {
	-- All clients will match this rule.
	{
		rule = {},
		properties = {
			border_width = cfg.border_width,
			border_color = cfg.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
			size_hints_honor = false,
		},
	},
	{
		rule_any = { type = { "normal", "dialog" } },
		properties = { titlebars_enabled = true },
	},

	{
		rule = { class = "kitty" },
		properties = { opacity = 0.975 },
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

-- client.connect_signal("mouse::enter", function(c)
-- 	Show_Warning("mouse::enter")
-- end)
-- client.connect_signal("mouse::leave", function(c)
-- 	-- c.floating = false
-- end)
-- client.connect_signal("button::release", function(c)
-- 	Show_Warning("button::release")
-- end)
-- client.connect_signal("button::press", function(c)
-- 	c.floating = true
-- end)
-- client.connect_signal("mouse::move", function(c)
-- 	Show_Warning("mouse::move")
-- end)

client.connect_signal("property::urgent", function(c)
	c.minimized = false
	c:jump_to()
end)

client.connect_signal("focus", function(c)
	c.border_color = cfg.border_focus
end)
client.connect_signal("unfocus", function(c)
	c.border_color = cfg.border_normal
end)

client.connect_signal("manage", function(c)
	c.shape = cfg.shape
end)
