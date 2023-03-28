local awful      = require("awful")
local beautiful  = require("beautiful")
local gears      = require("gears")
local wibox      = require("wibox")
local lgi        = require("lgi")
local dpi        = require("beautiful").xresources.apply_dpi
local markup     = require("helpers.markup")

local Playerctl  = lgi.Playerctl
local player     = Playerctl.Player {}

local CMD_LEN    = [[playerctl metadata mpris:length]]
local CMD_TOGGLE = [[playerctl play-pause]]
local CMD_POS    = [[playerctl position]]
local CMD_STATUS = [[playerctl status]]


local function createWidget(title, onclick_cmd, color_default, color_accent)
    local container = wibox.widget {
        {
            {
                {
                    {
                        {
                            widget = wibox.widget.textbox,
                            id = "status",
                            text = "Error: status"
                        },
                        {
                            widget = wibox.widget.textbox,
                            id = "text",
                            text = "Error:" .. title
                        },
                        spacing = dpi(10),
                        layout = wibox.layout.fixed.horizontal
                    },
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
                    value            = 50,
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
                widget = wibox.widget.textbox,
                id = "play",
                text = "| Play/Pause |",
                visible = false,
            },
            {
                widget = wibox.widget.textbox,
                id = "next",
                text = "Next ",
                visible = false,
            },
            spacing = dpi(10),
            layout = wibox.layout.fixed.horizontal
        },
        widget        = wibox.container.background,
        bg            = color_default,
        shape         = gears.shape.powerline,
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
    container:connect_signal("mouse::enter", function(self)
        self.bg = self.color_accent
        container:get_children_by_id("play")[1].visible = true
        container:get_children_by_id("next")[1].visible = true
    end)
    container:connect_signal("mouse::leave", function(self)
        self.bg = self.color_default
        container:get_children_by_id("play")[1].visible = false
        container:get_children_by_id("next")[1].visible = false
    end)
    container:get_children_by_id("play")[1]:connect_signal("button::press", function(self)
        player:play_pause()
        awful.spawn.easy_async(CMD_STATUS,
            function(evil)
                local color = beautiful.accent_color
                if not string.match("Playing\n", evil) then
                    color = beautiful.accent_alt_color_dark
                end
                container:get_children_by_id("status")[1].markup = markup(color, evil)
            end)
    end)
    container:get_children_by_id("next")[1]:connect_signal("button::press", function(self)
        player:next()
    end)
    -- Update
    gears.timer {
        timeout   = 3,
        call_now  = true,
        autostart = true,
        callback  = function()
            local play_title = player:get_title()
            if play_title then
                -- get len
                awful.spawn.easy_async(CMD_LEN,
                    function(evil)
                        local length = evil / 1000 / 1000
                        container:get_children_by_id("progress")[1].max_value = tonumber(length)
                    end)

                awful.spawn.easy_async(CMD_POS,
                    function(evil)
                        local pos = evil
                        container:get_children_by_id("progress")[1].value = tonumber(pos)
                    end)

                awful.spawn.easy_async(CMD_STATUS,
                    function(evil)
                        local color = beautiful.accent_color
                        if not string.match("Playing\n", evil) then
                            color = beautiful.accent_alt_color_dark
                        end
                        container:get_children_by_id("status")[1].markup = markup(color, evil)
                    end)

                container:update(player:get_artist() .. " - " .. play_title:sub(1, 10))
            else
                container.visible = false
            end
        end
    }
    return container
end

local container = createWidget("Playing", "", beautiful.bg_color, beautiful.bg_color_light10)
return container
