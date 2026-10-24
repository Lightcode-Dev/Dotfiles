-- Loads the wallust-generated colors, falling back to defaults if
-- colors.lua doesn't exist yet (fresh install, or wallust hasn't run).

local config_dir = (os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config"))
    .. "/hypr/moodymoose-configs"

-- defaults = your original cyan/green look
local palette = {
    background = "rgb(0f111a)",
    foreground = "rgb(c0c5ce)",
    color0     = "rgb(595959)",
    color10    = "rgb(595959)",
    color12    = "rgb(33ccff)",
    color13    = "rgb(00ff99)",
}

-- pcall = "protected call": if colors.lua is missing or broken, we get
-- ok = false instead of an error that would break your whole config.
local ok, generated = pcall(dofile, config_dir .. "/colors.lua")

if ok and type(generated) == "table" then
    -- overlay the generated colors on top of the defaults
    for name, value in pairs(generated) do
        palette[name] = value
    end
end

return palette
