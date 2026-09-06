-- Keyboard shortcuts and bindings.
local programs = require("programs")
local mainMod = "SUPER"

-- Core System shortcuts
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("uwsm-app -- " .. programs.terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("uwsm-app -- " .. programs.fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + r", hl.dsp.exec_cmd("holonight-shell --toggle-launcher"))
hl.bind(mainMod .. " + comma", hl.dsp.exec_cmd("uwsm-app -- holonight-settings"))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = 1 })) -- Maximize
hl.bind(mainMod .. " + C", function()
	hl.dispatch("centerwindow", "")
end)

-- Move focus (HJKL) and alter stack order to top simultaneously
local function moveFocusAndRaise(dir)
	return function()
		-- Use the native Lua wrapper for focus
		hl.dispatch(hl.dsp.focus({ direction = dir }))

		-- Fallback to a raw dispatcher call for alterzorder to bypass the missing API mapping
		hl.dispatch(hl.dsp.exec_raw("alterzorder top"))
	end
end

hl.bind(mainMod .. " + h", moveFocusAndRaise("l"))
hl.bind(mainMod .. " + j", moveFocusAndRaise("d"))
hl.bind(mainMod .. " + k", moveFocusAndRaise("u"))
hl.bind(mainMod .. " + l", moveFocusAndRaise("r"))

-- Workspaces switching
for i = 1, 9 do
	hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
end
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))

-- Move window to workspace
for i = 1, 9 do
	hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- Workspace monitor movements
hl.bind(mainMod .. " + CTRL + left", function()
	hl.dispatch("movecurrentworkspacetomonitor", "l")
end)
hl.bind(mainMod .. " + CTRL + right", function()
	hl.dispatch("movecurrentworkspacetomonitor", "r")
end)

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind("CTRL + SHIFT + ALT + K", hl.dsp.workspace.toggle_special("keymapp"))

-- Scroll workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Drag / resize windows with mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Audio & Brightness laptop keys
local audio_brightness_opts = { repeating = true, locked = true }
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ --limit 1.0"),
	audio_brightness_opts
)
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), audio_brightness_opts)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), audio_brightness_opts)
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), audio_brightness_opts)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"), audio_brightness_opts)
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), audio_brightness_opts)

-- Media controller
local media_opts = { locked = true }
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), media_opts)
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), media_opts)
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), media_opts)
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), media_opts)

-- Custom helper scripts
hl.bind(mainMod .. " + CTRL + h", hl.dsp.exec_cmd("~/.local/bin/hide-unhide-window.sh h"))
hl.bind(mainMod .. " + CTRL + i", hl.dsp.exec_cmd("~/.local/bin/hide-unhide-window.sh s"))
hl.bind(mainMod .. " + ALT + P", hl.dsp.exec_cmd("~/.local/bin/screenshot.sh"))

-- Multi-key chord binds (Ctrl+Shift+Alt chords)
hl.bind("CTRL + SHIFT + ALT + d", hl.dsp.exec_cmd("uwsm-app -- datagrip"))
hl.bind("CTRL + SHIFT + ALT + g", hl.dsp.exec_cmd("uwsm-app -- google-chrome-stable"))
hl.bind("CTRL + SHIFT + ALT + t", hl.dsp.exec_cmd("uwsm-app -- teams-for-linux"))
hl.bind("CTRL + SHIFT + ALT + p", hl.dsp.exec_cmd("uwsm-app -- postman"))
hl.bind("CTRL + SHIFT + ALT + v", hl.dsp.exec_cmd("uwsm-app -- pwvucontrol"))
hl.bind("CTRL + SHIFT + ALT + b", hl.dsp.exec_cmd("uwsm-app -- blender"))
hl.bind("CTRL + SHIFT + ALT + f", hl.dsp.exec_cmd("uwsm-app -- freecad"))
hl.bind("CTRL + SHIFT + ALT + i", hl.dsp.exec_cmd("uwsm-app -- inkscape"))
hl.bind(
	"CTRL + SHIFT + ALT + a",
	hl.dsp.exec_cmd("printf 'chat:toggle:' | nc -N -U \"$XDG_RUNTIME_DIR/holonight-shell/control.sock\"")
)

hl.bind("CTRL + SHIFT + ALT + SUPER + p", hl.dsp.exec_cmd("uwsm-app -- keepassxc"))
hl.bind("CTRL + SHIFT + ALT + SUPER + g", hl.dsp.exec_cmd("uwsm-app -- gimp"))
hl.bind("CTRL + SHIFT + ALT + SUPER + i", hl.dsp.exec_cmd("uwsm-app -- qview"))

-- Extra special keybinds
hl.bind("XF86Calculator", hl.dsp.exec_cmd("uwsm-app -- kcalc"), { repeating = true, locked = true })
hl.bind("XF86Macro1", hl.dsp.exec_cmd("uwsm-app -- teams-for-linux"), { repeating = true, locked = true })
