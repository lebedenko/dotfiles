-- Launch systems and services once at startup.

hl.on("hyprland.start", function()
    hl.exec_cmd("command -v dex >/dev/null 2>&1 && dex -a -s ~/.config/autostart")
    hl.exec_cmd("command -v hyprland-per-window-layout >/dev/null 2>&1 && hyprland-per-window-layout")
end)
