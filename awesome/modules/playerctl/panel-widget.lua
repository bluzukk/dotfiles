-------------------------------------------------------------------------------
-- Playerctl Widget                                                          --
-------------------------------------------------------------------------------

local awful      = require("awful")
local beautiful  = require("beautiful")
local gears      = require("gears")
local wibox      = require("wibox")
local dpi        = require("beautiful").xresources.apply_dpi
local gfs        = require("gears.filesystem")

local markup     = require("helpers.markup")
local ICONS_DIR  = gfs.get_configuration_dir() .. "assets/misc/"

local CMD_MAIN   = [[ playerctl --follow metadata --format '{{status}};{{xesam:artist}};{{xesam:title}}' ]]
local CMD_LEN    = [[ playerctl metadata mpris:length ]]
local CMD_TOGGLE = [[ playerctl play-pause ]]
local CMD_POS    = [[ playerctl position ]]
local CMD_CHECK  = [[ playerctl --list-all ]]
local CMD_NEXT   = [[ playerctl next ]]
local CMD_PREV   = [[ playerctl previous ]]

-- Create Buttons
local function recolor_image(image, color)
    return gears.color.recolor_image(
        ICONS_DIR .. image, color)
end

local play_icon = recolor_image("play.svg", beautiful.accent_color)
local pause_icon = recolor_image("pause.svg", beautiful.accent_color)
local next_icon = recolor_image("next.svg", beautiful.accent_color)
local prev_icon = recolor_image("prev.svg", beautiful.accent_color)

local function createWidget(title, onclick_cmd, color_default, color_accent)
    local container = wibox.widget {
        {
            {
                {
                    {
                        {
                            widget = wibox.widget.textbox,
                            id = "status",
                            text = "Error: status",
                            forced_width = dpi(80)
                        },
                        -- {
                        --     id = "scroller",
                        --     layout = wibox.container.scroll.horizontal,
                        --     step_function = wibox.container.scroll.step_functions
                        --         .linear_increase,
                        --     speed = 25,
                            {
                                {
                                    widget = wibox.widget.textbox,
                                    id = "text",
                                    text = "Error:" .. title
                                },
                                widget = wibox.container.place,
                                halign = "center",
                            -- },
                        },
                        spacing = dpi(10),
                        layout = wibox.layout.fixed.horizontal,
                        -- forced_width = dpi(390)
                    },
                    width   = dpi(350),
                    widget  = wibox.container.margin,
                    margins = {
                        left   = dpi(16),
                        -- right = dpi(16),
                        top    = dpi(7),
                        bottom = dpi(1)
                    },
                    id      = "margins"
                },
                {
                    id               = "progress",
                    max_value        = 100,
                    value            = 0,
                    widget           = wibox.widget.progressbar,
                    forced_width     = dpi(1),
                    forced_height    = dpi(2),
                    background_color = beautiful.accent_alt_color_dark2,
                    bar_border_width = 10,
                    color            = beautiful.accent_color,
                    margins          = {
                        left = dpi(17)
                    }
                },
                layout = wibox.layout.fixed.vertical
            },
            {
                {
                    {
                        id = "prev_button",
                        resize = true,
                        visible = false,
                        widget = wibox.widget.imagebox,
                        image = prev_icon,
                        shape = gears.shape.circle,
                        forced_height = dpi(40),
                    },
                    widget = wibox.container.margin,
                    top = dpi(2),
                    left = dpi(2),
                    right = dpi(2),
                    bottom = dpi(2)
                },
                id = "prev_button_bg",
                widget = wibox.container.background,
            },
            {
                {
                    {
                        id = "play_button",
                        resize = true,
                        visible = false,
                        widget = wibox.widget.imagebox,
                        image = play_icon,
                        shape = gears.shape.circle,
                        forced_height = dpi(40),
                    },
                    widget = wibox.container.margin,
                    top = dpi(2),
                    left = dpi(2),
                    right = dpi(2),
                    bottom = dpi(2)
                },
                id = "play_button_bg",
                widget = wibox.container.background,
            },
            {
                {
                    {
                        id = "next_button",
                        resize = true,
                        visible = false,
                        widget = wibox.widget.imagebox,
                        image = next_icon,
                        shape = gears.shape.circle,
                        forced_height = dpi(40),
                    },
                    widget = wibox.container.margin,
                    top = dpi(2),
                    left = dpi(2),
                    right = dpi(2),
                    bottom = dpi(2)
                },
                id = "next_button_bg",
                widget = wibox.container.background,
            },
            spacing = dpi(10),
            layout = wibox.layout.fixed.horizontal
        },
        widget        = wibox.container.background,
        bg            = color_default,
        -- shape         = gears.shape.powerline,
        onclick       = onclick_cmd,
        color_default = color_default,
        color_accent  = color_accent,
        update        = function(self, content)
            self:get_children_by_id('text')[1].markup =
                markup(beautiful.main_color, content)
        end,
        hide          = function(self)
            self:get_children_by_id('text')[1].markup = ""
            self:get_children_by_id('margins')[1].margins = 0
        end

    }
    -- container:get_children_by_id("scroller")[1]:pause()

    container:connect_signal("mouse::enter", function(self)
        self.bg = self.color_accent
        -- container:get_children_by_id("scroller")[1]:continue()
        container:get_children_by_id("play_button")[1].visible = true
        container:get_children_by_id("next_button")[1].visible = true
        container:get_children_by_id("prev_button")[1].visible = true
        container:get_children_by_id("play_button_bg")[1].bg = color_accent
        container:get_children_by_id("next_button_bg")[1].bg = color_accent
        container:get_children_by_id("prev_button_bg")[1].bg = color_accent
    end)
    container:connect_signal("mouse::leave", function(self)
        self.bg = self.color_default
        -- container:get_children_by_id("scroller")[1]:reset_scrolling()
        -- container:get_children_by_id("scroller")[1]:pause()
        container:get_children_by_id("play_button")[1].visible = false
        container:get_children_by_id("next_button")[1].visible = false
        container:get_children_by_id("prev_button")[1].visible = false
        container:get_children_by_id("play_button_bg")[1].bg = color_default
        container:get_children_by_id("next_button_bg")[1].bg = color_default
        container:get_children_by_id("prev_button_bg")[1].bg = color_default
    end)

    local function setupButtons(CMD, button_id)
        container:get_children_by_id(button_id)[1]:connect_signal("button::press", function()
            awful.spawn(CMD)
        end)
        container:get_children_by_id(button_id)[1]:connect_signal("mouse::enter", function()
            container:get_children_by_id(button_id .. "_bg")[1].bg = beautiful.bg_color_light10
        end)
        container:get_children_by_id(button_id)[1]:connect_signal("mouse::leave", function()
            container:get_children_by_id(button_id .. "_bg")[1].bg = container.color_accent
        end)
    end
    setupButtons(CMD_TOGGLE, "play_button")
    setupButtons(CMD_PREV, "prev_button")
    setupButtons(CMD_NEXT, "next_button")

    -- Update progressbar
    local update_timer = gears.timer {
        timeout   = 3,
        autostart = true,
        call_now  = true,
        callback  = function()
            -- get len
            awful.spawn.easy_async(CMD_LEN,
                function(evil)
                    if evil ~= "" then
                        local length = evil / 1000 / 1000
                        container:get_children_by_id("progress")[1].max_value = tonumber(length)
                    end
                end)

            awful.spawn.easy_async(CMD_POS,
                function(evil)
                    if evil ~= "" then
                        local pos = evil
                        container:get_children_by_id("progress")[1].value = tonumber(pos)
                    end
                end)
        end
    }
    -- Parse playerctl --follow
    awful.spawn.with_line_callback(
        CMD_MAIN, {
            stdout = function(line)
                local data = {}
                container.visible = true
                -- unexpected
                if line == "" then
                    -- double check
                    -- maybe some player is still connected
                    awful.spawn.easy_async(CMD_CHECK,
                        function(evil)
                            if evil == "" then
                                container.visible = false
                                update_timer:stop()
                            else
                                container.visible = true
                                update_timer:start()
                            end
                        end)
                end

                for str in string.gmatch(line, "([^;]+)") do
                    table.insert(data, str)
                end
                local color = beautiful.accent_color
                if not string.match("Playing\n", data[1]) then
                    update_timer:stop()
                    container:get_children_by_id("play_button")[1].image = play_icon
                    color = beautiful.accent_alt_color_dark
                else
                    container:get_children_by_id("play_button")[1].image = pause_icon
                    update_timer:start()
                end
                if not string.match("Stopped\n", data[1]) then
                    if #data[3] > 30 then
                        data[3] = data[3]:sub(1, 30)
                    end
                    if data[3] then
                        container:update(data[2] .. " - " .. data[3])
                    else
                        container:update(data[2])
                    end
                    container:get_children_by_id("status")[1].markup = markup(color, data[1])
                else
                    update_timer:stop()
                end
            end
        })

    -- initial check
    awful.spawn.easy_async(CMD_CHECK,
        function(evil)
            if evil == "" then
                container.visible = false
                update_timer:stop()
            else
                container.visible = true
                update_timer:start()
            end
        end)
    return container
end

return createWidget("", "", beautiful.bg_color, beautiful.bg_color_light5)
