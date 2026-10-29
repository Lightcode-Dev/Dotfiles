-- Window rules. See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- hl.window_rule returns a handle, so a rule can be switched off later with
-- suppressMaximizeRule:set_enabled(false) instead of deleting it.
local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps.
    name  = "suppress-maximize-events",
    match = { class = ".*" },   -- ".*" is a regex that matches every class

    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",      -- "^$" matches an empty string
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- hyprland-run is Hyprland's own launcher helper; this floats it near the bottom
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

-- kitty's theme selector: a centered floating window instead of a tiled one
hl.window_rule({
    name   = "kitty-theme-selector",
    match  = { class = "^kitty-themes$" },
    float  = true, -- Determines if the wondow should be floating instead of tiled!
    size   = "900 600", -- Sets the size of the window!
    center = true, -- Opens the window in the center of the screen!
})

-- Open specific apps on a fixed workspace.
-- Without "silent", opening the app also switches your view to that workspace.
-- With " silent", the window opens there and your current workspace stays put.
-- You can run hyprctl clients | grep -E 'class:|title:|workspace:' to list open apps and which workspace they are on.

-- Adding more later

-- The pattern is always the same: find the class, using the above command! then add a block with a match and one or more effects. 
-- Some other effects from the wiki’s list that people commonly use are float = true (floating), size = "800 600", center = true, and monitor.

-- firefox

hl.window_rule({
    name      = "firefox-on-1",
    match     = { class = "^(firefox)$" },
    workspace = "1",
})

-- Kitty terminal

hl.window_rule({
    name      = "kitty-on-2",
    match     = { class = "^(kitty)$" },
    workspace = "2"
})

-- Bitwarden

hl.window_rule({
    name      = "bitwarden-on-3",
    match     = { class = "^(Bitwarden)$" },
    workspace = "3",
})


hl.window_rule({
    name    = "dolphin-on-4",
    match   = { class = "^(org.kde.dolphin)$" },
    workspace   = "4",
})


-- Qbittorrent

hl.window_rule({
    name      = "qbittorrent-on-5-silent",
    match     = { class = "^(org\\.qbittorrent\\.qBittorrent)$" },
    workspace = "5 silent",
})

-- Element Matrix Client

hl.window_rule({
    name    = "Element-on-workspace-5",
    match   = { class = "^(Element)$" },
    workspace   = "6",
})
