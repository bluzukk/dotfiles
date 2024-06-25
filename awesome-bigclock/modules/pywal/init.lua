-------------------------------------------------------------------------------
-- Allows to select and set a wallpaper                                      --
-- @TODO Care! Leaks memory to awesome!!!                                    --
-- I guess its fine since it restarts awesome after selecting a wallpaper    --
-------------------------------------------------------------------------------

local beautiful        = require("beautiful")
local awful            = require("awful")
local wibox            = require("wibox")
local gears            = require("gears")
local gfs              = require("gears.filesystem")
local xresources       = require("beautiful.xresources")
local dpi              = xresources.apply_dpi

local markup           = require("helpers.markup")
local util             = require("helpers.util")

local WALLPAPER_SCRIPT = [[ . ~/.config/awesome/scripts/randombg ]]
local SEARCH_ICON      = gfs.get_configuration_dir() .. "assets/misc/search.svg"
local SEARCH_IMG       = gears.color.recolor_image(SEARCH_ICON, beautiful.accent_color)

if WALLS_DIR == nil then
  WALLS_DIR = "~/.config/awesome/assets/wallpaper/"
  Show_Warning("Wallpaper directory missing.\nDefaulting to ~/.config/awesome/assets/wallpaper/")
end

os.execute("rm " .. WALLS_DIR .. ".walls")
os.execute("ls " .. WALLS_DIR .. " > " .. WALLS_DIR .. ".walls")
local wallpapers     = util.read_lines(WALLS_DIR .. ".walls")

local selected       = 1
local searchtext     = ""
local search_result  = wallpapers
local selected_image = ""

local preview_widget
local function update_widget()
  local widget
  if wallpapers then
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
      forced_height = 300,
      align = "centered"
    }
    for k, v in pairs(search_result) do
      if k < upper and k > lower then
        local item
        if k == selected then
          selected_image = v
          item = wibox.widget {
            {
              markup = markup(beautiful.accent_color, v),
              widget = wibox.widget.textbox,
              forced_height = dpi(45),
              align = "center"
            },
            bg = beautiful.bg_color_light5,
            widget = wibox.container.background
          }
        else
          item = wibox.widget {
            {
              text = v,
              widget = wibox.widget.textbox,
              forced_height = dpi(45),
              align = "center"
            },
            bg = beautiful.bg_color,
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
      widget = wibox.widget.textbox,
      forced_height = 40
    }

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

    widget = {
      {
        {
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
                wibox.widget.textbox(" "),
                searchbox,
                layout = wibox.layout.fixed.horizontal
              },
              widget = wibox.container.margin,
              top = dpi(12),
              bottom = dpi(10),
              left = dpi(20),
            },
            widget = wibox.container.background,
            bg = beautiful.bg_color_light5
          },
          -- spacer_widget,
          wibox.widget.textbox(" "),
          item_widgets,
          layout = wibox.layout.fixed.vertical
        },
        widget = wibox.container.margin,
        top = dpi(10),
        bottom = dpi(10),
        left = dpi(20),
        right = dpi(20),
      },
      {
        preview_widget,
        widget = wibox.container.margin,
        top = dpi(10),
        bottom = dpi(10),
        right = dpi(10),
      },
      layout = wibox.layout.fixed.horizontal,
    }
  end
  return widget
end

local wal = awful.popup {
  ontop        = true,
  visible      = true,
  shape        = gears.shape.rounded_rect,
  border_width = 1,
  placement    = awful.placement.centered,
  border_color = beautiful.bg_focus,
  opacity      = 0,
  widget       = {},
}

local grabber

local function hide()
  wal.visible = false
  awful.keygrabber.stop(grabber)
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
  wal.opacity = 1
  get_keypress()
  wal:setup(update_widget())
end


return {
  show = show,
}
