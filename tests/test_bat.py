"""Check file previews and shell integration through their command-line interfaces."""

import os
import shlex
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path


REPO = Path(__file__).resolve().parents[1]
PREVIEW = REPO / "bin/fzf-file-preview"


class BatTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(prefix="dotfiles bat ", dir="/tmp/opencode")
        self.addCleanup(self.tmp.cleanup)
        self.home = Path(self.tmp.name)
        self.commands = self.home / "commands"
        self.commands.mkdir()
        for name in ("bash", "ls", "sed"):
            (self.commands / name).symlink_to(shutil.which(name))
        self.env = {**os.environ, "HOME": str(self.home), "PATH": str(self.commands)}

    def fake_bat(self, name):
        command = self.commands / name
        command.write_text('#!/usr/bin/env bash\nprintf "%s\\n" "${0##*/}" "$@"\n')
        command.chmod(0o755)

    def preview(self, *args):
        return subprocess.run([str(PREVIEW), *args], env=self.env, cwd=self.home,
                              capture_output=True, text=True, timeout=10)

    def test_preview_supports_both_binary_names_and_safe_filenames(self):
        filename = "- odd ' $(touch INJECTED).py"
        (self.home / filename).write_text("print('hello')\n")
        for name in ("batcat", "bat"):
            with self.subTest(binary=name):
                self.fake_bat(name)
                result = self.preview(filename)
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertEqual(result.stdout.splitlines(), [
                    name, "--color=always", "--style=numbers,changes", "--paging=never",
                    "--line-range=:300", "--", filename,
                ])
                self.assertFalse((self.home / "INJECTED").exists())

    def test_preview_lists_directories_without_running_bat(self):
        self.fake_bat("bat")
        folder = self.home / "a directory"
        folder.mkdir()
        (folder / "child.txt").touch()
        result = self.preview(str(folder))
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("child.txt", result.stdout)
        self.assertNotIn("--paging", result.stdout)

    def test_preview_without_bat_is_limited_to_300_lines(self):
        file = self.home / "long.txt"
        file.write_text("".join(f"line {i}\n" for i in range(1, 401)))
        result = self.preview(str(file))
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(len(result.stdout.splitlines()), 300)
        self.assertEqual(result.stdout.splitlines()[-1], "line 300")

    def test_file_named_dash_is_not_read_from_stdin(self):
        (self.home / "-").write_text("file contents\n")
        result = subprocess.run([str(PREVIEW), "-"], input="wrong stdin\n",
                                env=self.env, cwd=self.home, capture_output=True,
                                text=True, timeout=10)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stdout, "file contents\n")
        for name in ("batcat", "bat"):
            with self.subTest(binary=name):
                self.fake_bat(name)
                result = self.preview("-")
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertEqual(result.stdout.splitlines()[-2:], ["--", "./-"])

    def test_preview_does_not_read_pipes_or_missing_files(self):
        fifo = self.home / "fifo"
        os.mkfifo(fifo)
        for path in (fifo, self.home / "missing"):
            with self.subTest(path=path):
                result = self.preview(str(path))
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertIn("Cannot preview:", result.stdout)

    def shell_options(self, shell, **extra_env):
        for name in ("dirname", "readlink"):
            command = self.commands / name
            if not command.exists():
                command.symlink_to(shutil.which(name))
        fzf = self.commands / "fzf"
        fzf.write_text("#!/usr/bin/env bash\nprintf ':\\n'\n")
        fzf.chmod(0o755)
        rc = REPO / {"bash": "bash/bashrc", "zsh": "zsh/zshrc",
                     "fish": "fish/config.fish"}[shell]
        print_options = 'printf "PREVIEW=%s\\n" "$FZF_CTRL_T_OPTS"'
        script = f'source {shlex.quote(str(rc))}; bash -c {shlex.quote(print_options)}'
        arguments = {"bash": ["--noprofile", "--norc"], "zsh": ["-f"],
                     "fish": ["--no-config"]}[shell]
        env = {key: value for key, value in self.env.items()
               if key not in ("FZF_CTRL_T_OPTS", "XDG_CONFIG_HOME", "ZDOTDIR")}
        result = subprocess.run([shutil.which(shell), *arguments, "-ic", script],
                                env={**env, **extra_env}, cwd=self.home,
                                capture_output=True, text=True, timeout=10)
        self.assertEqual(result.returncode, 0, result.stderr)
        return next(line.removeprefix("PREVIEW=") for line in result.stdout.splitlines()
                    if line.startswith("PREVIEW="))

    def test_shells_enable_only_file_picker_previews_when_bat_is_available(self):
        for shell in ("bash", "zsh", "fish"):
            if not shutil.which(shell):
                continue
            for binary in (None, "batcat", "bat"):
                with self.subTest(shell=shell, binary=binary):
                    if binary:
                        self.fake_bat(binary)
                    options = self.shell_options(shell)
                    expected = "--preview 'fzf-file-preview {}'" if binary else ""
                    self.assertEqual(options, expected)
                    if binary:
                        (self.commands / binary).unlink()

    def test_shells_preserve_existing_options_including_explicitly_empty(self):
        self.fake_bat("bat")
        for shell in ("bash", "zsh", "fish"):
            if not shutil.which(shell):
                continue
            for options in ("", "--height=60% --preview 'custom {}'"):
                with self.subTest(shell=shell, options=options):
                    self.assertEqual(self.shell_options(shell, FZF_CTRL_T_OPTS=options),
                                     options)

    def test_local_shell_configs_can_override_preview_options(self):
        self.fake_bat("bat")
        fish_dir = self.home / ".config/fish"
        fish_dir.mkdir(parents=True)
        (self.home / ".bashrc.local").write_text('export FZF_CTRL_T_OPTS="local-preview"\n')
        (self.home / ".zshrc.local").write_text('export FZF_CTRL_T_OPTS="local-preview"\n')
        (fish_dir / "config.local.fish").write_text('set -gx FZF_CTRL_T_OPTS local-preview\n')
        for shell in ("bash", "zsh", "fish"):
            if shutil.which(shell):
                with self.subTest(shell=shell):
                    self.assertEqual(self.shell_options(shell), "local-preview")


if __name__ == "__main__":
    unittest.main()
