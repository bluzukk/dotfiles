local beautiful = require("beautiful")
local awful     = require("awful")
local wibox     = require("wibox")
local gfs       = require("gears.filesystem")
local dpi       = require("beautiful").xresources.apply_dpi

local markup    = require("helpers.markup")
local notify    = require("helpers.notify")

local shell = wibox.widget.textbox()

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

local uwuprompt = awful.popup {
    widget       = uwuprompt_widget,
    border_color = beautiful.border_focus,
    border_width = 0 or beautiful.border_width,
    placement = function(c) awful.placement.top(c, { margins = { top = dpi(10) }}) end,
    shape        = beautiful.corners,
    ontop        = true,
    visible      = false,
    opacity      = 1,
}

-- compgen -c"
local function add_note(note)
    notify.show("Added Note", note, 2)
end

local function launch()
    if not uwuprompt.visible then
        uwuprompt.visible = true
        awful.prompt.run {
            prompt              = "",
            bg_cursor           = beautiful.bg_color .. "0",
            textbox             = shell,
            fg_cursor           = beautiful.accent_color,
            fg = beautiful.accent_color,
            autoexec            = true,
            with_shell          = true,
            -- keypressed_callback = get_keypress,
            history_path        = gfs.get_cache_dir() .. '/history',
            exe_callback        = function(cmd) awful.spawn(cmd) end,
            done_callback       = function() uwuprompt.visible = false end,
            completion_callback = awful.completion.shell,
            hooks               = {
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
