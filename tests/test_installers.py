"""Smoke checks for the top-level and Vim installers."""

import os
import pty
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path


REPO = Path(__file__).resolve().parents[1]


class InstallerTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(prefix="dotfiles-install-")
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        self.log = self.root / "installed"
        shutil.copy2(REPO / "install.sh", self.root / "install.sh")
        shutil.copytree(REPO / "lib", self.root / "lib")

    def run_with_tty(self, args, reply):
        pid, fd = pty.fork()
        if pid == 0:
            os.execve(str(self.root / "install.sh"), [str(self.root / "install.sh"), *args],
                      {**os.environ, "HOME": str(self.root), "INSTALL_LOG": str(self.log)})
        os.write(fd, reply.encode())
        try:
            while os.read(fd, 4096):
                pass
        except OSError:
            pass
        os.close(fd)
        return os.waitstatus_to_exitcode(os.waitpid(pid, 0)[1])

    def run_vim_installer(self, **env):
        shutil.copytree(REPO / "vim", self.root / "vim")
        commands = self.root / "commands"
        commands.mkdir()
        wget = commands / "wget"
        wget.write_text('#!/usr/bin/env bash\necho "wget:$*" >> "$INSTALL_LOG"\n')
        wget.chmod(0o755)
        return subprocess.run(
            [str(self.root / "vim" / "install.sh")], capture_output=True, text=True, check=False,
            env={**os.environ, "HOME": str(self.root), "INSTALL_LOG": str(self.log),
                 "PATH": f"{commands}:{os.environ['PATH']}", **env})

    def test_unknown_argument_is_rejected(self):
        result = subprocess.run([str(self.root / "install.sh"), "minimal"],
                                capture_output=True, text=True, check=False)

        self.assertEqual(result.returncode, 1)
        self.assertIn("Usage:", result.stderr)

    def test_server_profile_runs_only_server_components(self):
        for name in ("bash", "vim", "screen", "tmux", "zsh"):
            (self.root / name).mkdir()
            installer = self.root / name / "install.sh"
            installer.write_text(f'#!/usr/bin/env bash\necho "{name}:$DOTFILES_PROFILE" >> "$INSTALL_LOG"\n')
            installer.chmod(0o755)

        self.assertEqual(self.run_with_tty(["server"], "Y"), 0)
        self.assertEqual(sorted(self.log.read_text().split()),
                         sorted(f"{n}:server" for n in ("bash", "vim", "screen", "tmux")))

    def test_vim_links_full_config_by_default(self):
        result = self.run_vim_installer()

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual((self.root / ".vimrc").resolve(), self.root / "vim" / "vimrc")
        self.assertFalse(self.log.exists())

    def test_vim_links_minimal_config_for_server(self):
        result = self.run_vim_installer(DOTFILES_PROFILE="server")

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual((self.root / ".vimrc").resolve(), self.root / "vim" / "vimrc.minimal")
        self.assertIn("apprentice.vim", self.log.read_text())


if __name__ == "__main__":
    unittest.main()
