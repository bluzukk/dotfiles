-------------------------------------------------------------------------------
-- Global Keybinds and Tag Keys                                              --
-------------------------------------------------------------------------------
local awful     = require("awful")
local beautiful = require("beautiful")
local gears     = require("gears")
require("awful.autofocus")

local pywal        = require("modules.pywal")
local uwuprompt    = require("modules.prompt")
local volume       = require("modules.popups.volume")

local modkey       = beautiful.modkey
local altkey       = beautiful.altkey
local terminal     = beautiful.terminal .. " " .. beautiful.shell
local browser      = beautiful.browser
local browser_alt  = beautiful.browser_alt
local music_player = beautiful.music_player
local mail_ims     = beautiful.terminal .. " -e neomutt -F ~/Sync/Rice/_private/mail-muttrcIMS"
local mail_st      = beautiful.terminal .. " -e neomutt -F ~/Sync/Rice/_private/mail-muttrcUni"

-- {{{ Mouse bindings
root.buttons(gears.table.join(
  awful.button({}, 3, function() dashboard.toggle() end),
  awful.button({}, 4, awful.tag.viewnext),
  awful.button({}, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Window Switching
-- Mark focused client with border while "cycling"
local function hideborder()
  local focused = client.focus
  if focused then
    focused.border_color = beautiful.bg_color
  end
end

local border_timer
border_timer = gears.timer {
  timeout   = 0.5,
  autostart = false,
  run_once  = true,
  callback  = function()
    hideborder()
    border_timer:stop()
  end
}
local function showborder()
  border_timer:stop()
  hideborder()
  local screen = awful.screen.focused()
  local clients = screen.selected_tag:clients()
  for _, c in pairs(clients) do
    c.border_color = beautiful.bg_color
  end
  if client.focus then
    client.focus.border_color = beautiful.accent_color
  end
  border_timer:start()
end
-- }}}


-- {{{ Global Key bindings
globalkeys = gears.table.join(

-- User programs
  awful.key({ modkey }, "t", function()
      awful.spawn(browser)
    end,
    { description = "run browser", group = "launcher" }),
  awful.key({ modkey }, "z", function() awful.spawn(browser_alt) end,
    { description = "run browser", group = "launcher" }),
  awful.key({ modkey }, "g", function() awful.spawn(music_player) end,
    { description = "run browser", group = "launcher" }),
  awful.key({ modkey }, "Return", function() awful.spawn(terminal) end,
    { description = "open a terminal", group = "launcher" }),
  awful.key({ modkey }, "F1", function() awful.spawn(mail_ims) end,
    { descaauription = "checkmail", group = "launcher" }),
  awful.key({ modkey }, "F2", function() awful.spawn(mail_st) end,
    { description = "checkmail", group = "launcher" }),
  awful.key({ modkey }, "F4", function() panel.toggle_zenmode() end,
    { description = "toggle zenmode", group = "launcher" }),
  awful.key({ modkey, }, "space", function() uwuprompt.launch() end,
    { description = "change wallpaper and theme", group = "hotkeys" }),
  awful.key({ modkey, "Shift" }, "space", function() awful.spawn(terminal) end,
    { description = "change wallpaper and theme", group = "hotkeys" }),
  awful.key({ modkey }, "u", function() pywal.show() end,
    { description = "run prompt", group = "launcher" }),

  -- Awesome things
  awful.key({ modkey, "Control" }, "r", awesome.restart,
    { description = "reload awesome", group = "awesome" }),
  awful.key({ modkey, "Shift" }, "q", awesome.quit,
    { description = "quit awesome", group = "awesome" }),

  -- Layout manipulation
  awful.key({ modkey, }, "Left", function() awful.tag.incmwfact(-0.05) end,
    { description = "increase master width factor", group = "layout" }),
  awful.key({ modkey, }, "Right", function() awful.tag.incmwfact(0.05) end,
    { description = "decrease master width factor", group = "layout" }),
  awful.key({ modkey, }, "Up", function() awful.client.incwfact(0.1) end),
  awful.key({ modkey, }, "Down", function() awful.client.incwfact(-0.1) end),
  awful.key({ modkey, }, "h", function() awful.tag.incmwfact(-0.05) end,
    { description = "increase master width factor", group = "layout" }),
  awful.key({ modkey, }, "l", function() awful.tag.incmwfact(0.05) end,
    { description = "decrease master width factor", group = "layout" }),
  awful.key({ modkey, }, "k", function() awful.client.incwfact(0.1) end),
  awful.key({ modkey, }, "j", function() awful.client.incwfact(-0.1) end),
  awful.key({ modkey, "Shift" }, "h", function() awful.tag.incnmaster(1, nil, true) end,
    { description = "increase the number of master clients", group = "layout" }),
  awful.key({ modkey, "Shift" }, "l", function() awful.tag.incnmaster(-1, nil, true) end,
    { description = "decrease the number of master clients", group = "layout" }),
  awful.key({ modkey }, "Escape", function()
    awful.client.swap.byidx(1)
    awful.client.focus.byidx(1)
    showborder()
  end, { description = "select previous", group = "layout" }),

  -- Sticky client toggle
  awful.key({ modkey, }, "s", function()
    client.focus.sticky = not client.focus.sticky
  end),

  -- Screen jumping
  awful.key({ modkey, }, "dead_circumflex", function() awful.screen.focus_relative(1) end,
    { description = "focus the next screen", group = "screen" }),

  -- Client jumping
  awful.key({ modkey, }, "Tab",
    function()
      awful.client.focus.byidx(1)
      showborder()
    end,
    { description = "focus next client", group = "client" }),

  -- Maximize
  awful.key({ modkey, }, "m",
    function()
      local c = awful.client.restore()
      if c then
        client.focus = c
        c:raise()
      end
    end,
    { description = "restore minimized", group = "client" }),

  -- Sticky dashboard toggle
  awful.key({ modkey, }, "d", function()
    dashboard.toggleSticky()
  end),

  -- ALSA volume control
  awful.key({}, "XF86AudioRaiseVolume",
    function()
      os.execute(string.format("amixer -q sset %s 3%%+", 'Master'))
      awesome.emit_signal("volume::redraw_needed")
      volume.popup()
    end),
  awful.key({}, "XF86AudioLowerVolume",
    function()
      os.execute(string.format("amixer -q sset %s 3%%-", 'Master'))
      awesome.emit_signal("volume::redraw_needed")
      volume.popup()
    end),
  awful.key({ altkey }, "XF86AudioRaiseVolume",
    function()
      os.execute(string.format("amixer -q sset %s 3%%+", 'Capture'))
      awesome.emit_signal("microphone::redraw_needed")
      volume.popup()
    end),
  awful.key({ altkey }, "XF86AudioLowerVolume",
    function()
      os.execute(string.format("amixer -q sset %s 3%%-", 'Capture'))
      awesome.emit_signal("microphone::redraw_needed")
      volume.popup()
    end),
  awful.key({ altkey }, "Up",
    function()
      os.execute(string.format("amixer -q sset %s 3%%+", 'Master'))
      awesome.emit_signal("volume::redraw_needed")
      volume.popup()
    end,
    { description = "volume up", group = "hotkeys" }),
  awful.key({ altkey }, "Down",
    function()
      os.execute(string.format("amixer -q sset %s 3%%-", 'Master'))
      awesome.emit_signal("volume::redraw_needed")
      volume.popup()
    end,
    { description = "volume down", group = "hotkeys" }),
  awful.key({ altkey }, "m",
    function()
      os.execute(string.format("amixer -q set %s toggle", 'Master'))
      awesome.emit_signal("volume::redraw_needed")
    end,
    { description = "toggle mute", group = "hotkeys" }),
  awful.key({ altkey, "Control" }, "m",
    function()
      os.execute(string.format("amixer -q set %s 100%%", 'Master'))
      awesome.emit_signal("volume::redraw_needed")
    end,
    { description = "volume 100%", group = "hotkeys" }),
  awful.key({ altkey, "Control" }, "0",
    function()
      os.execute(string.format("amixer -q set %s 0%%", 'Master'))
      awesome.emit_signal("volume::redraw_needed")
    end,
    { description = "volume 0%", group = "hotkeys" }),

  -- Brightness
  awful.key({}, "XF86MonBrightnessUp", function() os.execute("xbacklight -inc 2") end,
    { description = "+2%", group = "hotkeys" }),
  awful.key({}, "XF86MonBrightnessDown", function() os.execute("xbacklight -dec 2") end,
    { description = "-2%", group = "hotkeys" })
)


for i = 1, 3 do
  globalkeys = gears.table.join(globalkeys,
    -- View tag only.
    awful.key({ modkey }, "#" .. i + 9,
      function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          tag:view_only()
        end
      end,
      { description = "view tag #" .. i, group = "tag" }),
    -- Toggle tag display.
    awful.key({ modkey, "Control" }, "#" .. i + 9,
      function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          awful.tag.viewtoggle(tag)
        end
      end,
      { description = "toggle tag #" .. i, group = "tag" }),
    -- Move client to tag.
    awful.key({ modkey, "Shift" }, "#" .. i + 9,
      function()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:move_to_tag(tag)
          end
        end
      end,
      { description = "move focused client to tag #" .. i, group = "tag" }),
    -- Toggle tag on focused client.
    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
      function()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:toggle_tag(tag)
          end
        end
      end,
      { description = "toggle focused client on tag #" .. i, group = "tag" })
  )
end

-- Set globalkeys
root.keys(globalkeys)


-- Clean up... unused stuff here
-- awful.key({ modkey }, "d", function () os.execute(dmenu_snippets) end,
--           {description = "show snippets menu", group = "launcher"}),
-- awful.key({ modkey }, "y", function () os.execute(dmenu_append_snippets) end,
--          {description = "show snippets menu", group = "launcher"}),
--
-- awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
--           {description = "increase the number of columns", group = "layout"}),
-- awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
--           {description = "decrease the number of columns", group = "layout"}),

--
-- awful.key({ modkey,           }, "j",
--     function () awful.client.focus.byidx( 1) end,
--     {description = "focus next by index", group = "client"}),
-- awful.key({ modkey,           }, "k", function ()  awful.client.focus.byidx(-1) end,
--     {description = "focus previous by index", group = "client"}),
--
-- awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
--           {description = "swap with next client by index", group = "client"}),
-- awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
--           {description = "swap with previous client by index", group = "client"}),

-- Tag browsing
-- awful.key({ altkey,           }, "Left", awful.tag.viewprev,
--           {description = "view previous", group = "tag"}),
-- awful.key({ altkey,           }, "Right", awful.tag.viewnext,
--           {description = "view next", group = "tag"}),
-- awful.key({ altkey,           }, "h", awful.tag.viewprev,
--           {description = "view previous", group = "tag"}),
-- awful.key({ altkey,           }, "l", awful.tag.viewnext,
--           {description = "view next", group = "tag"}),
-- awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
--           {description = "increase master width factor", group = "layout"}),
-- awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
--           {description = "decrease master width factor", group = "layout"}),
-- awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
--           {description = "increase the number of master clients", group = "layout"}),
-- awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
--           {description = "decrease the number of master clients", group = "layout"}),
-- awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
--           {description = "increase the number of columns", group = "layout"}),
-- awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
--           {description = "decrease the number of columns", group = "layout"}),

-- awful.key({ modkey }, "x", function () uwuprompt.launch() end,
--           {description = "run prompt", group = "launcher"}),

-- awful.key({ modkey }, "#", function ()
--           awful.screen.focused().systray.visible = not awful.screen.focused().systray.visible
--         end, {description = "Toggle systray visibility", group = "custom"}),


-- local dmenu_snippets = "pidof librewolf >/dev/null ; [[ $? -ne 0 ]] && librewolf &"
-- dmenu_snippets = dmenu_snippets .. "librewolf $(grep -v '^#' ~/Sync/Rice/_private/browser-bookmarks | "
-- dmenu_snippets = dmenu_snippets .. "dmenu -i -l 30 -fn 'Terminus (TTF)-18'"
-- dmenu_snippets = dmenu_snippets .. "| cut -d' ' -f1)"
