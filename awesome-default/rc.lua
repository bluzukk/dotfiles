-------------------------------------------------------------------------------
--            __          ________  _____  ____  __  __ ______               --
--           /\ \        / /  ____|/ ____|/ __ \|  \/  |  ____|              --
--          /  \ \  /\  / /| |__  | (___ | |  | | \  / | |__                 --
--         / /\ \ \/  \/ / |  __|  \___ \| |  | | |\/| |  __|                --
--        / ____ \  /\  /  | |____ ____) | |__| | |  | | |____               --
--       /_/    \_\/  \/   |______|_____/ \____/|_|  |_|______|              --
--                                                                           --
-------------------------------------------------------------------------------

----- Debug Messages ----------------------------------------------------------
require("helpers.errors")
local naughty = require("naughty")
function Show_Warning(message)
  naughty.notify {
    preset = naughty.config.presets.critical,
    title = "ERROR :(",
    text = message,
    position = "top_middle"
  }
end

----- Set wallpaper dir, latitude, longitude, and OWM key files ---------------
local PRIVATE = os.getenv("HOME") .. "/Sync/Rice/_private"
WALLS_DIR = PRIVATE .. "/assets/wallpaper/"
LAT_FILE = PRIVATE .. "/gps-latitude"
LONG_FILE = PRIVATE .. "/gps-longtiude"
API_KEY_FILE = PRIVATE .. "/gps-owm-api-key"


THEME = "/.config/awesome/config/settings.lua"
require("beautiful").init(os.getenv("HOME") .. THEME)


----- Signals -----------------------------------------------------------------
require("evil.cpu")
require("evil.gpu")
require("evil.netw")
require("evil.disk")
require("evil.ram")
require("evil.mail")
require("evil.bat")

----- Modules -----------------------------------------------------------------
WALLPAPER_SELECTOR = require("modules.pywal")
PROMPT             = require("modules.prompt")
VOLUME             = require("modules.popups.volume")
LEFT_POPUP         = require("modules.popups.left-board")
-------------------------------------------------------------------------------

require("helpers.autostart")
require("config.keybinds")
require("config.clients")

PANEL = require("modules.panel")
PANEL.create_screens()
