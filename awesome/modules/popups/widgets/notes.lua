local beautiful  = require("beautiful")
local gears      = require("gears")
local wibox      = require("wibox")
local dpi        = beautiful.xresources.apply_dpi

local util       = require("helpers.util")
local markup     = require("helpers.markup")

local NOTES_FILE = os.getenv("HOME") .. '/Sync/.todo'

-- Read todo/notes
local function read_notes()
    local notes = util.read_lines(NOTES_FILE)
    if notes == nil or notes == "" then
        return "No TODOs :) have some fun!!"
    else
        local formatted = ""
        for k, v in pairs(notes) do
            if #v > 12 then
                formatted = formatted .. k .. ": " .. v:sub(1, 12) .. "\n"
            else
                formatted = formatted .. k .. ": " .. v .. "\n"
            end
        end
        return formatted
    end
end

local function create()
    local notes = {
        -- wibox.widget.calendar.month(os.date('*t'), beautiful.font_name .. " 16"),
        {
            font = beautiful.font_name .. ' 14',
            align = 'left',
            markup = markup(beautiful.accent_color, "Notes"),
            widget = wibox.widget.textbox,
        },
        {
            id = 'notes',
            font = beautiful.font_name .. ' 13',
            align = 'left',
            markup = markup(beautiful.main_color, read_notes()),
            widget = wibox.widget.textbox,
        },
        layout = wibox.layout.fixed.vertical,
        align = 'left',
        widget = wibox.container.place,
    }

    local container = wibox.widget {
        {
            {
                widget = wibox.container.place,
                halign = "center",
                valign = "center",
                forced_height = dpi(320),
                notes
            },
            widget = wibox.container.background,
            bg = beautiful.bg_color_light,
            shape = gears.shape.rounded_rect
        },
        widget = wibox.container.margin,
        margins = {
            left = beautiful.dashboard_margin,
            right = beautiful.dashboard_margin,
            bottom = beautiful.dashboard_margin,
            -- top = beautiful.dashboard_margin,
        },
    }
    return container
end

return {
    create = create
}
