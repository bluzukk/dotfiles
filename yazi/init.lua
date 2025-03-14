-- require("no-status"):setup()

-- ~/.config/yazi/init.lua
function Linemode:size()
	local size = self._file:size()
	return string.format("%s", size and ya.readable_size(size) or " ")
end

Status:children_add(function()
	local h = cx.active.current.hovered
	if h == nil or ya.target_family() ~= "unix" then
		return ""
	end

	return ui.Line {
		ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
		":",
		ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
		" ",
	}
end, 500, Status.RIGHT)

local root_layout = Root.layout
Root.layout = function(self, ...)
  root_layout(self, ...)
  local tab, status = self._chunks[2], self._chunks[3]
  if tab.h > 0 then
    tab.h = tab.h - 1
    status.h, status.y = status.h + 1, status.y - 1
  end
end

-- local function setup()
-- 	local old_layout = Tab.layout
--
-- 	Status.redraw = function() return {} end
-- 	Tab.layout = function(self, ...)
-- 		self._area = ui.Rect { x = self._area.x, y = self._area.y, w = self._area.w, h = self._area.h + 1 }
-- 		return old_layout(self, ...)
-- 	end
-- end
--
-- setup()
