"""Check that the Vim config loads vimrc.minimal from a repository copy with any name."""

import os
import re
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path


REPO = Path(__file__).resolve().parents[1]


@unittest.skipUnless(shutil.which("vim"), "vim is not installed")
class VimConfigTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(prefix="dotfiles-vim-", dir="/tmp/opencode")
        self.addCleanup(self.tmp.cleanup)
        self.home = Path(self.tmp.name)
        self.checkout = self.home / "renamed dotfiles"
        shutil.copytree(REPO, self.checkout, ignore=shutil.ignore_patterns(".git", "__pycache__"))
        (self.home / ".vimrc").symlink_to(self.checkout / "vim" / "vimrc")

        plug = self.home / ".vim" / "autoload" / "plug.vim"
        plug.parent.mkdir(parents=True)
        plug.write_text("function! plug#begin(...)\nendfunction\n"
                        "function! plug#end()\nendfunction\n"
                        "command! -nargs=* Plug echo ''\n")

    def test_vimrc_loads_minimal_config_beside_the_symlink_target(self):
        scripts = self.home / "scriptnames.txt"
        result = subprocess.run(
            ["vim", "-Nu", str(self.home / ".vimrc"), "-i", "NONE", "-es",
             "-c", f"redir! > {scripts}", "-c", "silent scriptnames",
             "-c", "redir END", "-c", "qall!"],
            capture_output=True, text=True, check=False, stdin=subprocess.DEVNULL,
            env={**os.environ, "HOME": str(self.home)}, timeout=60)

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIsNone(re.search(r"E\d+:", result.stderr), result.stderr)
        minimal = (self.checkout / "vim" / "vimrc.minimal").relative_to(self.home)
        self.assertIn(f"~/{minimal}", scripts.read_text())


if __name__ == "__main__":
    unittest.main()
