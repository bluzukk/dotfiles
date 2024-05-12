-------------------------------------------------------------------------------
--            __          ________  _____  ____  __  __ ______               --
--           /\ \        / /  ____|/ ____|/ __ \|  \/  |  ____|              --
--          /  \ \  /\  / /| |__  | (___ | |  | | \  / | |__                 --
--         / /\ \ \/  \/ / |  __|  \___ \| |  | | |\/| |  __|                --
--        / ____ \  /\  /  | |____ ____) | |__| | |  | | |____               --
--       /_/    \_\/  \/   |______|_____/ \____/|_|  |_|______|              --
--                                                                           --
-------------------------------------------------------------------------------

local PRIVATE = os.getenv("HOME") .. "/Sync/Rice/_private"
WALLS_DIR = PRIVATE .. "/assets/wallpaper/"
LAT = PRIVATE .. "/gps-latitude"
LONG = PRIVATE .. "/gps-longtiude"
API_KEY = PRIVATE .. "/gps-owm-api-key"

require("helpers.errors")

THEME = "/.config/awesome/config/settings.lua"
require("beautiful").init(os.getenv("HOME") .. THEME)

require("config.keybinds")
require("config.clients")

require("evil.cpu")
require("evil.gpu")
require("evil.netw")
require("evil.disk")
require("evil.ram")
require("evil.mail")
require("evil.bat")

LEFT_POPUP = require("modules.popups.left-board")
PANEL = require("modules.panel")
PANEL.create_screens()

require("helpers.autostart")
