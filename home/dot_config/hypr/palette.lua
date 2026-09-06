-- TokyoNight Storm palette and HoloNight theme mapping.
local M = {}

M.background           = "10131f"
M.surface              = "161925"
M.surfaceElevated      = "1a1b26"
M.panel                = "24283b"
M.borderMuted          = "565f89"
M.text                 = "c0caf5"
M.textMuted            = "a9b1d6"
M.cyan                 = "7dcfff"
M.blue                 = "7aa2f7"
M.violet               = "bb9af7"
M.green                = "9ece6a"
M.orange               = "ff9e64"
M.red                  = "f7768e"

-- Compatibility aliases
M.teal                 = M.cyan
M.surface1             = M.borderMuted
M.base                 = M.background

-- Helpers for color formats
function M.rgba(hex, alpha)
    return "rgba(" .. hex .. alpha .. ")"
end

function M.rgb(hex)
    return "rgb(" .. hex .. ")"
end

return M
