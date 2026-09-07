#!/usr/bin/env python3
"""Explicit dependency setup; preview by default. Requires Python 3.9+."""

import argparse
import json
import os
from pathlib import Path
import platform
import re
import shlex
import shutil
import subprocess
import sys


EXTRA_PACKAGES = ("bat", "btop", "eza", "ghostty", "kitty", "hyprland", "sway", "uwsm", "wireplumber", "dolphin")


def run(command):
    return subprocess.check_output(command, text=True).strip()


def editor_requirements():
    problems = []
    if not shutil.which("nvim"):
        problems.append("Neovim is missing (requires >= 0.11.2 with LuaJIT)")
    else:
        # Even --version may create nvim.log when the state directory is absent.
        version = subprocess.check_output(
            ["nvim", "--version"], text=True,
            env={**os.environ, "NVIM_LOG_FILE": os.devnull},
        )
        match = re.search(r"NVIM v(\d+)\.(\d+)\.(\d+)", version)
        if not match or tuple(map(int, match.groups())) < (0, 11, 2) or "LuaJIT" not in version:
            problems.append("Neovim requires >= 0.11.2 built with LuaJIT")
    if not shutil.which("git"):
        problems.append("Git is missing (requires >= 2.19.0)")
    else:
        match = re.search(r"(\d+)\.(\d+)\.(\d+)", run(["git", "--version"]))
        if not match or tuple(map(int, match.groups())) < (2, 19, 0):
            problems.append("Git requires >= 2.19.0")
    for executable in ("cc", "curl", "tree-sitter", "rg"):
        if not shutil.which(executable):
            problems.append(f"{executable} is missing")
    if not (shutil.which("fd") or shutil.which("fdfind")):
        problems.append("fd/fdfind is missing")
    return problems


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--execute", action="store_true", help="install packages and missing plugin managers")
    mode.add_argument("--preview", action="store_true", help="print commands only (default)")
    parser.add_argument("--config", type=Path, help="chezmoi config, useful for isolated previews")
    parser.add_argument("--distro", choices=("arch", "manjaro", "debian"), help="preview a different distribution")
    parser.add_argument("--arch", help="preview a different CPU architecture")
    parser.add_argument("--check-editor", action="store_true", help="only check installed editor requirements")
    args = parser.parse_args()
    if args.execute and (args.distro or args.arch or args.check_editor):
        parser.error("platform overrides and --check-editor are preview-only")
    if args.check_editor:
        problems = editor_requirements()
        print("\n".join(problems) if problems else "Editor prerequisites satisfied; run :LazyHealth after first launch.")
        return bool(problems)

    command = ["chezmoi"]
    if args.config:
        command += ["--config", str(args.config)]
    data = json.loads(run(command + ["data", "--format=json"]))
    apps = ("zsh", "git", "tmux", "nvim")
    if data.get("role") not in ("workstation", "server") or any(type(data.get(app)) is not bool for app in apps):
        parser.error("initialize this repository with chezmoi init first")
    if any(type(data.get(app, False)) is not bool for app in EXTRA_PACKAGES):
        parser.error("additional package selections must be booleans")
    release = {}
    for line in Path("/etc/os-release").read_text().splitlines():
        if "=" in line and not line.startswith("#"):
            key, value = line.split("=", 1)
            release[key] = shlex.split(value)[0] if value else ""
    distro = args.distro or release.get("ID")
    arch = args.arch or platform.machine()
    if distro not in ("arch", "manjaro", "debian"):
        parser.error(f"unsupported distribution: {distro}")
    print(f"{'EXECUTE' if args.execute else 'PREVIEW'}: {distro} / {arch}; role={data['role']}")
    packages = set()
    packages.update(app for app in EXTRA_PACKAGES if data.get(app, False))
    if any(data[app] for app in ("git", "zsh", "tmux", "nvim")):
        packages.add("git")  # also needed for the selected plugin managers
    for app, package in (("zsh", "zsh"), ("tmux", "tmux"), ("nvim", "neovim")):
        if data[app]:
            packages.add(package)
    if data["zsh"]:
        packages.update(("fzf", "zoxide"))
    if data["nvim"]:
        packages.update(("curl", "unzip", "ripgrep", "fzf", "nodejs", "npm"))
        packages.update(("base-devel", "fd", "tree-sitter-cli") if distro != "debian" else ("build-essential", "fd-find"))

    def action(cmd):
        print(shlex.join([str(part) for part in cmd]), flush=True)
        if args.execute:
            subprocess.run(cmd, check=True)

    if packages:
        if distro == "debian" and packages.intersection(EXTRA_PACKAGES):
            print("Debian: selected additional packages must be available in your configured repositories. "
                  "Ghostty may require a separate installation; Hyprland and uwsm may require backports. "
                  "Setup does not add repositories.", flush=True)
        prefix = [] if os.geteuid() == 0 else ["sudo"]
        install = ["pacman", "-S", "--needed"] if distro != "debian" else ["apt-get", "install"]
        action(prefix + install + sorted(packages))
    else:
        print("No applications selected; nothing to install.")

    home = Path.home()
    zsh = Path(os.environ.get("ZSH", home / ".oh-my-zsh"))
    custom = Path(os.environ.get("ZSH_CUSTOM", zsh / "custom"))
    clones = []
    if data["zsh"]:
        clones += [
            ("ohmyzsh/ohmyzsh", zsh),
            ("romkatv/powerlevel10k", custom / "themes/powerlevel10k"),
            ("zsh-users/zsh-autosuggestions", custom / "plugins/zsh-autosuggestions"),
        ]
    if data["tmux"]:
        clones.append(("tmux-plugins/tpm", home / ".config/tmux/plugins/tpm"))
    for repository, destination in clones:
        if os.path.lexists(destination):
            print(f"Preserve existing: {destination}")
        else:
            action(["git", "clone", "--depth=1", f"https://github.com/{repository}.git", str(destination)])
    if data["nvim"]:
        if distro == "debian":
            print("Debian: verify the installed Neovim version and tree-sitter CLI; package availability varies by release.")
        problems = editor_requirements()
        for problem in problems:
            print(f"Unmet on this machine: {problem}")
        if not problems:
            print("Editor prerequisites satisfied on this machine; run :LazyHealth after first launch.")
        elif args.execute:
            return 1
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (OSError, subprocess.CalledProcessError, ValueError) as error:
        sys.exit(str(error))
