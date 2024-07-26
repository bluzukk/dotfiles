local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gfs = require("gears.filesystem")
local dpi = require("beautiful").xresources.apply_dpi
local markup = require("helpers.markup")
local util = require("helpers.util")

local art = [[ ]]

local searching_history = false
local shell = wibox.widget.textbox()
local HISTORY_PATH = gfs.get_cache_dir() .. "/history"

local prompt_widget = wibox.widget({
	{
		shell,
		layout = wibox.layout.align.horizontal,
	},
	widget = wibox.container.place,
	align = "center",
})

local prompt = awful.popup({
	widget = prompt_widget,
	border_color = beautiful.border_focus,
	border_width = 0 or beautiful.border_width,
	placement = awful.placement.centered,
	shape = beautiful.corners,
	ontop = true,
	visible = false,
	opacity = beautiful.opacity,
})

-- compgen -c"

local HISTORY
local selected = 0
local function update()
	local item_widgets = {
		layout = wibox.layout.fixed.vertical,
		forced_width = dpi(600),
		forced_height = dpi(240),
		align = "centered",
	}
	HISTORY = util.read_lines(HISTORY_PATH)
	if searching_history then
		local rev = {}
		if HISTORY then
			for i = #HISTORY, 1, -1 do
				rev[#rev + 1] = HISTORY[i]
			end
			HISTORY = rev

			local lower = selected - 3
			local upper = selected + 3
			if lower < 1 then
				upper = upper - lower
			end
			if upper > #HISTORY then
				lower = lower - (upper - #HISTORY)
			end

			for k, v in pairs(HISTORY) do
				if k < upper and k > lower then
					local item
					if k == selected then
						item = wibox.widget({
							{
								{
									font = beautiful.font_name .. " 16",
									markup = markup(beautiful.accent_color, v),
									widget = wibox.widget.textbox,
									forced_height = dpi(50),
									align = "left",
								},
								widget = wibox.container.margin,
								left = dpi(20),
							},
							widget = wibox.container.background,
						})
					else
						item = wibox.widget({
							{
								{
									text = v,
									font = beautiful.font_name .. " 16",
									widget = wibox.widget.textbox,
									forced_height = dpi(50),
									align = "left",
								},
								widget = wibox.container.margin,
								left = dpi(20),
							},
							bg = beautiful.bg_normal .. "0",
							widget = wibox.container.background,
						})
					end
					table.insert(item_widgets, item)
				end
			end
		end
	else
		local placeholder = wibox.widget.textbox()
		placeholder.text = art
		table.insert(item_widgets, placeholder)
	end
	prompt.widget = wibox.widget({
		{
			{
				{
					{
						shell,
						spacing = dpi(20),
						layout = wibox.layout.fixed.horizontal,
					},
					widget = wibox.container.margin,
					top = dpi(20),
					left = dpi(20),
					right = dpi(50),
					bottom = dpi(20),
				},
				bg = beautiful.bg_color_light5,
				widget = wibox.container.background,
			},
			wibox.widget.textbox("   "),
			item_widgets,
			spacing = dpi(20),
			layout = wibox.layout.align.vertical,
		},

		widget = wibox.container.margin,
		top = dpi(50),
		left = dpi(50),
		right = dpi(50),
		bottom = dpi(50),
	})
end

local function launch()
	selected = 0
	update()
	prompt.screen = awful.screen.focused()
	if not prompt.visible then
		prompt.visible = true
		awful.prompt.run({
			prompt = "",
			bg_cursor = beautiful.accent_color,
			textbox = shell,
			fg_cursor = beautiful.accent_alt_color,
			fg = beautiful.accent_alt_color,
			font = beautiful.font_name .. " 20",
			-- autoexec             = true,
			with_shell = true,
			-- keypressed_callback = get_keypress,
			history_path = HISTORY_PATH,
			exe_callback = function(cmd)
				awful.spawn(cmd)
			end,
			done_callback = function()
				prompt.visible = false
			end,
			keyreleased_callback = function(mod, key, cmd)
				if key == "Up" then
					searching_history = true
					if selected < #HISTORY then
						selected = selected + 1
						update()
					end
				elseif key == "Down" then
					searching_history = true
					if selected > 0 then
						selected = selected - 1
						update()
					end
				else
					-- update()
					-- selected = 0
				end
			end,
			completion_callback = awful.completion.shell,
			hooks = {
				{
					{},
					"Return",
					function(cmd)
						searching_history = false
						-- Start programs
						if cmd:sub(string.len(cmd), string.len(cmd)) == ":" then
							cmd = cmd:sub(1, string.len(cmd) - 1)
							awful.spawn(beautiful.terminal .. " -e zsh -c '" .. cmd .. ";zsh'")
						-- Add something to todo list
						elseif cmd:sub(1, 1) == "/" then
							awful.spawn(
								beautiful.browser .. " https://www.google.com/search?q='" .. cmd:sub(2, #cmd) .. "'"
							)
						elseif cmd == "bye" then
							awful.spawn(beautiful.terminal .. " poweroff")
						elseif cmd ~= "" then
							return cmd
						end
					end,
				},
				{
					{},
					"Escape",
					function(_)
						update()
						searching_history = false
					end,
				},
			},
		})
	end
end

return {
	launch = launch,
}
