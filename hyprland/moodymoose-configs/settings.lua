----------------------
---- BEHAVIOR  -------
----------------------

-- The 'general' block controls the core behavior of your Hyprland session.
-- This merges with other general blocks (like in decoration.lua) because 
-- hl.config() appends and combines every call into the final configuration tree.
hl.config({
    general = {
        -- When set to true, you can click and drag the borders or gaps between 
        -- windows to resize them, making it behave closer to traditional floating window managers.
        resize_on_border = true,

        -- Allows screen tearing, which can reduce latency for competitive gaming by pushing 
        -- frames directly to the display immediately. Keep this false unless you have 
        -- specifically configured tearing rules for your games (see the Hyprland wiki).
        allow_tearing = false,

        -- Sets the default window tiling algorithm. "dwindle" splits windows 
        -- dynamically (like a spiral) based on available space. The other main option 
        -- is "master", which keeps one main window large and stacks the rest on the side.
        layout = "dwindle",
    }, 
})

-- Layout-specific options. Even though only "dwindle" is active based on the 
-- general block above, defining the others allows you to switch layout engines 
-- on the fly via binds without losing your preferred settings for them.
hl.config({
    dwindle = {
        -- When true, if you close a window, the remaining windows will retain their 
        -- original split direction (horizontal/vertical) instead of the dwindle engine 
        -- automatically recalculating and shifting your entire layout around.
        preserve_split = true,
        smart_split = true, -- If enabled, allows a more precise control over the window split direction based on the cursor’s position.
        -- The window is conceptually divided into four triangles, and cursor’s triangle determines the split direction. This feature also turns on preserve_split
    },
    master = {
        -- In the master layout, this dictates the hierarchy of new windows. 
        -- Setting it to "master" means newly opened windows automatically take 
        -- over the main/largest screen area, pushing the old master to the stack.
        new_status = "master",
    },
    scrolling = {
        -- Ensures that when scrolling through windows, the layout maintains a fullscreen 
        -- view constrained to a single column format, preventing jagged multi-column scrolling.
        fullscreen_on_one_column = true,
    },
})

-- Miscellaneous environment settings.
hl.config({
    misc = {
        -- Controls the default Hyprland background (the anime mascot).
        -- -1 sets it to pick a random mascot variant. Setting this to 0 or 1 
        -- disables the mascot entirely (highly recommended if you use tools like hyprpaper or swww).
        force_default_wallpaper = -1,
        
        -- If set to true, this removes the default Hyprland logo from the 
        -- background. Usually paired with force_default_wallpaper = 0 for a completely blank slate.
        disable_hyprland_logo   = false,
    },
})

-- Input device configuration (Keyboard, Mouse, Touchpad).
hl.config({
    input = {
        -- XKB configuration for your keyboard layout. "us" is standard QWERTY.
        -- You can configure kb_variant (e.g., "dvorak") or kb_options (e.g., "caps:swapescape" 
        -- to swap Caps Lock and Escape, popular for Vim/Emacs users).
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        -- Determines how window focus behaves with the mouse.
        -- Setting this to 1 means focus automatically follows your mouse cursor 
        -- as soon as it hovers over a new window (sloppy focus).
        follow_mouse = 1,
        
        -- Adjusts the raw mouse cursor sensitivity. 
        -- The scale goes from -1.0 (extremely slow) to 1.0 (extremely fast). 0 means flat/no scaling.
        sensitivity  = 0,

        -- Specific settings for laptop trackpads.
        touchpad = {
            -- When false, swiping down scrolls the page down (traditional PC scrolling).
            -- When true, swiping down pushes the page up (Mac-style "natural" scrolling).
            natural_scroll = false,
        },
    },
})

-- Touchpad gesture bindings.
-- This block links a physical touchpad gesture to an internal Hyprland action.
hl.gesture({
    fingers   = 3,            -- Requires exactly three fingers on the trackpad.
    direction = "horizontal", -- Triggers on horizontal (left/right) swipes.
    action    = "workspace",  -- The action executed: switches to the adjacent left/right workspace.
})
