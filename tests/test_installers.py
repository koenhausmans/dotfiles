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

    def run_installer(self, replies, *args):
        pid, fd = pty.fork()
        if pid == 0:
            env = {**os.environ, "INSTALL_LOG": str(self.log)}
            os.execve(str(self.root / "scripts" / "install"),
                      [str(self.root / "scripts" / "install"), *args], env)
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
