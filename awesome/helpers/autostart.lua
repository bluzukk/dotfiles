local awful = require("awful")

-- {{{ Autostart programs
local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
    end
end

-- run_once({"xcompmgr", "setxkbmap de"})
run_once({"picom", "setxkbmap de"})
