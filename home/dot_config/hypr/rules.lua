-- Window, Layer, and Workspace Rules.

-- Smart gaps workspace definitions
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })

-- Smart gaps border/rounding overrides
hl.window_rule({ name = "smart-gaps-border-wtv1", match = { workspace = "w[tv1]", float = false }, border_size = 0 })
hl.window_rule({ name = "smart-gaps-rounding-wtv1", match = { workspace = "w[tv1]", float = false }, rounding = 0 })
hl.window_rule({ name = "smart-gaps-border-f1", match = { workspace = "f[1]", float = false }, border_size = 0 })
hl.window_rule({ name = "smart-gaps-rounding-f1", match = { workspace = "f[1]", float = false }, rounding = 0 })

-- Application workspace rules
hl.window_rule({ name = "chrome-workspace", match = { class = "^google-chrome$" }, workspace = 1 })
hl.window_rule({ name = "postman-workspace", match = { class = "^Postman$" }, workspace = 4 })
hl.window_rule({ name = "datagrip-workspace", match = { class = "^jetbrains-datagrip$" }, workspace = 5 })

-- Floating & sizing window rules
hl.window_rule({ name = "portal-gtk-float", match = { class = "^xdg-desktop-portal-gtk$" }, float = true })
hl.window_rule({
	name = "gnome-calculator-float",
	match = { class = "^org\\.gnome\\.Calculator$" },
	float = true,
})
hl.window_rule({
	name = "keymapp-rules",
	match = { class = "^keymapp$" },
	float = true,
	size = "800 600",
	workspace = "special:keymapp silent",
	no_initial_focus = true,
})
hl.window_rule({
	name = "teams-for-linux",
	match = { class = "^teams-for-linux$" },
	float = true,
	size = "1200 900",
})
hl.window_rule({
	name = "keepassxc",
	match = { class = "^org\\.keepassxc\\.KeePassXC$" },
	float = true,
	size = "800 600",
})
hl.window_rule({
	name = "rog-control-center",
	match = { class = "^rog-control-center$" },
	float = true,
	size = "1200 900",
})
hl.window_rule({
	name = "blueman-manager",
	match = { class = "^blueman-manager$" },
	float = true,
	size = "800 600",
})
hl.window_rule({
	name = "pwvucontrol",
	match = { class = "^com\\.saivert\\.pwvucontrol$" },
	float = true,
	size = "800 600",
})
hl.window_rule({ name = "zoom", match = { class = "zoom" }, float = true })
hl.window_rule({ name = "qt6ct", match = { class = "qt6ct" }, float = true })
hl.window_rule({ name = "kvantummanager", match = { class = "kvantummanager" }, float = true })
hl.window_rule({
	name = "dolphin",
	match = { class = "org\\.kde\\.dolphin" },
	float = true,
	size = "1060 600",
})
hl.window_rule({
	name = "kcalc",
	match = { class = "org\\.kde\\.kcalc" },
	float = true,
	size = "580 620",
})
hl.window_rule({
	name = "file-png",
	match = { class = "file-png" },
	size = "800 600",
})
hl.window_rule({
	name = "virtualbox-manager",
	match = { class = "^VirtualBox Manager$" },
	float = true,
	size = "800 600",
})
hl.window_rule({
	name = "qalculate",
	match = { class = "io\\.github\\.Qalculate\\.qalculate-qt" },
	float = true,
	size = "600 800",
	center = true,
})
hl.window_rule({
	name = "holonight-settings",
	match = { class = "org.holonight.Settings" },
	float = true,
	center = true,
	focus_on_activate = true,
})
hl.window_rule({
	name = "holonight-chat",
	match = { class = "holonight-chat" },
	float = true,
	-- size = {
	-- 	"(monitor_w*0.6)",
	-- 	"(monitor_h*0.6)",
	-- },
	center = true,
})
hl.window_rule({
	name = "holonight-packages",
	match = { class = "holonight-packages" },
	float = true,
	center = true,
	focus_on_activate = true,
})
hl.window_rule({
	name = "holonight-askpass",
	match = { class = "holonight-askpass" },
	float = true,
	center = true,
	focus_on_activate = true,
	border_size = 0,
	no_blur = true,
	no_shadow = true,
	rounding = 0,
})
hl.window_rule({
	name = "holonight-ssh-askpass",
	match = { class = "holonight-ssh-askpass" },
	float = true,
	center = true,
	focus_on_activate = true,
	border_size = 0,
	no_blur = true,
	no_shadow = true,
	rounding = 0,
})
hl.window_rule({
	name = "holonight-sudo-askpass",
	match = { class = "holonight-sudo-askpass" },
	float = true,
	center = true,
	focus_on_activate = true,
	border_size = 0,
	no_blur = true,
	no_shadow = true,
	rounding = 0,
})
hl.window_rule({
	name = "holonight-polkit-dialog",
	match = { class = "^holonight-polkit-agent$" },
	float = true,
	center = true,
	focus_on_activate = true,
	border_size = 0,
	no_blur = true,
	no_shadow = true,
	rounding = 0,
})
hl.window_rule({
	name = "rpi-dashboard",
	match = { class = "rpi-dashboard" },
	float = true,
	center = true,
	focus_on_activate = true,
})

hl.window_rule({
	name = "datagrip-settings",
	match = { class = "^jetbrains-datagrip$", title = "^Settings$" },
	size = "80% 80%",
	center = true,
})

-- Pcmanfm-qt rules
hl.window_rule({
	name = "pcmanfm-qt-main",
	match = { class = "pcmanfm-qt" },
	float = true,
	size = "1200 900",
})
hl.window_rule({ name = "pcmanfm-qt-copy", match = { class = "pcmanfm-qt", title = "^Copy Files$" }, size = "0 0" })
hl.window_rule({
	name = "pcmanfm-qt-create",
	match = { class = "pcmanfm-qt", title = "^Create\\s+Folder$" },
	size = "0 0",
})
hl.window_rule({
	name = "pcmanfm-qt-prop",
	match = { class = "pcmanfm-qt", title = "^File Properties$" },
	size = "0 0",
})

-- Ghostty quick terminal layer rule
hl.layer_rule({
	name = "ghostty-quick-terminal-rules",
	match = { namespace = "ghostty-quick-terminal" },
	blur = true,
	animation = "slidefadevert",
})

hl.window_rule({
	name = "rpi-imager",
	match = { class = "com.raspberrypi.rpi-imager" },
	float = true,
})
