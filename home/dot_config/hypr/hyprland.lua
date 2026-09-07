-- Main entrypoint. Keep requires ordered so that variables and modules
-- can load in sequence.

-- Resolve sibling modules regardless of the compositor's working directory.
local config_home = os.getenv("XDG_CONFIG_HOME")
if not config_home or config_home == "" then
    config_home = os.getenv("HOME") .. "/.config"
end
local config_dir = config_home .. "/hypr"
package.path = config_dir .. "/?.lua;" .. package.path

-- Load modules
require("monitors")
require("autostart")
require("env")
require("look_and_feel")
require("input")
require("binds")
require("rules")

-- Optional machine-specific overrides, loaded last.
local local_file = config_dir .. "/local.lua"
local file = io.open(local_file, "r")
if file then
    file:close()
    dofile(local_file)
end
