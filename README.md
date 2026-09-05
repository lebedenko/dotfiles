# Dotfiles with chezmoi

Selected CLI settings for Arch Linux, Manjaro, and Debian (including Raspberry Pis).
Zsh, Git, tmux, and Neovim are independent selections. Workstations default to all
four; servers default to Git and tmux. Hardware never determines the role.
Hyprland, labwc, GNOME, and desktop shell imports are deferred, independent options.

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
curl, and unzip. eza, bat/batcat, and ncdu aliases are guarded; these optional programs
are not installed automatically.

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
             ".tmux.conf", ".config/zsh", ".config/tmux", ".config/nvim"):
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
syntax, and package previews. Profiles simulate template data, not native ARM or
distribution integration tests. No packages or plugins are downloaded. The sandbox
must permit the temporary tmux socket. Full Neovim startup with plugins is a separate
rollout check.

References: [chezmoi source layout](https://www.chezmoi.io/reference/special-files/chezmoiroot/),
[machine differences](https://www.chezmoi.io/user-guide/manage-machine-to-machine-differences/),
[LazyVim requirements](https://www.lazyvim.org/).
