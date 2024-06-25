-------------------------------------------------------------------------------
-- Main Panel including Taglist/Tasklist and Systeminformation               --
-------------------------------------------------------------------------------

local awful           = require("awful")
local beautiful       = require("beautiful")
local gears           = require("gears")
local wibox           = require("wibox")
local dpi             = require("beautiful").xresources.apply_dpi
local markup          = require("helpers.markup")
local notify          = require("helpers.notify")

local CMD_PROC_CPU    = [[ bash -c "ps -Ao pcpu,comm,pid --sort=-pcpu | head -n 30" ]]
local CMD_PROC_MEM    = [[ bash -c "ps -Ao pmem,comm,pid --sort=-pmem | head -n 30" ]]
local CMD_GPU         = [[ nvidia-smi  ]]
local CMD_NET         = [[ bash -c ". ~/.config/awesome/scripts/net-info" ]]
local CMD_BAT         = [[ acpi  ]]
local CMD_FILE_SYSTEM = [[ df --output=target,pcent,avail,used / /home /tmp /run -h  ]]

local color_default   = beautiful.bg_color
local color_hover     = beautiful.bg_color_light5
if beautiful.transparent_bar then
  color_default = beautiful.bg_color .. "0"
  color_hover   = beautiful.bg_color
end

-- Widgets
local function createWidget(title, onclick_cmd, _color_default, color_accent, font, is_elemental)
  local container = wibox.widget {
    {
      {
        widget = wibox.widget.textbox,
        id = "text",
        text = "Error:" .. title,
        font = font
      },
      widget  = wibox.container.margin,
      margins = {
        left  = dpi(16),
        right = dpi(16),
      },
      id      = "margins"
    },
    widget        = wibox.container.background,
    bg            = color_default,
    -- shape         = gears.shape.powerline,
    onclick       = onclick_cmd,
    title         = title,
    color_default = _color_default,
    color_accent  = color_accent,
    forced_height = dpi(48),
    update        = function(self, color, content)
      self:get_children_by_id('text')[1].markup =
          markup(color, title) .. "" ..
          markup(beautiful.main_color, content)
    end,
    hide          = function(self)
      self:get_children_by_id('text')[1].markup = ""
      self:get_children_by_id('margins')[1].margins = 0
    end

  }
  container:connect_signal("mouse::enter", function(self)
    -- if is_elemental then
    --   self.onclick.toggle()
    -- else
    --   awful.spawn.easy_async(self.onclick,
    --     function(evil)
    --       notify.show("", evil)
    --     end)
    -- end
    self.bg = self.color_accent
  end)
  container:connect_signal("mouse::leave", function(self)
    notify.hide()
    self.bg = self.color_default
  end)

  container:connect_signal("button::press", function(self)
    if is_elemental then
      self.onclick.toggle()
    else
      awful.spawn.easy_async(self.onclick,
        function(evil)
          notify.show("", evil)
        end)
    end
  end)

  return container
end


local cpu_widget = createWidget("CPU ", CMD_PROC_CPU, color_default, color_hover, beautiful.font)
awesome.connect_signal("evil::cpu", function(evil_cpu_util, evil_cpu_temp)
  local color = beautiful.accent_color
  if evil_cpu_util > 75 or evil_cpu_temp > 60 then
    color = beautiful.color_critical
  end
  cpu_widget:update(color, evil_cpu_util .. "% " .. evil_cpu_temp .. "°C")
end)

local gpu_widget = createWidget("GPU ", CMD_GPU, color_default, color_hover, beautiful.font)
awesome.connect_signal("evil::gpu", function(evil_gpu_util, evil_gpu_temp)
  local color = beautiful.accent_color
  if evil_gpu_temp > 50 then
    color = beautiful.color_critical
  end
  if evil_gpu_temp > 0 then
    gpu_widget:update(color, evil_gpu_util .. "% " .. evil_gpu_temp .. "°C")
    -- else
    --   gpu_widget:hide()
  end
end)

local ram_widget = createWidget("MEM ", CMD_PROC_MEM, color_default, color_hover, beautiful.font)
awesome.connect_signal("evil::ram", function(evil)
  local color = beautiful.accent_color
  if evil > 25000 then
    color = beautiful.color_critical
  end
  local val = string.format("%.0f", evil)
  ram_widget:update(color, val .. "mb")
end)

local disk_widget = createWidget("FS ", CMD_FILE_SYSTEM, color_default, color_hover, beautiful.font)
awesome.connect_signal("evil::disk_free", function(evil)
  disk_widget:update(beautiful.accent_color, evil .. "gb")
end)

local bat_widget = createWidget("BAT ", CMD_BAT, color_default, color_hover, beautiful.font)
awesome.connect_signal("evil::bat", function(evil_bat_perc)
  local color = beautiful.accent_color
  if evil_bat_perc then
    if evil_bat_perc < 30 then
      color = beautiful.color_critical
    end
    bat_widget:update(color, evil_bat_perc .. "%")
  else
    bat_widget:hide()
  end
end)

local net_widget = createWidget("NET ", CMD_NET, color_default, color_hover, beautiful.font)
awesome.connect_signal("evil::net_now", function(evil)
  if evil then
    evil = string.format("%04.0f", evil / 1024)
    net_widget:update(beautiful.accent_color, evil .. "kb/s")
  end
end)

if beautiful.transparent_bar then
  bg_color = beautiful.accent_color .. "0"
else
  bg_color = beautiful.bg_color
end

local systray = wibox.widget {
  {
    {
      wibox.widget.systray(),
      layout = wibox.layout.fixed.horizontal
    },
    left   = dpi(0),
    right  = dpi(0),
    top    = dpi(0),
    bottom = dpi(0),
    widget = wibox.container.margin
  },
  forced_height = dpi(10),
  forced_width  = dpi(50),
  widget        = wibox.container.background,
  bg            = bg_color_light,
  shape         = gears.shape.powerline,
}


local function create(s)
  local panel = awful.popup {
    screen = s,
    ontop = false,
    opacity = beautiful.opacity,
    -- forced_height = dpi(100),
    bg = bg_color,
    placement = function(c)
      awful.placement.top_right(c,
        { margins = { right = dpi(20), top = dpi(10) } })
    end,
    shape = beautiful.corners,
    widget = {
      layout = wibox.layout.fixed.horizontal,
      cpu_widget,
      gpu_widget,
      ram_widget,
      disk_widget,
      bat_widget,
      net_widget,
      systray,
      -- CONTROL_CENTER,
    }
  }
  return panel
end

return {
  create = create
}
