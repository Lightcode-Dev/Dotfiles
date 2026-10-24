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
