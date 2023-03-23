local beautiful        = require("beautiful")
local awful            = require("awful")
local wibox            = require("wibox")
local gears            = require("gears")
local gfs              = require("gears.filesystem")
local xresources       = require("beautiful.xresources")
local dpi              = xresources.apply_dpi

local markup           = require("helpers.markup")
local util             = require("helpers.util")

local WALLPAPER_SCRIPT = "randombg"
local SEARCH_ICON      = gfs.get_configuration_dir() .. "assets/misc/search.svg"
local SEARCH_IMG       = gears.color.recolor_image(SEARCH_ICON, beautiful.accent_color)

os.execute("rm " .. WALLS_DIR .. ".walls")
os.execute("ls " .. WALLS_DIR .. " > " .. WALLS_DIR .. ".walls")
local wallpapers     = util.read_lines(WALLS_DIR .. ".walls")

local selected       = 1
local searchtext     = ""
local search_result  = wallpapers
local selected_image = ""


local spacer_widget = {
    color         = beautiful.accent_color,
    shape         = gears.shape.rect,
    widget        = wibox.widget.separator,
    forced_height = 2,
    forced_width  = 20,
    span_ratio    = 0.95,
}

local preview_widget
local function update_widget()
    search_result = {}
    if #searchtext > 1 then
        for _, v in pairs(wallpapers) do
            if string.match(v, searchtext) then
                search_result[#search_result + 1] = v
            end
        end
    else
        search_result = wallpapers
    end

    local lower = selected - 4
    local upper = selected + 4
    if lower < 1 then upper = upper - lower end
    if upper > #search_result then lower = lower - (upper - #search_result) end

    local item_widgets = {
        layout = wibox.layout.fixed.vertical,
        forced_width = 500,
        forced_height = 350,
        align = "centered"
    }
    for k, v in pairs(search_result) do
        if k < upper and k > lower then
            local item
            if k == selected then
                selected_image = v
                item = wibox.widget {
                    {
                        font = beautiful.font_name .. ' 18',
                        markup = markup(beautiful.accent_color, v),
                        widget = wibox.widget.textbox,
                        forced_height = dpi(50),
                        align = "center"
                    },
                    bg = beautiful.bg_focus,
                    widget = wibox.container.background
                }
            else
                item = wibox.widget {
                    {
                        text = v,
                        widget = wibox.widget.textbox,
                        forced_height = dpi(50),
                        align = "center"
                    },
                    bg = beautiful.bg_normal,
                    widget = wibox.container.background
                }
            end
            table.insert(item_widgets, item)
        end
    end

    local searchbox = {
        id = 'textbox',
        font = beautiful.font_name .. ' 18',
        align = 'center',
        markup = markup(beautiful.accent_color, searchtext),
        -- markup = markup(beautiful.accent_color, searchtext .. "  ") .. markup(beautiful.main_color, #search_result .. " Wallpapers found"),
        widget = wibox.widget.textbox,
        forced_height = 40
    }

    -- Setup image
    preview_widget = {
        id = 'icon',
        image = WALLS_DIR .. selected_image,
        resize = true,
        forced_width = dpi(700),
        forced_height = dpi(40),
        widget = wibox.widget.imagebox,
        opacity = 1,
        align = "center"
    }

    local spr = wibox.widget.textbox(" ")
    local widget = {
        {
            {
                {
                    {
                        image = SEARCH_IMG,
                        resize = true,
                        forced_width = 32,
                        forced_height = 32,
                        widget = wibox.widget.imagebox,
                        align = "center"
                    },
                    spr,
                    searchbox,
                    layout = wibox.layout.fixed.horizontal
                },
                widget = wibox.container.margin,
                top = dpi(10),
                left = dpi(10),
            },
            spacer_widget,
            item_widgets,
            layout = wibox.layout.fixed.vertical
        },
        wibox.widget.textbox("  "),
        {
            preview_widget,
            widget = wibox.container.margin,
            top = dpi(10),
            bottom = dpi(10),
            right = dpi(10),
        },
        layout = wibox.layout.fixed.horizontal,
    }
    return widget
end

local wal = awful.popup {
    ontop        = true,
    visible      = true,
    shape        = gears.shape.rounded_rect,
    border_width = 1,
    placement    = awful.placement.centered,
    border_color = beautiful.bg_focus,
    widget       = {},
}

local grabber

local function hide()
    wal.visible = false
    awful.keygrabber.stop(grabber)
    -- wal:setup({layout = wibox.layout.fixed.vertical})
end

local function get_keypress()
    grabber = awful.keygrabber.run(function(_, key, event)
        if event == "release" then return end
        -- if event == "press" then notify.show("PRESSED BUTTON", key) end
        if key == 'Up' then
            if selected > 1 then
                selected = selected - 1
                wal:setup(update_widget())
            end
        elseif key == 'Down' then
            if selected < #search_result then
                selected = selected + 1
                wal:setup(update_widget())
            end
        elseif key == 'Return' then
            os.execute(WALLPAPER_SCRIPT .. " " .. WALLS_DIR .. selected_image)
            awesome.restart()
        elseif key == "Escape" then
            hide()
        elseif key == "BackSpace" then
            selected = 1
            searchtext = searchtext:sub(1, -2)
            wal:setup(update_widget())
        elseif #key == 1 then
            selected = 1
            searchtext = searchtext .. key
            wal:setup(update_widget())
        end
    end)
end

local function show()
    wal.visible = true
    get_keypress()
    wal:setup(update_widget())
end

return {
    show = show,
}
