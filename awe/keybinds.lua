local awful = require("awful")
local cfg = require("beautiful")
local gears = require("gears")
local helpers = require("helpers.util")
require("awful.autofocus")

local modkey = cfg.modkey
local altkey = cfg.altkey

-- Mouse bindings
root.buttons(gears.table.join(
	awful.button({}, 3, function()
		awful.spawn(cfg.terminal .. " " .. cfg.shell)
		LEFT_POPUP.toggle()
	end),
	awful.button({}, 4, awful.tag.viewnext),
	awful.button({}, 5, awful.tag.viewprev),
	awful.button({ modkey }, 4, function()
		helpers.useless_gaps_resize(-10)
	end),
	awful.button({ modkey }, 5, function()
		helpers.useless_gaps_resize(10)
	end)
))

-- Global Key bindings
globalkeys = gears.table.join(
	-- User programs
	awful.key({ modkey }, "t", function()
		awful.spawn(cfg.browser) -- open browser
	end),
	awful.key({ modkey }, "z", function()
		awful.spawn(cfg.browser_alt)
	end),
	awful.key({ modkey }, "Return", function()
		awful.spawn(cfg.terminal .. " " .. cfg.shell)
	end),
	awful.key({ modkey }, "F1", function()
		awful.spawn(cfg.mail_ims)
	end),
	awful.key({ modkey }, "F2", function()
		awful.spawn(cfg.mail_st)
	end),
	awful.key({ modkey }, "F4", function()
		PANEL.toggle_zenmode()
	end),
	awful.key({ modkey }, "space", function()
		PROMPT.launch()
	end),
	awful.key({ modkey }, "u", function()
		WALLPAPER_SELECTOR.show()
	end),

	-- Awesome things
	awful.key({ modkey, "Control" }, "r", awesome.restart),
	awful.key({ modkey, "Shift" }, "q", awesome.quit),

	-- Layout manipulation
	awful.key({ modkey }, "Left", function()
		awful.tag.incmwfact(-0.05)
	end),
	awful.key({ modkey }, "Right", function()
		awful.tag.incmwfact(0.05)
	end),
	awful.key({ modkey }, "Up", function()
		awful.client.incwfact(0.1)
	end),
	awful.key({ modkey }, "Down", function()
		awful.client.incwfact(-0.1)
	end),
	awful.key({ modkey, "Shift" }, "h", function()
		awful.tag.incnmaster(1, nil, true)
	end),
	awful.key({ modkey, "Shift" }, "l", function()
		awful.tag.incnmaster(-1, nil, true)
	end),
	awful.key({ modkey }, "Escape", function()
		awful.client.swap.byidx(1)
		awful.client.focus.byidx(1)
		helpers.showborder()
	end),

	-- Sticky client toggle
	awful.key({ modkey }, "s", function()
		client.focus.sticky = not client.focus.sticky
	end),

	-- Screen jumping
	awful.key({ modkey }, "dead_circumflex", function()
		awful.screen.focus_relative(1)
	end),

	-- Client jumping
	awful.key({ modkey }, "Tab", function()
		awful.client.focus.byidx(1)
		helpers.showborder()
	end),

	-- Restore minimized client
	awful.key({ modkey }, "m", function()
		local c = awful.client.restore()
		if c then
			client.focus = c
			c:raise()
		end
	end),

	-- ALSA volume control
	awful.key({}, "XF86AudioRaiseVolume", function()
		os.execute(string.format("amixer -q sset %s 3%%+", "Master"))
		awesome.emit_signal("volume::redraw_needed")
	end),
	awful.key({}, "XF86AudioLowerVolume", function()
		os.execute(string.format("amixer -q sset %s 3%%-", "Master"))
		awesome.emit_signal("volume::redraw_needed")
	end),
	awful.key({ altkey }, "XF86AudioRaiseVolume", function()
		os.execute(string.format("amixer -q sset %s 3%%+", "Capture"))
		awesome.emit_signal("microphone::redraw_needed")
	end),
	awful.key({ altkey }, "XF86AudioLowerVolume", function()
		os.execute(string.format("amixer -q sset %s 3%%-", "Capture"))
		awesome.emit_signal("microphone::redraw_needed")
	end),
	awful.key({ altkey }, "Up", function()
		os.execute(string.format("amixer -q sset %s 3%%+", "Master"))
		awesome.emit_signal("volume::redraw_needed")
	end),
	awful.key({ altkey }, "Down", function()
		os.execute(string.format("amixer -q sset %s 3%%-", "Master"))
		awesome.emit_signal("volume::redraw_needed")
	end),
	awful.key({ altkey }, "m", function()
		os.execute(string.format("amixer -q set %s toggle", "Master"))
	end),

	-- Brightness
	awful.key({}, "XF86MonBrightnessUp", function()
		os.execute("xbacklight -inc 2")
	end),
	awful.key({}, "XF86MonBrightnessDown", function()
		os.execute("xbacklight -dec 2")
	end)
)

for i = 1, 3 do
	globalkeys = gears.table.join(
		globalkeys,
		-- View tag only.
		awful.key({ modkey }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				tag:view_only()
			end
		end),
		-- Toggle tag display.
		awful.key({ modkey, "Control" }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end),
		-- Move client to tag.
		awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end),
		-- Toggle tag on focused client.
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end),

		awful.key({ modkey, "Control" }, "Up", function()
			helpers.useless_gaps_resize(-5)
		end),
		awful.key({ modkey, "Control" }, "Down", function()
			helpers.useless_gaps_resize(5)
		end)
	)
end
-- Set globalkeys
root.keys(globalkeys)

-- General Awesome keys
-- awful.keyboard.append_global_keybindings({
-- 	awful.key({ modkey }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
-- 	awful.key({ modkey }, "w", function()
-- 		mymainmenu:show()
-- 	end, { description = "show main menu", group = "awesome" }),
-- 	awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
-- 	awful.key({ modkey, "Shift" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),
-- 	awful.key({ modkey }, "x", function()
-- 		awful.prompt.run({
-- 			prompt = "Run Lua code: ",
-- 			textbox = awful.screen.focused().mypromptbox.widget,
-- 			exe_callback = awful.util.eval,
-- 			history_path = awful.util.get_cache_dir() .. "/history_eval",
-- 		})
-- 	end, { description = "lua execute prompt", group = "awesome" }),
-- 	awful.key({ modkey }, "Return", function()
-- 		awful.spawn(terminal)
-- 	end, { description = "open a terminal", group = "launcher" }),
-- 	awful.key({ modkey }, "r", function()
-- 		awful.screen.focused().mypromptbox:run()
-- 	end, { description = "run prompt", group = "launcher" }),
-- 	awful.key({ modkey }, "p", function()
-- 		menubar.show()
-- 	end, { description = "show the menubar", group = "launcher" }),
-- })
--
-- -- Tags related keybindings
-- awful.keyboard.append_global_keybindings({
-- 	awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
-- 	awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),
-- 	awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),
-- })
--
-- -- Focus related keybindings
-- awful.keyboard.append_global_keybindings({
-- 	awful.key({ modkey }, "j", function()
-- 		awful.client.focus.byidx(1)
-- 	end, { description = "focus next by index", group = "client" }),
-- 	awful.key({ modkey }, "k", function()
-- 		awful.client.focus.byidx(-1)
-- 	end, { description = "focus previous by index", group = "client" }),
-- 	awful.key({ modkey }, "Tab", function()
-- 		awful.client.focus.history.previous()
-- 		if client.focus then
-- 			client.focus:raise()
-- 		end
-- 	end, { description = "go back", group = "client" }),
-- 	awful.key({ modkey, "Control" }, "j", function()
-- 		awful.screen.focus_relative(1)
-- 	end, { description = "focus the next screen", group = "screen" }),
-- 	awful.key({ modkey, "Control" }, "k", function()
-- 		awful.screen.focus_relative(-1)
-- 	end, { description = "focus the previous screen", group = "screen" }),
-- 	awful.key({ modkey, "Control" }, "n", function()
-- 		local c = awful.client.restore()
-- 		-- Focus restored client
-- 		if c then
-- 			c:activate({ raise = true, context = "key.unminimize" })
-- 		end
-- 	end, { description = "restore minimized", group = "client" }),
-- })
--
-- -- Layout related keybindings
-- awful.keyboard.append_global_keybindings({
-- 	awful.key({ modkey, "Shift" }, "j", function()
-- 		awful.client.swap.byidx(1)
-- 	end, { description = "swap with next client by index", group = "client" }),
-- 	awful.key({ modkey, "Shift" }, "k", function()
-- 		awful.client.swap.byidx(-1)
-- 	end, { description = "swap with previous client by index", group = "client" }),
-- 	awful.key({ modkey }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client", group = "client" }),
-- 	awful.key({ modkey }, "l", function()
-- 		awful.tag.incmwfact(0.05)
-- 	end, { description = "increase master width factor", group = "layout" }),
-- 	awful.key({ modkey }, "h", function()
-- 		awful.tag.incmwfact(-0.05)
-- 	end, { description = "decrease master width factor", group = "layout" }),
-- 	awful.key({ modkey, "Shift" }, "h", function()
-- 		awful.tag.incnmaster(1, nil, true)
-- 	end, { description = "increase the number of master clients", group = "layout" }),
-- 	awful.key({ modkey, "Shift" }, "l", function()
-- 		awful.tag.incnmaster(-1, nil, true)
-- 	end, { description = "decrease the number of master clients", group = "layout" }),
-- 	awful.key({ modkey, "Control" }, "h", function()
-- 		awful.tag.incncol(1, nil, true)
-- 	end, { description = "increase the number of columns", group = "layout" }),
-- 	awful.key({ modkey, "Control" }, "l", function()
-- 		awful.tag.incncol(-1, nil, true)
-- 	end, { description = "decrease the number of columns", group = "layout" }),
-- 	awful.key({ modkey }, "space", function()
-- 		awful.layout.inc(1)
-- 	end, { description = "select next", group = "layout" }),
-- 	awful.key({ modkey, "Shift" }, "space", function()
-- 		awful.layout.inc(-1)
-- 	end, { description = "select previous", group = "layout" }),
-- })
--
-- awful.keyboard.append_global_keybindings({
-- 	awful.key({
-- 		modifiers = { modkey },
-- 		keygroup = "numrow",
-- 		description = "only view tag",
-- 		group = "tag",
-- 		on_press = function(index)
-- 			local screen = awful.screen.focused()
-- 			local tag = screen.tags[index]
-- 			if tag then
-- 				tag:view_only()
-- 			end
-- 		end,
-- 	}),
-- 	awful.key({
-- 		modifiers = { modkey, "Control" },
-- 		keygroup = "numrow",
-- 		description = "toggle tag",
-- 		group = "tag",
-- 		on_press = function(index)
-- 			local screen = awful.screen.focused()
-- 			local tag = screen.tags[index]
-- 			if tag then
-- 				awful.tag.viewtoggle(tag)
-- 			end
-- 		end,
-- 	}),
-- 	awful.key({
-- 		modifiers = { modkey, "Shift" },
-- 		keygroup = "numrow",
-- 		description = "move focused client to tag",
-- 		group = "tag",
-- 		on_press = function(index)
-- 			if client.focus then
-- 				local tag = client.focus.screen.tags[index]
-- 				if tag then
-- 					client.focus:move_to_tag(tag)
-- 				end
-- 			end
-- 		end,
-- 	}),
-- 	awful.key({
-- 		modifiers = { modkey, "Control", "Shift" },
-- 		keygroup = "numrow",
-- 		description = "toggle focused client on tag",
-- 		group = "tag",
-- 		on_press = function(index)
-- 			if client.focus then
-- 				local tag = client.focus.screen.tags[index]
-- 				if tag then
-- 					client.focus:toggle_tag(tag)
-- 				end
-- 			end
-- 		end,
-- 	}),
-- 	awful.key({
-- 		modifiers = { modkey },
-- 		keygroup = "numpad",
-- 		description = "select layout directly",
-- 		group = "layout",
-- 		on_press = function(index)
-- 			local t = awful.screen.focused().selected_tag
-- 			if t then
-- 				t.layout = t.layouts[index] or t.layout
-- 			end
-- 		end,
-- 	}),
-- })
--
-- client.connect_signal("request::default_mousebindings", function()
-- 	awful.mouse.append_client_mousebindings({
-- 		awful.button({}, 1, function(c)
-- 			c:activate({ context = "mouse_click" })
-- 		end),
-- 		awful.button({ modkey }, 1, function(c)
-- 			c:activate({ context = "mouse_click", action = "mouse_move" })
-- 		end),
-- 		awful.button({ modkey }, 3, function(c)
-- 			c:activate({ context = "mouse_click", action = "mouse_resize" })
-- 		end),
-- 	})
-- end)
--
-- client.connect_signal("request::default_keybindings", function()
-- 	awful.keyboard.append_client_keybindings({
-- 		awful.key({ modkey }, "f", function(c)
-- 			c.fullscreen = not c.fullscreen
-- 			c:raise()
-- 		end, { description = "toggle fullscreen", group = "client" }),
-- 		awful.key({ modkey, "Shift" }, "c", function(c)
-- 			c:kill()
-- 		end, { description = "close", group = "client" }),
-- 		awful.key(
-- 			{ modkey, "Control" },
-- 			"space",
-- 			awful.client.floating.toggle,
-- 			{ description = "toggle floating", group = "client" }
-- 		),
-- 		awful.key({ modkey, "Control" }, "Return", function(c)
-- 			c:swap(awful.client.getmaster())
-- 		end, { description = "move to master", group = "client" }),
-- 		awful.key({ modkey }, "o", function(c)
-- 			c:move_to_screen()
-- 		end, { description = "move to screen", group = "client" }),
-- 		awful.key({ modkey }, "t", function(c)
-- 			c.ontop = not c.ontop
-- 		end, { description = "toggle keep on top", group = "client" }),
-- 		awful.key({ modkey }, "n", function(c)
-- 			-- The client currently has the input focus, so it cannot be
-- 			-- minimized, since minimized clients can't have the focus.
-- 			c.minimized = true
-- 		end, { description = "minimize", group = "client" }),
-- 		awful.key({ modkey }, "m", function(c)
-- 			c.maximized = not c.maximized
-- 			c:raise()
-- 		end, { description = "(un)maximize", group = "client" }),
-- 		awful.key({ modkey, "Control" }, "m", function(c)
-- 			c.maximized_vertical = not c.maximized_vertical
-- 			c:raise()
-- 		end, { description = "(un)maximize vertically", group = "client" }),
-- 		awful.key({ modkey, "Shift" }, "m", function(c)
-- 			c.maximized_horizontal = not c.maximized_horizontal
-- 			c:raise()
-- 		end, { description = "(un)maximize horizontally", group = "client" }),
-- 	})
-- end)
