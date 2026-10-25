-----------------------
-- CUSTOM KEYBINDINGS--
-----------------------
local programs = require("moodymoose-configs/programs")
local terminal, fileManager, menu = programs.terminal, programs.fileManager, programs.menu

-- only keybinds uses this, so it stays local to this file
local mainMod = "SUPER"

-- Your binds
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))      -- launch terminal
hl.bind(mainMod .. " + Q", hl.dsp.window.close())          -- close focused window
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("$HOME/.config/hypr/moodymoose-scripts/wallpaper-select.sh"))  -- wallpaper picker script!
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("pidof hyprlock || hyprlock"))   -- lock screen
hl.bind(mainMod .. " + CTRL + K",  hl.dsp.exec_cmd("kitty --class kitty-themes -e kitten themes --reload-in=all"))  -- kitty's theme selector
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("kitten themes --reload-in=all Wallust </dev/null"))  -- snap kitty back to the wallpaper theme
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("$HOME/.config/hypr/moodymoose-scripts/power-menu.sh"))  -- power menu
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("$HOME/.config/hypr/moodymoose-scripts/dnd.sh toggle"))  -- do not disturb
-- Default binds
-- Exit Hyprland: use hyprshutdown if installed, otherwise fall back to a plain exit
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))                 -- file manager
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))   -- toggle floating
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))                        -- app launcher
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())                       -- pseudotile
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))                 -- dwindle only

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Workspaces: mainMod + [0-9] switches, mainMod + SHIFT + [0-9] moves the window
for i = 1, 10 do
    local key = i % 10  -- workspace 10 maps to the 0 key
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll wheel
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + left/right mouse button and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Volume and brightness keys
-- locked = works even on the lock screen, repeating = holding the key repeats it
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Media keys (requires playerctl)
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- screenshots: Print = region, Shift+Print = whole screen, Super+Print = focused window
local shot = "$HOME/.config/hypr/moodymoose-scripts/screenshot.sh"
hl.bind("Print",               hl.dsp.exec_cmd(shot .. " region"))
hl.bind("SHIFT + Print",       hl.dsp.exec_cmd(shot .. " screen"))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd(shot .. " window"))

-- same as Print, for keyboards without a Print key
hl.bind(mainMod .. " + CTRL + S", hl.dsp.exec_cmd(shot .. " region"))
