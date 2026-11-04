"""Smoke checks for the top-level and component installers."""

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

    def run_zoxide_installer(self, component="zoxide", **env):
        for name in {"zoxide", component}:
            if not (self.root / name).exists():
                shutil.copytree(REPO / name, self.root / name)
        return subprocess.run(
            ["bash", str(self.root / component / "install.sh")],
            capture_output=True, text=True, check=False,
            env={**os.environ, "HOME": str(self.root), "INSTALL_LOG": str(self.log),
                 "_ZO_DATA_DIR": str(self.root / "data"), "_Z_DATA": str(self.root / ".z"),
                 **env})

    def prepare_zoxide(self):
        binary = self.root / ".local" / "bin" / "zoxide"
        binary.parent.mkdir(parents=True)
        binary.write_text(
            '#!/usr/bin/env bash\n'
            'if [[ $1 == --version ]]; then echo "zoxide 0.10.0"; exit; fi\n'
            'printf "%s|%s|%s\\n" "$*" "$_Z_DATA" "$_ZO_DATA_DIR" >> "$INSTALL_LOG"\n'
            'exit "${IMPORT_STATUS:-0}"\n')
        binary.chmod(0o755)

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

    def test_zoxide_installed_version_skips_download_and_missing_history(self):
        self.prepare_zoxide()

        result = self.run_zoxide_installer()

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("already installed", result.stdout)
        self.assertFalse(self.log.exists())
        self.assertFalse((self.root / "data" / ".dotfiles-z-imported").exists())

    def test_zoxide_bad_download_preserves_existing_binary(self):
        self.prepare_zoxide()
        binary = self.root / ".local" / "bin" / "zoxide"
        old_binary = binary.read_text().replace("0.10.0", "0.9.9")
        binary.write_text(old_binary)
        commands = self.root / "commands"
        commands.mkdir()
        curl = commands / "curl"
        curl.write_text(
            '#!/usr/bin/env bash\n'
            'while (( $# )); do\n'
            '  if [[ $1 == -o ]]; then printf "invalid archive" > "$2"; exit; fi\n'
            '  shift\n'
            'done\nexit 1\n')
        uname = commands / "uname"
        uname.write_text('#!/usr/bin/env bash\n'
                         'case $1 in -s) echo Linux;; -m) echo x86_64;; esac\n')
        for command in (curl, uname):
            command.chmod(0o755)

        result = self.run_zoxide_installer(PATH=f"{commands}:{os.environ['PATH']}")

        self.assertNotEqual(result.returncode, 0)
        self.assertIn("Checksum mismatch", result.stderr)
        self.assertEqual(binary.read_text(), old_binary)
        self.assertFalse(self.log.exists())

    def test_zoxide_imports_history_once_and_preserves_legacy_files(self):
        self.prepare_zoxide()
        history = "/home/example/Downloads|4|1234567890\n"
        (self.root / ".z").write_text(history)
        checkout = self.root / ".local" / "share" / "z"
        checkout.mkdir(parents=True)
        (checkout / "custom").write_text("keep me")

        for _ in range(2):
            result = self.run_zoxide_installer()
            self.assertEqual(result.returncode, 0, result.stderr)

        self.assertEqual(self.log.read_text().splitlines(), [
            f"import --merge z|{self.root / '.z'}|{self.root / 'data'}"])
        self.assertEqual((self.root / ".z").read_text(), history)
        self.assertEqual((checkout / "custom").read_text(), "keep me")
        self.assertTrue((self.root / "data" / ".dotfiles-z-imported").is_file())

    def test_zoxide_failed_import_can_be_retried(self):
        self.prepare_zoxide()
        (self.root / ".z").write_text("/example|1|1234567890\n")

        result = self.run_zoxide_installer(IMPORT_STATUS="1")

        self.assertNotEqual(result.returncode, 0)
        self.assertIn("Could not import", result.stderr)
        self.assertFalse((self.root / "data" / ".dotfiles-z-imported").exists())
        result = self.run_zoxide_installer()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertTrue((self.root / "data" / ".dotfiles-z-imported").exists())

    def test_bash_installer_installs_zoxide_with_custom_history_and_data_paths(self):
        self.prepare_zoxide()
        history = self.root / "old history"
        history.write_text("/example|1|1234567890\n")
        data = self.root / "new data"

        result = self.run_zoxide_installer(component="bash", _Z_DATA=str(history),
                                           _ZO_DATA_DIR=str(data))

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual((self.root / ".bashrc").resolve(), self.root / "bash" / "bashrc")
        self.assertEqual(self.log.read_text().strip(), f"import --merge z|{history}|{data}")
        self.assertTrue((data / ".dotfiles-z-imported").is_file())


if __name__ == "__main__":
    unittest.main()
