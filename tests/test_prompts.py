"""Check prompt behavior with a controlled single Git status response."""

import os
import shlex
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path


REPO = Path(__file__).resolve().parents[1]


class PromptTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(prefix="dotfiles prompt ", dir="/tmp/opencode")
        self.addCleanup(self.tmp.cleanup)
        self.home = Path(self.tmp.name)
        self.checkout = self.home / "my dotfiles"
        shutil.copytree(REPO, self.checkout, ignore=shutil.ignore_patterns(".git", "__pycache__"))
        commands = self.home / "commands"
        commands.mkdir()
        git = commands / "git"
        git.write_text('#!/usr/bin/env bash\n'
                       'printf "%s\\n" "$*" >> "$GIT_CALL_LOG"\n'
                       'if [[ $* != "status --porcelain=v2 --branch --show-stash" ]]; then exit 9; fi\n'
                       'printf "%s\\n" "$FAKE_GIT_STATUS"\n')
        git.chmod(0o755)
        self.log = self.home / "git-calls"
        self.env = {**os.environ, "HOME": str(self.home),
                    "PATH": f"{commands}:{os.environ['PATH']}",
                    "GIT_CALL_LOG": str(self.log)}
        self.env.pop("DOTFILES", None)

    def test_bash_shows_flags_without_evaluating_branch_name(self):
        branch = '$(printf${IFS}INJECTED)'
        self.env["FAKE_GIT_STATUS"] = (f"# branch.oid 0123456789\n# branch.head {branch}\n"
                                       "# branch.upstream origin/main\n# branch.ab +2 -1\n"
                                       "# stash 1\n? new.txt")
        result = subprocess.run(
            ["bash", "--noprofile", "--rcfile", str(self.checkout / "bash/bashrc"),
             "-ic", '_prompt_command; printf "%s\\n" "${PS1@P}"'],
            cwd=self.home, env=self.env, capture_output=True, text=True, check=False)

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn(branch, result.stdout)
        self.assertNotIn("INJECTED", result.stdout.replace(branch, ""))
        self.assertIn("S", result.stdout)
        self.assertIn("P", result.stdout)
        self.assertEqual(self.log.read_text().splitlines(),
                         ["status --porcelain=v2 --branch --show-stash"])

    def test_bash_distinguishes_staged_and_unstaged_changes(self):
        self.env["FAKE_GIT_STATUS"] = ("# branch.oid 0123456789\n# branch.head topic\n"
                                       "1 MM N... 100644 100644 100644 abc abc file.txt")

        result = subprocess.run(
            ["bash", "--noprofile", "--rcfile", str(self.checkout / "bash/bashrc"),
             "-ic", '_prompt_command; printf "%s\\n" "${PS1@P}"'],
            cwd=self.home, env=self.env, capture_output=True, text=True, check=False)

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("topic", result.stdout)
        self.assertIn("|+!", result.stdout)

    def test_zsh_shows_current_branch_status_using_one_git_call(self):
        self.env["FAKE_GIT_STATUS"] = ("# branch.oid 0123456789\n# branch.head topic\n"
                                       "# branch.upstream origin/topic\n# branch.ab +2 -1\n"
                                       "# stash 1\n? new.txt")
        zshrc = shlex.quote(str(self.checkout / "zsh/zshrc"))
        result = subprocess.run(
            ["zsh", "-f", "-c", f'source {zshrc}; precmd; '
                              'print -r -- "$RPROMPT"'],
            cwd=self.home, env=self.env, capture_output=True, text=True, check=False)

        self.assertEqual(result.returncode, 0, result.stderr)
        for indicator in ("topic", "↑2", "↓1", "±", "S"):
            self.assertIn(indicator, result.stdout)
        self.assertEqual(self.log.read_text().splitlines(),
                         ["status --porcelain=v2 --branch --show-stash"])

    def test_rc_files_put_their_own_bin_on_path_without_dotfiles_variable(self):
        expected = f"{self.checkout}/bin"
        bash = ["bash", "--noprofile", "--rcfile", str(self.checkout / "bash/bashrc"),
                "-ic", 'printf "%s\\n" "$PATH"']
        zsh = ["zsh", "-f", "-c",
               f"source {shlex.quote(str(self.checkout / 'zsh/zshrc'))}; print -r -- $PATH"]
        fish = ["fish", "--no-config", "-c",
                f"source {shlex.quote(str(self.checkout / 'fish/config.fish'))}; "
                "string join : $PATH"]
        for shell, command in (("bash", bash), ("zsh", zsh), ("fish", fish)):
            with self.subTest(shell=shell):
                if shutil.which(shell) is None:
                    self.skipTest(f"{shell} is not installed")
                result = subprocess.run(command, cwd=self.home, env=self.env,
                                        capture_output=True, text=True, check=False)

                self.assertEqual(result.returncode, 0, result.stderr)
                path_entries = result.stdout.splitlines()[-1].split(":")
                self.assertIn(expected, path_entries)


if __name__ == "__main__":
    unittest.main()
