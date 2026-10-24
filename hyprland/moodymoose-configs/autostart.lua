-------------------
---- AUTOSTART ----
-------------------

-- Locals don't cross file boundaries, so redefine anything you use here
local terminal = "kitty"

-- "hyprland.start" fires once when Hyprland launches.
-- hl.on(event, function) registers the function to run when that event happens.
hl.on("hyprland.start", function()
    -- hl.exec_cmd(cmd) runs a command, same as the one inside hl.bind
    -- hl.exec_cmd(terminal)
     hl.exec_cmd("nm-applet")
     hl.exec_cmd("waybar & hyprpaper & dunst")  -- "&" backgrounds each one
end)
