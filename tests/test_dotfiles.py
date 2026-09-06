"""Integration checks using real chezmoi and disposable homes; no network/packages."""

import itertools
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
APPS = ("zsh", "git", "tmux", "nvim")
TARGETS = (".zshrc", ".gitconfig", ".config/tmux/tmux.conf", ".config/nvim/init.lua")
EXTRAS = ("bat", "btop", "eza", "ghostty", "hyprland", "sway", "uwsm", "wireplumber", "dolphin")
EXTRA_TARGETS = (".config/bat/config", ".config/btop/btop.conf", ".config/eza/theme.yml",
                 ".config/ghostty/config", ".config/hypr/hyprland.lua", ".config/sway/config",
                 ".config/uwsm/env", ".config/wireplumber/wireplumber.conf.d/80-soft-mixer.conf",
                 ".config/dolphinrc")


class DotfilesTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="dotfiles-test-")
        self.addCleanup(self.temp.cleanup)
        self.base = Path(self.temp.name)
        self.home = self.base / "home"
        self.home.mkdir()
        self.config = self.base / "chezmoi.toml"
        self.env = {
            "HOME": str(self.home), "PATH": os.environ["PATH"], "TERM": "xterm-256color",
            "XDG_CONFIG_HOME": str(self.home / ".config"),
            "XDG_DATA_HOME": str(self.home / ".local/share"),
            "XDG_STATE_HOME": str(self.home / ".local/state"),
            "XDG_CACHE_HOME": str(self.home / ".cache"),
            "GIT_CONFIG_NOSYSTEM": "1",
        }
        self.chezmoi = ["chezmoi", "--source", str(ROOT), "--destination", str(self.home),
                        "--config", str(self.config), "--persistent-state", str(self.base / "state.db"),
                        "--cache", str(self.base / "cache"), "--no-tty"]

    def run_command(self, command, **kwargs):
        result = subprocess.run(command, env=self.env, text=True, capture_output=True, **kwargs)
        self.assertEqual(result.returncode, 0, result.stderr)
        return result.stdout

    def configure(self, apps, role="workstation"):
        self.config.write_text('[data]\nrole = ' + json.dumps(role) + '\n' +
                               ''.join(f'{app} = {str(enabled).lower()}\n' for app, enabled in zip(APPS, apps)))

    def test_init_defaults_and_remembered_overrides(self):
        for role in ("workstation", "server"):
            # An empty config ensures every prompt default is evaluated afresh.
            self.config.write_text("")
            output = self.run_command(self.chezmoi + ["execute-template", "--init", "--promptChoice",
                f"Machine role={role}", "--file", str(ROOT / "home/.chezmoi.toml.tmpl")])
            self.config.write_text(output)
            data = json.loads(self.run_command(self.chezmoi + ["data", "--format=json"]))
            self.assertEqual([data[app] for app in APPS], [role == "workstation", True, True, role == "workstation"])
            self.assertEqual([data[app] for app in EXTRAS], [False] * len(EXTRAS))
        self.configure((True, False, False, True), "server")
        output = self.run_command(self.chezmoi + ["execute-template", "--init", "--file", str(ROOT / "home/.chezmoi.toml.tmpl")])
        self.config.write_text(output)
        data = json.loads(self.run_command(self.chezmoi + ["data", "--format=json"]))
        self.assertEqual([data[app] for app in APPS], [True, False, False, True])
        self.assertEqual(data["chezmoi"]["workingTree"], str(ROOT))

    def test_actual_init_does_not_apply_and_reinitialization_remembers(self):
        prompts = "Manage Zsh=true,Manage Git=false,Manage tmux=true,Manage Neovim=false,"
        prompts += ",".join(f"Manage {app}=false" for app in EXTRAS)
        self.run_command(self.chezmoi + ["init", "--promptChoice", "Machine role=server",
            "--promptBool", prompts])
        self.assertFalse((self.home / ".zshrc").exists())
        self.run_command(self.chezmoi + ["init"])
        data = json.loads(self.run_command(self.chezmoi + ["data", "--format=json"]))
        self.assertEqual([data[app] for app in APPS], [True, False, True, False])

    def test_platform_matrix_and_all_independent_selections(self):
        for distro, arch, role in (("arch", "amd64", "workstation"), ("manjaro", "amd64", "workstation"),
                                   ("debian", "arm64", "server"), ("debian", "arm", "server")):
            for apps in itertools.product((False, True), repeat=4):
                with self.subTest(distro=distro, arch=arch, apps=apps):
                    self.configure(apps, role)
                    command = self.chezmoi + ["--override-data", json.dumps({"chezmoi": {"os": "linux", "arch": arch, "osRelease": {"id": distro}}})]
                    managed = self.run_command(command + ["managed"])
                    for target, enabled in zip(TARGETS, apps):
                        self.assertEqual(target in managed.splitlines(), enabled)
                    self.run_command(command + ["apply", "--force"])
                    self.assertEqual(self.run_command(command + ["diff"]), "")
                    self.run_command(command + ["apply", "--force"])
                    self.assertEqual(self.run_command(command + ["diff"]), "")

    def test_disabled_and_unrelated_files_survive(self):
        self.configure((True,) * 4)
        self.run_command(self.chezmoi + ["apply"])
        paths = [*TARGETS, "unrelated.txt", ".config/nvim/local.lua", ".gitconfig.local",
                 ".config/tmux/plugins/sentinel", ".config/tmux/local.conf", ".zshrc.local"]
        for target in paths:
            path = self.home / target
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text("unmanaged sentinel\n")
        self.configure((False,) * 4)
        self.run_command(self.chezmoi + ["apply", "--force"])
        for target in paths:
            self.assertEqual((self.home / target).read_text(), "unmanaged sentinel\n")
        self.configure((True,) * 4)
        self.run_command(self.chezmoi + ["apply", "--force"])
        for target in paths[4:]:
            self.assertEqual((self.home / target).read_text(), "unmanaged sentinel\n")

    def test_zsh_without_optional_dependencies_and_git_local_include(self):
        self.configure((True, True, False, False))
        self.run_command(self.chezmoi + ["apply"])
        self.run_command(["zsh", "-n", str(self.home / ".zshrc")])
        self.run_command(["zsh", "-n", str(self.home / ".p10k.zsh")])
        self.run_command(["zsh", "-n", str(self.home / ".config/zsh/aliases.zsh")])
        self.run_command(["zsh", "-n", str(self.home / ".config/zsh/fzf.zsh")])
        # Keep core utilities needed by compinit, but omit all optional tools.
        zsh = shutil.which("zsh")
        saved_path = self.env["PATH"]
        bin_dir = self.base / "minimal-bin"
        bin_dir.mkdir()
        for utility in ("mv", "mkdir", "rm", "cat", "uname"):
            (bin_dir / utility).symlink_to(shutil.which(utility))
        self.env["PATH"] = str(bin_dir)
        result = subprocess.run([zsh, "-d", "-i", "-c", "print startup-ok"], env=self.env, text=True, capture_output=True)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stderr, "")
        self.assertIn("startup-ok", result.stdout)
        # fzf preferences must also tolerate missing fd, bat, and eza.
        result = subprocess.run([zsh, "-d", "-f", "-i", "-c",
            'source "$HOME/.config/zsh/fzf.zsh"; print fzf-ok'], env=self.env, text=True, capture_output=True)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stderr, "")
        self.assertIn("fzf-ok", result.stdout)
        self.env["PATH"] = saved_path
        self.assertEqual(self.run_command(["git", "config", "--global", "--includes", "--get", "pull.rebase"]), "true\n")
        (self.home / ".gitconfig.local").write_text('[user]\n name = Test User\n email = test@example.invalid\n[pull]\n rebase = false\n')
        self.assertEqual(self.run_command(["git", "config", "--global", "--includes", "--get", "user.name"]), "Test User\n")
        self.assertEqual(self.run_command(["git", "config", "--global", "--includes", "--get", "pull.rebase"]), "false\n")

    def test_tmux_in_isolated_server(self):
        self.configure((False, False, True, False))
        self.run_command(self.chezmoi + ["apply"])
        socket = str(self.base / "tmux.sock")
        command = ["tmux", "-S", socket]
        try:
            self.run_command(command + ["-f", str(self.home / ".config/tmux/tmux.conf"), "new-session", "-d", "-s", "test", "sleep 30"])
            self.assertEqual(self.run_command(command + ["show-options", "-gv", "base-index"]), "1\n")
            self.assertEqual(self.run_command(command + ["show-options", "-gv", "status-position"]), "top\n")
            self.assertIn("split-window -h", self.run_command(command + ["list-keys", "-T", "prefix"]))
            (self.home / ".config/tmux/local.conf").write_text("set -g history-limit 1234\n")
            self.run_command(command + ["source-file", str(self.home / ".config/tmux/tmux.conf")])
            self.assertEqual(self.run_command(command + ["show-options", "-gv", "history-limit"]), "1234\n")
        finally:
            subprocess.run(command + ["kill-server"], env=self.env, capture_output=True)

    def test_neovim_lua_syntax(self):
        for path in (ROOT / "home/dot_config/nvim").rglob("*.lua"):
            self.run_command(["luac", "-p", str(path)])

    def test_package_previews_and_execute_override_rejection(self):
        for distro, install, fd in (("arch", "pacman -S --needed", "fd"), ("manjaro", "pacman -S --needed", "fd"),
                                    ("debian", "apt-get install", "fd-find")):
            self.configure((True,) * 4)
            command = ["python3", str(ROOT / "scripts/setup.py"), "--config", str(self.config), "--distro", distro, "--arch", "aarch64"]
            output = self.run_command(command)
            self.assertIn(install, output)
            self.assertIn(fd, output)
            self.assertIn("git clone --depth=1", output)
            self.assertFalse((self.home / ".oh-my-zsh").exists())
            result = subprocess.run(command + ["--execute"], env=self.env, capture_output=True)
            self.assertNotEqual(result.returncode, 0)
        for app in APPS:
            self.configure(tuple(candidate == app for candidate in APPS))
            output = self.run_command(["python3", str(ROOT / "scripts/setup.py"), "--config", str(self.config)])
            install = next(line for line in output.splitlines() if " -S " in line or " install " in line)
            for candidate, package in (("zsh", "zsh"), ("tmux", "tmux"), ("nvim", "neovim")):
                self.assertEqual(package in install.split(), candidate == app)
        self.configure((False,) * 4)
        self.assertIn("nothing to install", self.run_command(["python3", str(ROOT / "scripts/setup.py"), "--config", str(self.config)]))

    def test_additional_package_choices_survive_reinitialization(self):
        self.configure((False,) * 4, "server")
        prompts = ",".join(f"Manage {app}=true" for app in EXTRAS)
        self.run_command(self.chezmoi + ["init", "--promptBool", prompts])
        self.run_command(self.chezmoi + ["init"])
        data = json.loads(self.run_command(self.chezmoi + ["data", "--format=json"]))
        self.assertTrue(all(data[app] is True for app in EXTRAS))
        self.assertFalse(any(data[app] for app in APPS))
        managed = self.run_command(self.chezmoi + ["managed"]).splitlines()
        self.assertTrue(set(EXTRA_TARGETS).issubset(managed))

    def test_additional_configs_apply_independently_and_preserve_local_files(self):
        for app, target in zip(EXTRAS, EXTRA_TARGETS):
            with self.subTest(app=app):
                self.configure((False,) * 4)
                with self.config.open("a") as config:
                    config.write(f"{app} = true\n")
                managed = self.run_command(self.chezmoi + ["managed"]).splitlines()
                self.assertEqual(set(managed).intersection(EXTRA_TARGETS), {target})
                self.run_command(self.chezmoi + ["apply"])
                self.assertTrue((self.home / target).is_file())
                self.assertEqual(self.run_command(self.chezmoi + ["diff"]), "")
                self.run_command(self.chezmoi + ["apply"])
                self.assertEqual(self.run_command(self.chezmoi + ["diff"]), "")
        local_paths = ["ghostty/config.local", "hypr/local.lua", "hypr/hyprlock.conf.bak",
                       "sway/config.local", "uwsm/env.local", "uwsm/env-hyprland.local",
                       "uwsm/env-sway.local", "uwsm/default-id", "uwsm/env.d/90-local",
                       "wireplumber/wireplumber.conf.d/99-local.conf", "btop/btop.log"]
        self.configure((False,) * 4)
        with self.config.open("a") as config:
            config.write("".join(f"{app} = true\n" for app in EXTRAS))
        for name in local_paths:
            path = self.home / ".config" / name
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text("local sentinel\n")
        self.run_command(self.chezmoi + ["apply", "--force"])
        managed = self.run_command(self.chezmoi + ["managed"]).splitlines()
        for name in local_paths:
            self.assertNotIn(".config/" + name, managed)
            self.assertEqual((self.home / ".config" / name).read_text(), "local sentinel\n")
        before = {name: (self.home / name).read_bytes() for name in EXTRA_TARGETS}
        self.configure((False,) * 4)
        self.run_command(self.chezmoi + ["apply", "--force"])
        for name, content in before.items():
            self.assertEqual((self.home / name).read_bytes(), content)

    def test_imported_lua_and_uwsm_shell_syntax(self):
        for path in (ROOT / "home/dot_config/hypr").glob("*.lua"):
            self.run_command(["luac", "-p", str(path)])
        for name in ("env", "env-hyprland", "env-sway"):
            self.run_command(["sh", "-n", str(ROOT / "home/dot_config/uwsm" / name)])
        self.configure((False,) * 4)
        with self.config.open("a") as config:
            config.write("uwsm = true\n")
        self.run_command(self.chezmoi + ["apply"])
        local_env = self.home / ".config/uwsm/env.local"
        local_env.write_text("export XCURSOR_SIZE=32\n")
        output = self.run_command(["sh", "-c", '. "$HOME/.config/uwsm/env"; printf "%s" "$XCURSOR_SIZE"'])
        self.assertEqual(output, "32")

    def test_additional_packages_are_independent_of_managed_apps(self):
        for distro in ("arch", "manjaro", "debian"):
            for app in EXTRAS:
                with self.subTest(distro=distro, app=app):
                    self.configure((False,) * 4, "server")
                    with self.config.open("a") as config:
                        config.write(f"{app} = true\n")
                    output = self.run_command(["python3", str(ROOT / "scripts/setup.py"),
                        "--config", str(self.config), "--preview", "--distro", distro])
                    install = next(line for line in output.splitlines() if " -S " in line or "apt-get install " in line)
                    self.assertEqual(set(install.split()).intersection(EXTRAS), {app})
                    self.assertNotIn("git", install.split())
                    self.assertNotIn("git clone", output)
                    self.assertFalse((self.home / ".config").exists())

    def test_additional_package_selection_rejects_non_boolean(self):
        self.configure((False,) * 4)
        with self.config.open("a") as config:
            config.write('bat = "false"\n')
        result = subprocess.run(["python3", str(ROOT / "scripts/setup.py"),
            "--config", str(self.config)], env=self.env, text=True, capture_output=True)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("additional package selections must be booleans", result.stderr)

    def test_explicit_setup_preserves_existing_installations(self):
        self.configure((True, False, True, False))
        existing = self.home / ".oh-my-zsh"
        existing.mkdir()
        sentinel = existing / "sentinel"
        sentinel.write_text("keep me")
        custom = self.home / "custom-zsh"
        self.env["ZSH_CUSTOM"] = str(custom)
        bin_dir = self.base / "fake-bin"
        bin_dir.mkdir()
        log = self.base / "commands.jsonl"
        # Fake only external mutations; chezmoi, config parsing, and planning are real.
        recorder = '#!/usr/bin/env python3\nimport json, sys\nfrom pathlib import Path\nwith Path(' + repr(str(log)) + ').open("a") as f:\n f.write(json.dumps(sys.argv) + "\\n")\n'
        for executable in ("sudo", "pacman", "apt-get", "git"):
            stub = bin_dir / executable
            stub.write_text(recorder)
            stub.chmod(0o755)
        self.env["PATH"] = str(bin_dir) + os.pathsep + self.env["PATH"]
        output = self.run_command(["python3", str(ROOT / "scripts/setup.py"), "--config", str(self.config), "--execute"])
        self.assertIn("Preserve existing", output)
        self.assertEqual(sentinel.read_text(), "keep me")
        commands = [json.loads(line) for line in log.read_text().splitlines()]
        clones = [command for command in commands if "clone" in command]
        self.assertEqual(len(clones), 3)
        self.assertEqual({command[-1] for command in clones}, {
            str(custom / "themes/powerlevel10k"), str(custom / "plugins/zsh-autosuggestions"),
            str(self.home / ".config/tmux/plugins/tpm"),
        })


if __name__ == "__main__":
    unittest.main()
