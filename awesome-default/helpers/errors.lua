-------------------------------------------------------------------------------
-- Error handling                                                            --
-------------------------------------------------------------------------------
local naughty = require("naughty")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "Errors! Loading fallback config!",
    text = awesome.startup_errors,
  })
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function(err)
    if in_error then
      return
    end
    in_error = true
    naughty.notify({
      title = "Runtime error =( Fix this:",
      text = tostring(err),
      font = "Cascadia Code 16",
    })
    in_error = false
  end)
end
