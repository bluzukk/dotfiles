-------------------------------------------------------------------------------
-- Beautiful
-------------------------------------------------------------------------------
local gears         = require("gears")
local xresources    = require("beautiful.xresources")
local xrdb          = xresources.get_current_theme()
local dpi           = xresources.apply_dpi
local rnotification = require("ruled.notification")
local lama          = require("helpers.lama")

local theme = {}

---------------------------------------------------------------------------------
-- Theme Variables
---------------------------------------------------------------------------------
theme.font_name = "Cascadia Code"
theme.font_size = "14"
theme.font      = theme.font_name .. " " .. theme.font_size

theme.corners = gears.shape.rect
-- If not using picom
-- theme.shape = function(cr,w,h)
--     gears.shape.rounded_rect(cr,w,h,8)
-- end

-- theme.corners = gears.shape.rect
theme.corners = function(cr,w,h)
    gears.shape.rounded_rect(cr,w,h,8)
end

-- Mostly used in bars
theme.inner_corners = function(cr,w,h)
    gears.shape.rounded_rect(cr,w,h,8)
end

theme.opacity      = 0.8
theme.useless_gap  = dpi(10)
theme.border_width = dpi(4)

theme.master_width_factor = 0.689
theme.tasklist_plain_task_name = false
theme.tasklist_disable_icon = true

-- Other Settings
theme.modkey = "Mod4"
theme.altkey = "Mod1"

---------------------------------------------------------------------------------
-- Default Apps
---------------------------------------------------------------------------------
theme.terminal = "st -f '" .. theme.font_name .. ":size=".. theme.font_size .. "'"
theme.shell       = "zsh"
theme.browser     = "librewolf"
theme.browser_alt = "firefox"
theme.editor      = "nvim"

---------------------------------------------------------------------------------
-- Panel and Dashboard Settings
---------------------------------------------------------------------------------
theme.bar_height        = dpi(40)
theme.panel_right_width = dpi(550)
theme.dashboard_width   = dpi(500)
theme.dashboard_margin  = dpi(30)
theme.dashboard_height  = dpi(1388)

theme.enable_tasklist   = false

---------------------------------------------------------------------------------
-- Colors
---------------------------------------------------------------------------------
-- Main xresources colors
theme.accent_color        = xrdb.color4 or "#000000"
theme.accent_alt_color    = xrdb.color2 or "#000000"
theme.main_color          = xrdb.foreground or "#000000"
theme.bg_color            = lama.lighten(xrdb.background, 0)

-- Adjusted colors thanks to lama
theme.bg_color_light      = lama.lighten(theme.bg_color, 2)
theme.bg_color_dark       = lama.lighten(theme.bg_color, -2)

theme.accent_color_light  = lama.lighten(theme.accent_color, 3)
theme.accent_color_dark   = lama.lighten(theme.accent_color, -3)

theme.accent_alt_color_light  = lama.lighten(theme.accent_alt_color, 3)
theme.accent_alt_color_dark   = lama.lighten(theme.accent_alt_color, -3)

theme.main_color_light  = lama.lighten(theme.main_color, 2)
theme.main_color_dark   = lama.lighten(theme.main_color, -2)

-- Reactive colors
theme.color_default       = theme.main_color
theme.color_moderate      = xrdb.color6
theme.color_stress        = xrdb.color8
theme.color_critical      = "#e54c62" -- surprise: its red

-- Default BG colors
theme.bg_normal           = theme.bg_color
theme.bg_focus            = theme.bg_color
theme.bg_urgent           = theme.bg_color
theme.bg_minimize         = theme.bg_color
theme.bg_systray          = theme.bg_color
theme.bg_bar_outer        = theme.bg_color
theme.bg_bar_inner        = theme.bg_color

-- Default FG colors
theme.fg_normal           = theme.main_color
theme.fg_focus            = theme.accent_color
theme.fg_urgent           = theme.color_critical
theme.fg_minimize         = theme.main_color

-- Border Color
theme.border_color_normal = theme.bg_color
theme.border_color_active = theme.bg_color
theme.border_color_marked = theme.bg_color

-- Taglist
theme.taglist_bg_focus    = theme.bg_bar_inner
theme.taglist_fg_focus    = theme.accent_color
theme.taglist_fg_empty    = theme.main_color
theme.taglist_fg_occupied = theme.main_color
theme.taglist_fg_urgent   = theme.main_color
theme.taglist_bg_urgent   = theme.color_critical
-- theme.taglist_fg_focus    = theme.accent_alt_color
-- theme.taglist_bg_occupied = theme.bg_color

-- Tasklsit
theme.tasklist_fg_focus   = theme.accent_color
theme.tasklist_fg_normal  = theme.main_color
theme.tasklist_bg_focus   = theme.bg_color
theme.tasklist_bg_normal  = theme.bg_color

-- Notifications
theme.notification_shape        = theme.shape
theme.notification_bg           = theme.bg_color
theme.notification_fg           = theme.main_color
theme.notification_border_color = theme.accent_color

---------------------------------------------------------------------------------
-- Taglist Squares
---------------------------------------------------------------------------------
-- local taglist_square_size = dpi(20)
-- theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
--     taglist_square_size, theme.accent_color
-- )
-- theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
--     taglist_square_size, theme.accent_color
-- )

-- Set different colors for urgent notifications.
rnotification.connect_signal('request::rules', function()
    rnotification.append_rule {
        rule       = { urgency = 'critical' },
        properties = { bg = theme.bg_color, fg = theme.color_critical }
    }
end)

---------------------------------------------------------------------------------
-- Notifications Settings
---------------------------------------------------------------------------------
local naughty = require("naughty")
naughty.config.defaults.ontop = true
naughty.config.defaults.timeout = 3
naughty.config.defaults.title = "System Notification"
naughty.config.defaults.margin = dpi(10)
-- naughty.config.defaults.position = "top_right"

-- For debugging
function Print(title, text)
    naughty.notify {
        title = title,
        text = text,
        bg = theme.bg_color,
        height = dpi(100),
        width  = dpi(200),
        position = "top_left"
    }
end

return theme