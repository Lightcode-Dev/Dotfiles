-- env.lua
-- Environment variables passed to everything Hyprland launches.

-- Cursor & Scaling
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- Wayland & Desktop Identity (Cruates stability for GTK/Qt apps)
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- Toolkit Backends (Prevents X11 fallback glitches)
hl.env("GDK_BACKEND", "wayland,x1://0.0.0.0")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")

-- Qt apps (Dolphin etc.): take colors from qt6ct, with the Fusion widget style
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_STYLE_OVERRIDE", "Fusion")
