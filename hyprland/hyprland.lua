-- hyprland.lua
-- Wiki: https://wiki.hypr.land/Configuring/Start/
-- Everything lives in ~/.config/hypr/moodymoose-configs/.
-- Order matters a little: hardware and environment first, then look and
-- behavior, then rules, then keybinds and autostart.

require("moodymoose-configs/monitors")
require("moodymoose-configs/env")
require("moodymoose-configs/decoration")
require("moodymoose-configs/settings")
require("moodymoose-configs/rules")
require("moodymoose-configs/keybinds")
require("moodymoose-configs/autostart")
