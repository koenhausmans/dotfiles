"""Check syntax of tracked shell entry points without running them."""

import shutil
import subprocess
import unittest
from pathlib import Path


REPO = Path(__file__).resolve().parents[1]


class ShellSyntaxTests(unittest.TestCase):
    def test_shell_scripts_parse(self):
        tracked = subprocess.check_output(["git", "ls-files", "-z"], cwd=REPO)
        for name in (n.decode() for n in tracked.split(b"\0") if n):
            file = REPO / name
            if not file.is_file():
                continue
            with file.open("rb") as source:
                first = source.readline().decode("utf-8", errors="replace")
            if first.startswith("#!") and "bash" in first:
                shell = "bash"
            elif first.startswith("#!") and first.rstrip().endswith("/sh"):
                shell = "sh"
            elif name.endswith(".fish"):
                shell = "fish"
            elif name == "zsh/zshrc":
                shell = "zsh"
            elif name in ("bash/bashrc", "bash/bash_profile", "bash/bashrc.local.wsl"):
                shell = "bash"
            else:
                continue
            if not shutil.which(shell):
                continue
            with self.subTest(file=name):
                result = subprocess.run([shell, "-n", str(file)], capture_output=True,
                                        text=True, check=False)
                self.assertEqual(result.returncode, 0, result.stderr)


if __name__ == "__main__":
    unittest.main()
