----------------------
---- BEHAVIOR  -------
----------------------

-- The rest of "general". This merges with the general block in
-- decoration.lua, because hl.config() combines every call.
hl.config({
    general = {
        -- true lets you resize by dragging window borders and gaps
        resize_on_border = false,

        -- see the Tearing page on the wiki before turning this on
        allow_tearing = false,

        layout = "dwindle",
    },
})

-- Layout options. Only the layout named above is active,
-- but the others are ready if you switch.
hl.config({
    dwindle = {
        preserve_split = true,  -- keep the split direction when windows close
    },
    master = {
        new_status = "master",  -- new windows become the master
    },
    scrolling = {
        fullscreen_on_one_column = true,
    },
})

-- Miscellaneous
hl.config({
    misc = {
        force_default_wallpaper = -1,     -- -1 = random; 0 or 1 turns off the anime mascot
        disable_hyprland_logo   = false,  -- true removes the logo background
    },
})

-- Input
hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,    -- focus follows the mouse
        sensitivity  = 0,    -- -1.0 to 1.0; 0 = no change

        touchpad = {
            natural_scroll = false,
        },
    },
})

-- Three-finger swipe to change workspace (touchpads only)
hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})
