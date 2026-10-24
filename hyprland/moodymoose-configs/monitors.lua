-- Monitor setup. See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- output = ""  means "any monitor not matched by a more specific rule".
-- Later we can add one hl.monitor() per screen with exact mode, position and scale.
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})
