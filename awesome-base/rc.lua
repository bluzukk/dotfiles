-------------------------------------------------------------------------------
--            __          ________  _____  ____  __  __ ______               --
--           /\ \        / /  ____|/ ____|/ __ \|  \/  |  ____|              --
--          /  \ \  /\  / /| |__  | (___ | |  | | \  / | |__                 --
--         / /\ \ \/  \/ / |  __|  \___ \| |  | | |\/| |  __|                --
--        / ____ \  /\  /  | |____ ____) | |__| | |  | | |____               --
--       /_/    \_\/  \/   |______|_____/ \____/|_|  |_|______|              --
--                                                                           --
-------------------------------------------------------------------------------

---- Variables ----------------------------------------------------------------
local PRIVATE = os.getenv("HOME") .. "/Sync/Rice/_private"
-- Path to your
AVATAR = PRIVATE .. "/assets/korin.jpg"     -- ... Avatar
WALLS_DIR = PRIVATE .. "/assets/wallpaper/" -- ... Wallpaper collection
LAT = PRIVATE .. "/gps-latitude"            -- ... Latitude
LONG = PRIVATE .. "/gps-longtiude"          -- ... Longtiude
API_KEY = PRIVATE .. "/gps-owm-api-key"     -- ... OWM API key

---- Error Handling -----------------------------------------------------------
require("helpers.errors")

---- Init BEAUTIFUL -----------------------------------------------------------
local feels_like = os.getenv("HOME")
require("beautiful").init(feels_like .. "/.config/awesome/config/settings.lua")

---- Load Keybinds ------------------------------------------------------------
require("config.keybinds")
require("config.clients")

---- Start Evil Monitoring ----------------------------------------------------
require("evil.cpu")
require("evil.gpu")
require("evil.netw")
require("evil.disk")
require("evil.ram")
require("evil.mail")
require("evil.bat")

---- UI Components ------------------------------------------------------------
LEFT_POPUP = require("modules.popups.left-board")
PANEL = require("modules.panel")
-- powermenu = require "modules.powermenu"

PANEL.create_screens()


---- Autostart Apps -----------------------------------------------------------
require("helpers.autostart")
