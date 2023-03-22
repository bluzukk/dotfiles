local awful     = require("awful")
local beautiful = require("beautiful")
local gears     = require("gears")
local wibox     = require("wibox")
local dpi       = beautiful.xresources.apply_dpi

local naughty   = require("naughty")
local util      = require("helpers.util")
-- local markup    = require("helpers.markup")
local gfs       = require("gears.filesystem")

local ICONS_DIR = gfs.get_configuration_dir() .. "assets/misc/"
local startup   = true

local LAT       = util.read_line(LAT)
if not LAT then
    Print("Redshift: latitude missing")
end

local LONG = util.read_line(LONG)
if not LONG then
    Print("Redshift: longtiude missing")
end


local function update_buttons(c, is_on)
    if startup then is_on = not is_on end
    if not is_on then
        c.enabled = true
        c:get_children_by_id('image')[1].image = c.icon_on
        -- c:get_children_by_id('text')[1].markup = markup(beautiful.accent_alt_color, " On  ")
        -- c:set_bg(beautiful.bg_color)
    else
        c.enabled = false
        c:get_children_by_id('image')[1].image = c.icon_off
        -- c:get_children_by_id('text')[1].markup = markup(beautiful.accent_color, " Off  ")
        -- c:set_bg(beautiful.bg_color)
    end
end

local function open_task(self)
    if self.task ~= "bluelight" and self.enabled then
        awful.spawn(self.cmd_on)
    end
end

local function update_task(self, is_on)
    if not startup then
        if not is_on then
            naughty.notify({ title = "Enabling " .. self.task .. " : " .. self.cmd_on })
            awful.spawn(self.cmd_on)
        else
            naughty.notify({ title = "Disabling " .. self.task })
            awful.spawn(self.cmd_off)
        end
    end
    update_buttons(self, is_on)
end


local function check_task(button)
    if button.task == "wifi" then
        awful.spawn.easy_async_with_shell("nmcli networking", function(out)
            if string.find(out, "enabled") then
                update_task(button, true)
            else
                update_task(button, false)
            end
        end)
    elseif button.task == "sync" then
        awful.spawn.easy_async_with_shell("pidof megasync", function(out)
            if out ~= "" then
                update_task(button, true)
            else
                update_task(button, false)
            end
        end)
    elseif button.task == "bluelight" then
        awful.spawn.easy_async_with_shell("pidof redshift", function(out)
            if out ~= "" then
                update_task(button, true)
            else
                update_task(button, false)
            end
        end)
    elseif button.task == "chat" then
        awful.spawn.easy_async_with_shell("pidof /opt/discord/Discord", function(out)
            if out ~= "" then
                update_task(button, true)
            else
                update_task(button, false)
            end
        end)
    elseif button.task == "game" then
        awful.spawn.easy_async_with_shell("pidof steam", function(out)
            if out ~= "" then
                update_task(button, true)
            else
                update_task(button, false)
            end
        end)
    end
end

local function create_button(task, icon_on, icon_off, cmd_on, cmd_off)
    local button = wibox.widget
        {
            {
                {
                    {
                        id = "image",
                        resize = true,
                        widget = wibox.widget.imagebox,
                        shape = gears.shape.circle,
                        forced_height = dpi(30),
                    },
                    -- {
                    --     id = "text",
                    --     font = beautiful.font_name .. " 12",
                    --     widget = wibox.widget.textbox,
                    -- },
                    layout = wibox.layout.fixed.vertical,
                },
                widget = wibox.container.margin,
                top = dpi(2),
                left = dpi(2),
                right = dpi(2),
                bottom = dpi(2)
            },
            widget   = wibox.container.background,
            bg       = beautiful.bg_color_light,
            shape    = gears.shape.rounded_rect,
            task     = task,
            icon_on  = icon_on,
            icon_off = icon_off,
            cmd_on   = cmd_on,
            cmd_off  = cmd_off,
            enabled  = false
        }

    check_task(button)
    button.buttons = gears.table.join(
        awful.button({}, 1, function()
            -- Toggle task
            startup = false
            check_task(button)
        end),
        awful.button({}, 3, function()
            -- Jump to task
            startup = false
            open_task(button)
        end))
    -- button:connect_signal("mouse::enter", function(self)
    --
    --     check_task(self)
    -- end)
    return button
end

local function recolor_image(image, color)
    return gears.color.recolor_image(
        ICONS_DIR .. image, color)
end

local sync_icon_off = recolor_image("cloud-off.svg", beautiful.accent_color)
local wifi_icon_off = recolor_image("wifi-off.svg", beautiful.accent_color)
local discord_icon_off = recolor_image("chat-off.svg", beautiful.accent_color)
local bluelight_icon_off = recolor_image("redshift-off.svg", beautiful.accent_color)
local game_icon_off = recolor_image("game-off.svg", beautiful.accent_color)

local sync_icon_on = recolor_image("cloud-on.svg", beautiful.accent_alt_color)
local wifi_icon_on = recolor_image("wifi-on.svg", beautiful.accent_alt_color)
local discord_icon_on = recolor_image("chat-on.svg", beautiful.accent_alt_color)
local bluelight_icon_on = recolor_image("redshift-on.svg", beautiful.accent_alt_color)
local game_icon_on = recolor_image("game-on.svg", beautiful.accent_alt_color)
awful.spawn("discord")

local wifi_button = create_button(
    "wifi",
    wifi_icon_on,
    wifi_icon_off,
    "nmcli networking on",
    "nmcli networking off")
local sync_button = create_button(
    "sync",
    sync_icon_on,
    sync_icon_off,
    "megasync",
    "killall -9 megasync")
local discord_button = create_button(
    "chat",
    discord_icon_on,
    discord_icon_off,
    "discord",
    "killall -9 /opt/discord/Discord")
local bluelight_button = create_button(
    "bluelight",
    bluelight_icon_on,
    bluelight_icon_off,
    "redshift -l " .. LAT .. ":" .. LONG,
    "killall -9 redshift")
local game_button = create_button(
    "game",
    game_icon_on,
    game_icon_off,
    "steam",
    "killall -9 steam")



local function create()
    local launcher = {
        game_button,
        discord_button,
        bluelight_button,
        wifi_button,
        sync_button,
        spacing = dpi(33),
        layout = wibox.layout.flex.horizontal,
        align = 'center',
        widget = wibox.container.place,
    }

    local container = wibox.widget {
        {
            {
                {
                    widget = wibox.container.place,
                    halign = "center",
                    valign = "center",
                    forced_height = dpi(50),
                    launcher
                },
                widget = wibox.container.margin,
                margins = {
                    left = dpi(50),
                    right = dpi(50)
                },
            },
            widget = wibox.container.background,
            bg = beautiful.bg_color_light,
            shape = gears.shape.rounded_rect
        },
        widget = wibox.container.margin,
        margins = {
            left = beautiful.dashboard_margin / 2,
            right = beautiful.dashboard_margin / 2,
            bottom = 0,
            top = beautiful.dashboard_margin / 4,
        },
    }
    return container
end


gears.timer {
    timeout = 30,
    autostart = true,
    callback = function()
        startup = true
        check_task(wifi_button)
        check_task(game_button)
        check_task(sync_button)
        check_task(bluelight_button)
        check_task(discord_button)
    end
}

return {
    create = create
}
