"""Installer CLI checks using harmless stand-in component installers."""

import errno
import os
import pty
import select
import shutil
import signal
import subprocess
import tempfile
import unittest
from pathlib import Path


REPO = Path(__file__).resolve().parents[1]


class InstallerTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(prefix="dotfiles install ", dir="/tmp/opencode")
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        (self.root / "scripts").mkdir()
        for name in ("install", "_helpers.sh"):
            shutil.copy2(REPO / "scripts" / name, self.root / "scripts" / name)
        self.log = self.root / "installed"

    def component(self, name, *, nested=False):
        folder = self.root / name
        if nested:
            folder /= "vendor"
        folder.mkdir(parents=True, exist_ok=True)
        script = folder / "install.sh"
        script.write_text(
            '#!/usr/bin/env bash\n'
            'printf "%s:" "' + name + '" >> "$INSTALL_LOG"\n'
            'printf "<%s>" "$@" >> "$INSTALL_LOG"\n'
            'printf "\\n" >> "$INSTALL_LOG"\n'
        )
        script.chmod(0o755)

    def run_command(self, command, replies, *args, env=None):
        pid, fd = pty.fork()
        if pid == 0:
            environment = {**os.environ, "INSTALL_LOG": str(self.log), **(env or {})}
            os.execve(str(command), [str(command), *args], environment)
        output = bytearray()
        try:
            os.write(fd, replies.encode())
            while True:
                ready, _, _ = select.select([fd], [], [], 5)
                if not ready:
                    self.fail("installer did not finish")
                try:
                    data = os.read(fd, 4096)
                except OSError as exc:
                    if exc.errno != errno.EIO:
                        raise
                    break
                if not data:
                    break
                output.extend(data)
        finally:
            os.close(fd)
            done, status = os.waitpid(pid, os.WNOHANG)
            if not done:
                os.kill(pid, signal.SIGKILL)
                _, status = os.waitpid(pid, 0)
        return os.waitstatus_to_exitcode(status), output.decode(errors="replace")

    def run_installer(self, replies, *args):
        return self.run_command(self.root / "scripts" / "install", replies, *args)

    def nvim_installer(self):
        shutil.copy2(REPO / "scripts" / "_links.sh", self.root / "scripts" / "_links.sh")
        folder = self.root / "nvim"
        folder.mkdir()
        shutil.copy2(REPO / "nvim" / "install.sh", folder / "install.sh")
        (folder / "init.vim").write_text('" fixture\n')
        return folder / "install.sh"

    def test_yes_to_all_runs_only_known_components_with_exact_arguments(self):
        self.component("bash")
        self.component("fish")
        self.component("bash", nested=True)
        self.component("unexpected")

        status, output = self.run_installer("Y\n", "two words", "$(echo unsafe)")

        self.assertEqual(status, 0, output)
        self.assertEqual(self.log.read_text().splitlines(), [
            "bash:<two words><$(echo unsafe)>",
            "fish:<two words><$(echo unsafe)>",
        ])
        self.assertEqual(output.count("Do you want to install"), 1)

    def test_failed_component_returns_failure(self):
        self.component("bash")
        (self.root / "bash" / "install.sh").write_text('#!/usr/bin/env bash\nexit 7\n')

        status, output = self.run_installer("y\n")

        self.assertEqual(status, 1, output)
        self.assertIn("FAIL", output)

    def test_yes_then_no_only_runs_first_component(self):
        self.component("bash")
        self.component("fish")

        status, output = self.run_installer("yn")

        self.assertEqual(status, 0, output)
        self.assertEqual(self.log.read_text().splitlines(), ["bash:<>"])

    def test_component_prompt_colors_the_target_and_choices(self):
        self.component("bash")

        status, output = self.run_installer("n")

        self.assertEqual(status, 0, output)
        self.assertIn("\x1b[1;36mbash/install.sh\x1b[0m", output)
        self.assertIn("\x1b[0;32m[y]\x1b[0mes", output)
        self.assertIn("\x1b[1;32m[Y]\x1b[0mes to all", output)
        self.assertIn("\x1b[0;34m[n]\x1b[0mo", output)
        self.assertFalse(self.log.exists())

    def test_link_conflict_identifies_home_path_and_colored_choices(self):
        installer = self.nvim_installer()
        destination = self.root / ".config" / "nvim" / "init.vim"
        destination.parent.mkdir(parents=True)
        destination.write_text("existing\n")

        status, output = self.run_command(installer, "s\n", env={"HOME": str(self.root)})

        self.assertEqual(status, 0, output)
        self.assertIn("[ \x1b[0;33m??\x1b[0m ] File already exists:", output)
        self.assertIn("\x1b[1;36m~/.config/nvim/init.vim\x1b[0m", output)
        self.assertIn("Link from: ~/nvim/init.vim", output)
        for choice in ("\x1b[0;34m[s]\x1b[0m", "\x1b[1;34m[S]\x1b[0m",
                       "\x1b[0;31m[o]\x1b[0m", "\x1b[1;31m[O]\x1b[0m",
                       "\x1b[0;32m[b]\x1b[0m", "\x1b[1;32m[B]\x1b[0m"):
            self.assertIn(choice, output)
        self.assertIn("Skipped: ~/.config/nvim/init.vim", output)
        self.assertEqual(destination.read_text(), "existing\n")

    def test_link_backup_and_repeat_install_keep_files_safe(self):
        installer = self.nvim_installer()
        destination = self.root / ".config" / "nvim" / "init.vim"
        destination.parent.mkdir(parents=True)
        destination.write_text("existing\n")

        status, output = self.run_command(installer, "b\n", env={"HOME": str(self.root)})

        self.assertEqual(status, 0, output)
        self.assertEqual((destination.parent / "init.vim.backup").read_text(), "existing\n")
        self.assertTrue(destination.is_symlink())
        self.assertEqual(destination.resolve(), self.root / "nvim" / "init.vim")
        self.assertIn("Backed up: ~/.config/nvim/init.vim.backup", output)
        self.assertIn("Linked: ~/.config/nvim/init.vim -> ~/nvim/init.vim", output)

        status, output = self.run_command(installer, "", env={"HOME": str(self.root)})

        self.assertEqual(status, 0, output)
        self.assertIn("Already linked: ~/.config/nvim/init.vim", output)
        self.assertNotIn("File already exists:", output)

    def test_link_conflict_without_terminal_does_not_change_existing_file(self):
        installer = self.nvim_installer()
        destination = self.root / ".config" / "nvim" / "init.vim"
        destination.parent.mkdir(parents=True)
        destination.write_text("existing\n")

        result = subprocess.run([str(installer)], capture_output=True, text=True,
                                check=False, env={**os.environ, "HOME": str(self.root)})

        self.assertNotEqual(result.returncode, 0)
        self.assertIn("Cannot choose what to do with ~/.config/nvim/init.vim", result.stderr)
        self.assertEqual(destination.read_text(), "existing\n")

    def test_paths_outside_home_and_backslashes_are_printed_literally(self):
        self.nvim_installer()
        home = self.root / "home"
        home.mkdir()
        destination = self.root / "elsewhere" / "nvim" / "init\\e[31m.vim"
        destination.parent.mkdir(parents=True)
        destination.write_text("existing\n")
        # Call the link helper through a stand-in installer with a custom destination.
        wrapper = self.root / "nvim" / "custom-install.sh"
        wrapper.write_text('#!/usr/bin/env bash\n'
                           'source "$(dirname "$0")/../scripts/_links.sh"\n'
                           'link_files "$1" "$2"\n')
        wrapper.chmod(0o755)

        status, output = self.run_command(wrapper, "s\n", str(self.root / "nvim" / "init.vim"), str(destination),
                                          env={"HOME": str(home)})

        self.assertEqual(status, 0, output)
        self.assertIn(str(destination), output)
        self.assertNotIn("~", output)
        self.assertEqual(destination.read_text(), "existing\n")

    def test_unknown_bootstrap_mode_is_rejected(self):
        for name in ("bootstrap", "_links.sh"):
            shutil.copy2(REPO / "scripts" / name, self.root / "scripts" / name)

        result = subprocess.run([str(self.root / "scripts" / "bootstrap"), "tiny"],
                                capture_output=True, text=True, check=False)

        self.assertEqual(result.returncode, 1)
        self.assertIn("Usage:", result.stderr)

    def test_zsh_stops_after_a_failed_clone(self):
        folder = self.root / "zsh"
        folder.mkdir()
        shutil.copy2(REPO / "zsh" / "install.sh", folder / "install.sh")
        commands = self.root / "commands"
        commands.mkdir()
        git = commands / "git"
        git.write_text('#!/usr/bin/env bash\nprintf "%s\\n" "$*" >> "$INSTALL_LOG"\nexit 7\n')
        git.chmod(0o755)

        result = subprocess.run([str(folder / "install.sh")], capture_output=True,
                                text=True, check=False, env={**os.environ,
                                    "HOME": str(self.root), "INSTALL_LOG": str(self.log),
                                    "PATH": f"{commands}:{os.environ['PATH']}"})

        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(len(self.log.read_text().splitlines()), 1)

    def test_existing_fzf_checkout_can_be_updated(self):
        folder = self.root / "fzf"
        folder.mkdir()
        shutil.copy2(REPO / "fzf" / "install.sh", folder / "install.sh")
        checkout = self.root / ".fzf"
        (checkout / ".git").mkdir(parents=True)
        binary_install = checkout / "install"
        binary_install.write_text('#!/usr/bin/env bash\nprintf "binary:%s\\n" "$*" >> "$INSTALL_LOG"\n')
        binary_install.chmod(0o755)
        commands = self.root / "commands"
        commands.mkdir()
        git = commands / "git"
        git.write_text('#!/usr/bin/env bash\n'
                       'printf "git:%s\\n" "$*" >> "$INSTALL_LOG"\n'
                       'if [[ $* == *"remote get-url origin" ]]; then\n'
                       '    printf "https://github.com/junegunn/fzf\\n"\n'
                       'fi\n')
        git.chmod(0o755)

        result = subprocess.run([str(folder / "install.sh")], capture_output=True,
                                text=True, check=False, env={**os.environ,
                                    "HOME": str(self.root), "INSTALL_LOG": str(self.log),
                                    "PATH": f"{commands}:{os.environ['PATH']}"})

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertTrue(any("pull" in line for line in self.log.read_text().splitlines()))
        self.assertIn("binary:--bin", self.log.read_text())

    def test_unrelated_fzf_directory_is_not_updated(self):
        folder = self.root / "fzf"
        folder.mkdir()
        shutil.copy2(REPO / "fzf" / "install.sh", folder / "install.sh")
        (self.root / ".fzf").mkdir()

        result = subprocess.run([str(folder / "install.sh")], capture_output=True,
                                text=True, check=False, env={**os.environ, "HOME": str(self.root)})

        self.assertNotEqual(result.returncode, 0)
        self.assertIn("not a Git checkout", result.stderr)


if __name__ == "__main__":
    unittest.main()
