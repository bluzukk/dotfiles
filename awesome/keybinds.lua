-- stylua: ignore start
local awful   = require("awful")
local cfg     = require("beautiful")
local gears   = require("gears")
local helpers = require("helpers.util")
require("awful.autofocus")

local modkey  = cfg.modkey
local altkey  = cfg.altkey

root.buttons(gears.table.join(
	awful.button({        }, 3, function() awful.spawn(cfg.terminal .. " " .. cfg.shell) end),
	awful.button({        }, 4, awful.tag.viewnext),
	awful.button({        }, 5, awful.tag.viewprev),
	awful.button({ modkey }, 4, function() helpers.useless_gaps_resize(-10) end),
	awful.button({ modkey }, 5, function() helpers.useless_gaps_resize(10)  end)
))

globalkeys = gears.table.join(
	awful.key({ modkey, "Control" }, "r", awesome.restart),
	awful.key({ modkey, "Shift" },   "q", awesome.quit),

	awful.key({ modkey }, "t",      function() awful.spawn(cfg.browser) end),
	awful.key({ modkey }, "Return", function() awful.spawn(cfg.terminal .. " " .. cfg.shell) end),
	awful.key({ modkey }, "F1",     function() awful.spawn(cfg.mail_ims) end),
	awful.key({ modkey }, "F2",     function() awful.spawn(cfg.mail_st) end),
	awful.key({ modkey }, "space",  function() PROMPT.launch() end),

	awful.key({ modkey }, "Left",   function() awful.tag.incmwfact(-0.05) end),
	awful.key({ modkey }, "Right",  function() awful.tag.incmwfact(0.05) end),
	awful.key({ modkey }, "Up",     function() awful.client.incwfact(0.1) end),
	awful.key({ modkey }, "Down",   function() awful.client.incwfact(-0.1) end),
	awful.key({ modkey }, "h",      function() awful.tag.incnmaster(1, nil, true) end),
	awful.key({ modkey }, "l",      function() awful.tag.incnmaster(-1, nil, true) end),
	awful.key({ modkey }, "Escape", function() awful.client.swap.byidx(1) awful.client.focus.byidx(1) helpers.showborder() end),
	awful.key({ modkey }, "Tab",    function() awful.client.focus.byidx(1) helpers.showborder() end),
	awful.key({ modkey }, "m",      function() awful.client.restore() end),
	awful.key({ modkey, "Control" }, "Up",   function() helpers.useless_gaps_resize(-5) end),
	awful.key({ modkey, "Control" }, "Down", function() helpers.useless_gaps_resize(5) end),
	awful.key({ modkey }, "dead_circumflex", function() awful.screen.focus_relative(1) end),


	awful.key({        }, "XF86AudioRaiseVolume", function() os.execute("amixer -q sset Master 3%+")  awesome.emit_signal("volume::redraw_needed") end),
	awful.key({        }, "XF86AudioLowerVolume", function() os.execute("amixer -q sset Master 3%-")  awesome.emit_signal("volume::redraw_needed") end),
	awful.key({ altkey }, "XF86AudioRaiseVolume", function() os.execute("amixer -q sset Capture 3%+") awesome.emit_signal("microphone::redraw_needed") end),
	awful.key({ altkey }, "XF86AudioLowerVolume", function() os.execute("amixer -q sset Capture 3%-") awesome.emit_signal("microphone::redraw_needed") end),
	awful.key({ altkey }, "Up",                   function() os.execute("amixer -q sset Master 3%+")  awesome.emit_signal("volume::redraw_needed") end),
	awful.key({ altkey }, "Down",                 function() os.execute("amixer -q sset Master 3%-")  awesome.emit_signal("volume::redraw_needed") end),
	awful.key({ altkey }, "m",                    function() os.execute("amixer -q set Master toggle") end),

	awful.key({}, "XF86MonBrightnessUp",   function() os.execute("xbacklight -inc 2") end),
	awful.key({}, "XF86MonBrightnessDown", function() os.execute("xbacklight -dec 2") end)
)

for i = 1, 3 do
	globalkeys = gears.table.join(
		globalkeys,
		awful.key({ modkey }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				tag:view_only()
			end
		end),
		awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end)
	)
end

root.keys(globalkeys)
