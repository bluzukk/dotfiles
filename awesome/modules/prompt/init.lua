local beautiful = require("beautiful")
local awful     = require("awful")
local wibox     = require("wibox")
local gfs       = require("gears.filesystem")
local dpi       = require("beautiful").xresources.apply_dpi


local markup           = require("helpers.markup")
local notify           = require("helpers.notify")
local util             = require("helpers.util")

local shell            = wibox.widget.textbox()
local HISTORY_PATH     = gfs.get_cache_dir() .. '/history'

local uwuprompt_widget = wibox.widget {
    {
        shell,
        layout = wibox.layout.align.horizontal,
    },
    widget = wibox.container.place,
    align = "center",
    forced_width = dpi(300),
    forced_height = beautiful.bar_height,
}

local uwuprompt        = awful.popup {
    widget       = uwuprompt_widget,
    border_color = beautiful.border_focus,
    border_width = 0 or beautiful.border_width,
    placement    = awful.placement.top,
    shape        = beautiful.corners,
    ontop        = true,
    visible      = false,
    opacity      = beautiful.opacity,
}

-- compgen -c"
local function add_note(note)
    notify.show("Added Note", note, 2)
end


local selected = 0
local function update()
    local HISTORY = util.read_lines(HISTORY_PATH)
    rev           = {}
    for i = #HISTORY, 1, -1 do
        rev[#rev + 1] = HISTORY[i]
    end
    HISTORY = rev
    local item_widgets = {
        layout = wibox.layout.fixed.vertical,
        forced_width = 500,
        forced_height = 350,
        align = "centered"
    }
    for k, v in pairs(HISTORY) do
        if k < 4 then
            local item
            if k == selected then
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
        uwuprompt.widget = wibox.widget {
            {
                shell,
                item_widgets,
                layout = wibox.layout.align.vertical,
            },
            widget = wibox.container.place,
            align = "center",
            forced_width = dpi(300),
        }
    end
end

local function launch()
    selected = 0
    update()
    if not uwuprompt.visible then
        uwuprompt.visible = true
        awful.prompt.run {
            prompt               = "Run: ",
            bg_cursor            = beautiful.accent_color,
            textbox              = shell,
            fg_cursor            = beautiful.accent_alt_color,
            fg                   = beautiful.accent_alt_color,
            autoexec             = true,
            with_shell           = true,
            -- keypressed_callback = get_keypress,
            history_path         = HISTORY_PATH,
            exe_callback         = function(cmd) awful.spawn(cmd) end,
            done_callback        = function() uwuprompt.visible = false end,
            keyreleased_callback = function(mod, key, cmd)
                if key == "Up" then
                    selected = selected + 1
                    update()
                end
                if key == "Down" then
                    if selected > 0 then
                        selected = selected - 1
                        update()
                    end
                end
                Print(cmd)
            end,
            completion_callback  = awful.completion.shell,
            hooks                = {
                { {}, 'Return', function(cmd)
                    -- Start programs
                    if cmd:sub(string.len(cmd), string.len(cmd)) == ':' then
                        cmd = cmd:sub(1, string.len(cmd) - 1)
                        awful.spawn(beautiful.terminal .. " -e zsh -c '" .. cmd .. ";zsh'")
                        -- Add something to todo list
                    elseif cmd:sub(1, 2) == ":n" then
                        add_note(cmd)
                    elseif cmd == "rice" then
                        awful.spawn(beautiful.terminal .. " -e zsh -c 'cd /home/bluzuk/Sync/Rice/;nvim .'")
                        -- Start Program
                    elseif cmd ~= "" then
                        return cmd
                    end
                end },
            },
        }
    end
end

return {
    launch = launch
}
