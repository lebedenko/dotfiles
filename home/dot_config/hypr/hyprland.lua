-- Main entrypoint. Keep requires ordered so that variables and modules
-- can load in sequence.

-- Load modules
require("monitors")
require("autostart")
require("env")
require("look_and_feel")
require("input")
require("binds")
require("rules")

-- Optional machine-specific overrides, loaded last.
local config_dir = (os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")) .. "/hypr"
local local_file = config_dir .. "/local.lua"
local file = io.open(local_file, "r")
if file then
    file:close()
    dofile(local_file)
end
