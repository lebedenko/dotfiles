# Dotfiles with chezmoi

Selected CLI and desktop settings for Arch Linux, Manjaro, and Debian (including Raspberry Pis).
Zsh, Git, tmux, and Neovim are independent selections. Workstations default to all
four; servers default to Git and tmux. Hardware never determines the role.
Additional applications are independent, opt-in selections: bat, btop, eza, Ghostty,
Hyprland, Sway, uwsm, WirePlumber, and Dolphin. Each selection controls package setup
and configuration management. labwc, GNOME, and desktop shell imports remain deferred.

`.chezmoiroot` selects `home/`, using chezmoi's native destination naming.
Documentation, scripts, and tests stay outside the applied source tree. There are
no package hooks, deletion directives, or exclusive directories. The obsolete
installer and old configurations were removed; previous versions remain in Git history.

## Initialize without applying

Install Git, Python 3.9+, and a recent chezmoi using your distribution's supported
installation method. Arch/Manjaro provide chezmoi through pacman. On Debian, check
availability for your release; this repository does not install chezmoi itself.

From this checkout:

```sh
chezmoi init --source "$PWD"
```

On another machine, after publishing this repository:

```sh
chezmoi init YOUR_REPOSITORY_URL
```

Do not add `--apply` during initial review. Initialization prompts for role and each
application and saves answers in `~/.config/chezmoi/chezmoi.toml` (under
`$XDG_CONFIG_HOME` if set). Subsequent initialization remembers the answers.
Use `chezmoi edit-config` to change `[data]` booleans `zsh`, `git`, `tmux`, `nvim`
or `role`. Changing the role alone does not reset application choices; remove the
application keys and rerun `chezmoi init` to ask again with role defaults.
Distribution and architecture come from the running system, not these choices.

Initialization also asks `Manage <application>` for each additional application (default:
no on both roles). Existing machines can run `chezmoi init` to answer the new prompts,
or enable the corresponding `[data]` booleans in `chezmoi edit-config`: `bat`, `btop`,
`eza`, `ghostty`, `hyprland`, `sway`, `uwsm`, `wireplumber`, and `dolphin`.
Missing keys in older configs mean disabled. Previously saved package selections are
remembered and now also enable the corresponding configs on the next apply.
`hyprland` manages `~/.config/hypr`, and `dolphin` manages `~/.config/dolphinrc`.
Applying writes configuration files; it does not start sessions or restart services.

Setting an application to `false` stops management and leaves existing files intact.
Local overrides and downloaded plugins remain unmanaged even when enabled.
Application configs target standard `~/.config` paths; custom XDG locations or
ZDOTDIR require deliberate adaptation before rollout.

## Dependencies

From the checkout, or from `chezmoi cd`:

```sh
python3 scripts/setup.py --preview
python3 scripts/setup.py --execute
```

Preview is the default and makes no changes. The script reads the locally selected
applications. Execution uses `pacman -S --needed` on Arch/Manjaro or `apt-get install`
on Debian. It requests sudo only for packages when needed; run as your normal user
so plugin managers go into your home. It does not refresh package databases, upgrade
the distribution, set up AUR, change your login shell, or configure services. Keep
package metadata and the system current using your normal maintenance workflow first.

Git is also installed for selected plugin managers even when Git configuration is
disabled. Zsh adds fzf and zoxide; Neovim adds compiler tools, search tools, Node/npm,
curl, and unzip. bat and eza are installed when their independent selections are
enabled; bat/batcat and eza aliases remain guarded. ncdu is not installed automatically.

Additional selections use the same package names on Arch/Manjaro and Debian, including
`bat` (whose executable is `batcat` on Debian). Availability depends on the release,
architecture, and configured repositories; unavailable packages cause the package
manager to fail. In particular, [Ghostty documents a community Debian package](https://ghostty.org/docs/install/binary),
and [Hyprland](https://wiki.hypr.land/getting-started/installation/) and
[uwsm](https://packages.debian.org/trixie-backports/uwsm) are available in Trixie
backports. Setup does not enable backports or install community packages. On machines
without a selected package in their repositories, provision dependencies separately;
keep the selection enabled to manage its configuration with `chezmoi apply`. Setup
still requests selected packages from the package manager, so skip its execution
on such machines and install the packages shown in preview by your chosen method.

After choosing packages, run from `chezmoi cd`:

```sh
python3 scripts/setup.py --preview
python3 scripts/setup.py --execute
chezmoi diff
chezmoi apply
```

Setup installs dependencies; `chezmoi apply` writes the selected managed configs.
Before first apply, follow the backup and review instructions below.

Explicit execution clones missing Oh My Zsh, Powerlevel10k, autosuggestions, and TPM
directories from upstream. Existing paths, including symlinks, are preserved.
`ZSH` and `ZSH_CUSTOM` overrides are honored. Incomplete existing installations need
manual repair. Ordinary `chezmoi apply` never clones these dependencies, and no
upstream shell installer is executed.

Preview other platforms without running their package managers:

```sh
python3 scripts/setup.py --preview --distro manjaro --arch x86_64
python3 scripts/setup.py --preview --distro debian --arch aarch64
```

Overrides are rejected with `--execute`. They select package commands; editor checks
still describe the machine running the script. `--config PATH` selects an alternate
chezmoi config for isolated previews.

### Neovim compatibility

The imported LazyVim lockfile is preserved byte-for-byte. First launch retains its
plugin bootstrap behavior and may download plugins, parsers, and Mason tools.
This is separate from chezmoi apply and can require network access. Copilot remains
an optional LazyVim extra; authentication stays local.

Check installed prerequisites before starting the editor, especially on Debian:

```sh
python3 scripts/setup.py --check-editor
```

The current upstream baseline is Neovim >= 0.11.2 with LuaJIT, Git >= 2.19, a C
compiler, tree-sitter CLI, and curl. Debian releases may ship an older Neovim or lack
a tree-sitter CLI package. Setup reports unmet requirements and exits unsuccessfully
after execution if they remain; it never adds repositories or downloads architecture-
specific binaries. Choose a supported installation before using Neovim there.
Use a true-color terminal and optionally a Nerd Font for prompt/status icons.
Run `:LazyHealth` after plugin installation. Language servers, Qt/QML tools, ESP
toolchains, and project SDKs need separate setup.

## Additional application configurations

These are imports of the existing local settings, with portable paths and automatic
monitor detection. Active TokyoNight themes are included; logs, caches, backup files,
Dolphin version/timestamp state, and uwsm's saved `default-id` are not imported.

| Selection | Managed configuration | Included settings |
| --- | --- | --- |
| `bat` | `~/.config/bat/config`, `themes/tokyonight_storm.tmTheme` | TokyoNight Storm and italic text |
| `btop` | `~/.config/btop/btop.conf`, `themes/tokyonight.theme` | Theme, layout, Vim keys; theme resolved by name |
| `eza` | `~/.config/eza/theme.yml` | TokyoNight file and permission colors |
| `ghostty` | `~/.config/ghostty/config` | Theme, font size, quick terminal, keybinding |
| `hyprland` | `~/.config/hypr/*.lua`, `hypridle.conf` | Modular Lua setup, palette, input, bindings, rules, idle settings |
| `sway` | `~/.config/sway/config` | Input, workspaces, layouts, bindings, uwsm finalization |
| `uwsm` | `~/.config/uwsm/env`, `env-hyprland`, `env-sway` | Shared Wayland environment and local override loading |
| `wireplumber` | `~/.config/wireplumber/wireplumber.conf.d/80-soft-mixer.conf` | ALSA software mixer rule |
| `dolphin` | `~/.config/dolphinrc` | Places icons, hidden menu bar, preview plugin preferences |

After applying bat's config and theme, build its local theme cache:

```sh
bat cache --build
# Debian: batcat cache --build
```

btop uses the theme name instead of an absolute home path and no longer saves runtime
setting changes on exit. Dolphin can rewrite its settings while running; close it
before applying and review later diffs before importing changes made in its UI.
Preview plugin preferences do not install the thumbnail providers themselves.

The imported [Hyprland Lua configuration](https://wiki.hypr.land/configuring/core/)
requires a Lua-capable release (0.55 or newer); it was validated with 0.56.2.
WirePlumber's fragment targets the [0.5 configuration format](https://pipewire.pages.freedesktop.org/wireplumber/daemon/configuration/migration.html). Older distribution
packages may need upgrading before using these configurations.

The desktop bindings retain Ghostty, Dolphin, and uwsm launch commands: enable those
selections when using this desktop setup and start the compositor through uwsm.
HoloNight launcher/settings bindings require a separately installed HoloNight shell.
Other optional bindings use `brightnessctl`, `playerctl`, `wpctl`, application-specific
programs, and `~/.local/bin/{hide-unhide-window.sh,screenshot.sh}`; install the tools
or replace their bindings locally. The AWS VPN client binding was omitted because it
referenced a private installation path. Autostart runs dex and the per-window keyboard
layout helper only when installed. The idle config requires separately installed
hypridle/hyprlock and a working lock configuration; neither is started by this import.

Fixed output names, workspace-to-monitor assignments, the device-specific touchpad
rule, forced GDK scale, GPU workarounds, Arch's menu prefix, and local HoloNight Qt
plugin paths are left to the override files below. Reintroduce the settings required
by each machine there. The saved uwsm session choice remains local, so enabling Sway
and Hyprland together does not choose which desktop starts.

## Local overrides and migration

Before first apply, review existing configuration and move required private settings
into these unmanaged files. Imported files exclude credentials, work environment
scripts, Git identity/signing/protocol settings, and private machine paths.
An existing `~/.tmux.conf` takes precedence over the XDG tmux config; back it up and
move it aside before using the imported configuration.

| Application | Local file | Behavior |
| --- | --- | --- |
| Zsh | `~/.zshrc.local` | Sourced last; environment managers, work aliases, credentials |
| Git | `~/.gitconfig.local` | Included last; identity, signing, work includes, protocols |
| tmux | `~/.config/tmux/local.conf` | Sourced after shared settings and TPM |
| Neovim | `~/.config/nvim/local.lua` | Loaded before LazyVim; environment and tool paths |
| Neovim | `~/.config/nvim/lua/plugins/local.lua` | Optional local Lazy plugin specs |
| Ghostty | `~/.config/ghostty/config.local` | Optional config loaded after shared settings |
| Hyprland | `~/.config/hypr/local.lua` | Loaded last; monitor assignments, devices, binding overrides |
| Sway | `~/.config/sway/config.local` | Included last; output layout and binding overrides |
| uwsm | `~/.config/uwsm/env.local` | Sourced after shared environment settings |
| uwsm | `~/.config/uwsm/env-hyprland.local`, `env-sway.local` | Sourced after compositor environment settings |
| WirePlumber | `~/.config/wireplumber/wireplumber.conf.d/99-local.conf` | Native configuration fragment loaded after the shared rule |

Example Git local include (replace placeholders):

```gitconfig
[user]
    name = Your Name
    email = you@example.com
```

Copy your reviewed signing settings there too if required; shared config imposes no
signing defaults. Never add this file to chezmoi.

For the preserved QML/embedded C++ customizations, set variables in `local.lua`:

```lua
vim.env.QMLLS_BIN = "/usr/lib/qt6/bin/qmlls" -- otherwise searches PATH
-- vim.env.QMLLS_BUILD_DIR = "build/dev" -- project-relative, or absolute
-- vim.env.CLANGD_QUERY_DRIVER = "/path/to/trusted/toolchain/bin/*"
```

The default clangd query-driver pattern uses your home's `.espressif` toolchain.
Only allow trusted compiler paths because clangd may execute them. Missing optional
shell dependencies and TPM are tolerated. Downloaded tmux plugins and saved sessions
are not imported. Keep private override files readable only by you as appropriate.

## Back up, review, and apply later

This migration was prepared using temporary destinations; nothing has been applied
to your live home. Before first live apply, back up existing files and local overrides:

```sh
python3 - <<'PY'
from datetime import datetime
from pathlib import Path
import shutil
home = Path.home()
backup = home / ("dotfiles-backup-" + datetime.now().strftime("%Y%m%d-%H%M%S"))
backup.mkdir(mode=0o700)
for name in (".zshrc", ".p10k.zsh", ".zshrc.local", ".gitconfig", ".gitconfig.local",
             ".tmux.conf", ".config/zsh", ".config/tmux", ".config/nvim",
             ".config/bat", ".config/btop", ".config/eza", ".config/ghostty",
             ".config/hypr", ".config/sway", ".config/uwsm", ".config/wireplumber",
             ".config/dolphinrc"):
    source, target = home / name, backup / name
    if source.exists() or source.is_symlink():
        target.parent.mkdir(parents=True, exist_ok=True)
        if source.is_dir() and not source.is_symlink():
            shutil.copytree(source, target, symlinks=True)
        else:
            shutil.copy2(source, target, follow_symlinks=False)
print(backup)
PY
chezmoi diff
chezmoi apply --dry-run --verbose
chezmoi apply
chezmoi diff
```

Review every selected application's diff and preserve required local settings before
applying. Existing symlinks may be replaced with managed files; inspect and back up
their targets too. The last diff should be empty until you edit something.

To restore, disable affected applications in `chezmoi edit-config`, move their current
files/directories aside, and copy backup entries to their original locations. For
example, assign the actual backup path to `backup`, then:

```sh
mv ~/.zshrc ~/.zshrc.before-restore
cp -a "$backup/.zshrc" ~/.zshrc
```

Use an unused name for the moved file. Restore whole directories after moving current
ones aside to avoid merging stale files. If a target was previously absent, move it
aside instead of restoring it. Backups may contain secrets; keep them local and
outside this repository.

## Daily workflow

Use `chezmoi edit ~/.zshrc`, then `chezmoi diff` and `chezmoi apply`. To import a later
portable file, review it and run `chezmoi add PATH`; inspect the source diff before
committing. Avoid broad recursive adds of application data. Ignore rules protect the
documented override paths but cannot identify every secret. After editing a managed
live file, use `chezmoi re-add PATH` and review the result.

Commit and push reviewed source changes normally. On another initialized machine:

```sh
chezmoi git -- pull --ff-only
chezmoi init
chezmoi diff
chezmoi apply
```

`chezmoi update` pulls and applies together; use separate steps to review first.
Run setup preview again when selections change. Future desktop imports should have
their own independent selection and ignore rules.

Update plugins separately: `omz update` for Oh My Zsh and reviewed
`git -C PATH pull --ff-only` for Powerlevel10k, autosuggestions, and TPM. In tmux,
prefix + I installs declared plugins and prefix + U updates them. Use `:Lazy` for
editor updates; review and re-add `lazy-lock.json` only when intentionally sharing
a new plugin lockfile.

## Verification

Requires chezmoi, Python 3.9+, Zsh, Git, tmux, and `luac`:

```sh
python3 -m unittest discover -s tests -v
```

Tests use temporary homes, caches, state databases, and a dedicated tmux socket.
They cover role defaults, remembered overrides, all 16 application combinations on
Arch/Manjaro and Debian ARM/ARM64 profiles, repeat applies, unmanaged-file retention,
Zsh startup without optional dependencies, Git includes, tmux bindings/overrides, Lua
syntax, package previews, independent additional config selections, repeat applies,
and retention of their local overrides. Profiles simulate template data, not native ARM or
distribution integration tests. No packages or plugins are downloaded. The sandbox
must permit the temporary tmux socket. Full Neovim startup with plugins is a separate
rollout check.

References: [chezmoi source layout](https://www.chezmoi.io/reference/special-files/chezmoiroot/),
[machine differences](https://www.chezmoi.io/user-guide/manage-machine-to-machine-differences/),
[LazyVim requirements](https://www.lazyvim.org/).
