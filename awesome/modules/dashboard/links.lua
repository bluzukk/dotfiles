local awful      = require("awful")
local beautiful  = require("beautiful")
local gears      = require("gears")
local gfs        = require("gears.filesystem")
-- local naughty   = require("naughty")
local wibox      = require("wibox")
local dpi        = beautiful.xresources.apply_dpi

local markup     = require("helpers.markup")

local CMD_TERM   = beautiful.terminal .. " -e zsh"
local CMD_TASKS  = beautiful.terminal .. " -e zsh -c 'btop'"
local CMD_FILES  = beautiful.terminal .. " -e zsh -c 'lf'"
local CMD_BROWSE = [[ librewolf  ]]
local CMD_GAME   =
[[ bash -c "VULKAN_DEVICE_INDEX=1 WINEPREFIX=~/Games/.wow wine ~/Games/WoW/ClassicWoW/_classic_/WowClassic.exe" ]]
local CMD_MUSIC  = [[ librewolf https://www.youtube.com/watch?v=AjIwBNxv3FE ]]


local CMD_DOWNLOAD = [[ thunar Downloads ]]
local CMD_WORK = beautiful.terminal .. " -e zsh -c 'sem;lf'"
local CMD_GAMES = [[ thunar Games ]]

local ICONS_PATH = gfs.get_configuration_dir() .. "assets/powermenu/"


local function create_button(text, icon_name, cmd)
    local img      = gears.color.recolor_image(
        ICONS_PATH .. icon_name, beautiful.accent_alt_color)
    local button   = wibox.widget
        {
            {
                {
                    {
                        {
                            id            = "image",
                            image         = img,
                            resize        = true,
                            widget        = wibox.widget.imagebox,
                            shape         = gears.shape.circle,
                            forced_height = dpi(32),
                        },
                        {
                            id = "text",
                            font = beautiful.font_name .. " 14",
                            markup = markup(beautiful.accent_color, " " .. text),
                            widget = wibox.widget.textbox,
                        },
                        layout = wibox.layout.fixed.horizontal,
                        forced_width = beautiful.dashboard_width,
                    },
                    widget = wibox.container.place,
                    halign = "center",
                    valign = "center",
                    forced_height = dpi(42),
                },
                widget  = wibox.container.margin,
                margins = {
                    left   = dpi(20),
                    right  = dpi(20),
                    bottom = dpi(10),
                    top    = dpi(10),
                },
            },
            widget = wibox.container.background,
            bg     = beautiful.bg_color_light,
            -- shape  = gears.shape.rounded_rect,
        }

    button.buttons = gears.table.join(
        awful.button({}, 1, function()
            awful.spawn(cmd)
        end)
    )

    button:connect_signal("button::press", function(c) c:set_bg(beautiful.accent_color) end)
    button:connect_signal("button::release", function(c) c:set_bg(beautiful.bg_color) end)
    button:connect_signal("mouse::enter", function(c) c:set_bg(beautiful.bg_color) end)
    button:connect_signal("mouse::leave", function(c) c:set_bg(beautiful.bg_color_light) end)
    return button
end

local function create()
    local term_button      = create_button("Term1nal", "", CMD_TERM)
    local files_button     = create_button("F1les", "", CMD_FILES)
    local browse_button    = create_button("Br0wser", "", CMD_BROWSE)
    local tasks_button     = create_button("T4sks", "", CMD_TASKS)
    local music_button     = create_button("Mus1c", "", CMD_MUSIC)
    local game_button      = create_button("UwU", "", CMD_GAME)

    -- Dir buttons
    local downloads_button = create_button("Downloads", "", CMD_DOWNLOAD)
    local work_button      = create_button("Work", "", CMD_WORK)
    local games_button     = create_button("Games", "", CMD_GAMES)


    local apps   = wibox.widget {
        {
            {
                {
                    layout = wibox.layout.flex.vertical,
                    -- spacing = dpi(10),
                    {
                        widget = wibox.widget.textbox(),
                        markup = markup.fontfg(beautiful.font_name .. " 20", beautiful.accent_alt_color,
                            "  /Apps")
                    },
                    term_button,
                    files_button,
                    browse_button,
                    tasks_button,
                    music_button,
                    game_button,
                },
                widget = wibox.container.place,
                halign = "center",
                valign = "center",
                -- forced_height = dpi(600),
                forced_width = dpi(300)
            },
            widget = wibox.container.background,
            bg     = beautiful.bg_color_light,
            shape  = gears.shape.rounded_rect
        },
        widget  = wibox.container.margin,
        margins = {
            left  = beautiful.dashboard_margin,
            right = beautiful.dashboard_margin,
            -- bottom = beautiful.dashboard_margin,
            top   = beautiful.dashboard_margin,
        },
    }

    local browse = wibox.widget {
        {
            {
                {
                    layout = wibox.layout.flex.vertical,
                    spacing = dpi(10),
                    {
                        widget = wibox.widget.textbox(),
                        markup = markup.fontfg(beautiful.font_name .. " 20", beautiful.accent_alt_color,
                            "  /Browse")
                    },
                },
                widget = wibox.container.place,
                halign = "center",
                valign = "center",
                -- forced_height = dpi(600),
                forced_width = dpi(300)
            },
            widget = wibox.container.background,
            bg     = beautiful.bg_color_light,
            shape  = gears.shape.rounded_rect
        },
        widget  = wibox.container.margin,
        margins = {
            left  = beautiful.dashboard_margin,
            right = beautiful.dashboard_margin,
            -- bottom = beautiful.dashboard_margin,
            top   = beautiful.dashboard_margin,
        },
    }


    local locations = wibox.widget {
        {
            {
                {
                    layout = wibox.layout.flex.vertical,
                    spacing = dpi(10),
                    {
                        widget = wibox.widget.textbox(),
                        markup = markup.fontfg(beautiful.font_name .. " 20", beautiful.accent_alt_color,
                            "  /Home")
                    },
                    downloads_button,
                    work_button,
                    games_button,
                },
                widget = wibox.container.place,
                halign = "center",
                valign = "center",
                -- forced_height = dpi(600),
                forced_width = dpi(300)
            },
            widget = wibox.container.background,
            bg     = beautiful.bg_color_light,
            shape  = gears.shape.rounded_rect
        },
        widget  = wibox.container.margin,
        margins = {
            left  = beautiful.dashboard_margin,
            right = beautiful.dashboard_margin,
            -- bottom = beautiful.dashboard_margin,
            top   = beautiful.dashboard_margin,
        },
    }
    local links     = wibox.widget {
        apps,
        -- browse,
        -- locations,
        layout = wibox.layout.align.vertical
    }
    return links
end

return {
    create = create
}
