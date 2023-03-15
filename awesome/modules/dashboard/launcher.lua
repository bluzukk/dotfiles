local awful     = require("awful")
local beautiful = require("beautiful")
local gears     = require("gears")
local wibox     = require("wibox")
local dpi       = beautiful.xresources.apply_dpi

local naughty   = require("naughty")
local util      = require("helpers.util")
local markup    = require("helpers.markup")
local gfs       = require("gears.filesystem")

local ICONS_DIR =  gfs.get_configuration_dir() .. "assets/misc/"
local startup = true

local LAT  = util.read_line(LAT)
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
        c:get_children_by_id('image')[1].image = c.icon_on
        -- c:get_children_by_id('text')[1].markup = markup(beautiful.accent_alt_color, " On  ")
        -- c:set_bg(beautiful.bg_color)
    else
        c:get_children_by_id('image')[1].image = c.icon_off
        -- c:get_children_by_id('text')[1].markup = markup(beautiful.accent_color, " Off  ")
        -- c:set_bg(beautiful.bg_color)
    end
end

local function update_task(self, is_on)
    if not startup then
        if not is_on then
            naughty.notify({title = "Enabling " .. self.task})
            awful.spawn.easy_async_with_shell(self.cmd_on)
        else
            naughty.notify({title = "Disabling " .. self.task})
            awful.spawn.easy_async_with_shell(self.cmd_off)
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
                    forced_height = dpi(42),
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
    }

    check_task(button)

    button:connect_signal("button::press", function(self)
        startup = false
        check_task(self)
    end)
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

local sync_icon_on = recolor_image("cloud-on.svg", beautiful.accent_alt_color)
local wifi_icon_on = recolor_image("wifi-on.svg", beautiful.accent_alt_color)
local discord_icon_on = recolor_image("chat-on.svg", beautiful.accent_alt_color)
local bluelight_icon_on = recolor_image("redshift-on.svg", beautiful.accent_alt_color)

local wifi_button = create_button(
        "wifi",
        wifi_icon_on,
        wifi_icon_off,
        "nmcli networking on; ls",
        "nmcli networking off; ls")
local sync_button = create_button(
        "sync",
        sync_icon_on,
        sync_icon_off,
        "megasync; ls",
        "killall -9 megasync; ls")
local discord_button = create_button(
        "chat",
        discord_icon_on,
        discord_icon_off,
        "discord;ls",
        "killall -9 /opt/discord/Discord; ls")
local bluelight_button = create_button(
        "bluelight",
        bluelight_icon_on,
        bluelight_icon_off,
        "redshift -l " .. LAT .. ":" .. LONG .. ";ls",
        "killall -9 redshift; ls")


local function create()
    local launcher = {
        discord_button,
        bluelight_button,
        wifi_button,
        sync_button,
        spacing = dpi(10),
        layout = wibox.layout.flex.horizontal,
        align = 'center',
        widget = wibox.container.place,
    }

    local container = wibox.widget {
        {
            {
                widget = wibox.container.place,
                halign = "center",
                valign = "center",
                forced_height = dpi(100),
                launcher
            },
            widget = wibox.container.background,
            bg = beautiful.bg_color_light,
            shape = gears.shape.rounded_rect
        },
        widget = wibox.container.margin,
        margins = {
            left = beautiful.dashboard_margin/2,
            right = beautiful.dashboard_margin/2,
            bottom = 0,
            top = beautiful.dashboard_margin/3,
        },
    }
    return container
end

return {
    create = create
}
