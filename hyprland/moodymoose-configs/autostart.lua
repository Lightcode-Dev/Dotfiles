-------------------
---- AUTOSTART ----
-------------------

-- commands to launch once when Hyprland starts.
-- Comment a line out to disable it.
local startup = {
    "$HOME/.config/hypr/moodymoose-scripts/theme-refresh.sh --if-missing",
    "nm-applet",
    "waybar",
    "hyprpaper",
    "dunst",
    "hypridle"
}

-- "hyprland.start" fires once per session (not on config reload)
hl.on("hyprland.start", function()
    for _, cmd in ipairs(startup) do
        -- hl.exec_cmd is already asynchronous, so no "&" is needed
        hl.exec_cmd(cmd)
    end
end)
