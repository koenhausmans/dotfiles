"""WSL agent startup checks using temporary paths and a failing stand-in."""

import os
import subprocess
import tempfile
import unittest
from pathlib import Path


REPO = Path(__file__).resolve().parents[1]


class WslAgentTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(prefix="dotfiles agent ", dir="/tmp/opencode")
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        self.marker = self.root / "session"
        self.folder = self.root / "agent"
        config = (REPO / "bash/bashrc.local.wsl").read_text()
        config = config.replace("/dev/shm/wsl-session", str(self.marker))
        config = config.replace("/dev/shm/ssh-agent", str(self.folder))
        self.config = self.root / "bashrc.local.wsl"
        self.config.write_text(config)
        commands = self.root / "commands"
        commands.mkdir()
        fake = commands / "ssh-agent"
        fake.write_text('#!/bin/sh\nprintf "attempt\\n" >> "$AGENT_LOG"\nexit 7\n')
        fake.chmod(0o755)
        self.log = self.root / "attempts"
        self.env = {**os.environ, "PATH": f"{commands}:{os.environ['PATH']}",
                    "AGENT_LOG": str(self.log)}

    def source(self):
        return subprocess.run(["bash", "-c", 'source "$1"', "bash", str(self.config)],
                              env=self.env, capture_output=True, text=True, check=False)

    def test_failed_agent_start_is_retried_next_shell(self):
        self.source()
        self.assertFalse(self.marker.exists())
        self.source()
        self.assertEqual(self.log.read_text().splitlines(), ["attempt", "attempt"])

    def test_missing_environment_is_retried_even_with_session_marker(self):
        self.marker.touch()

        self.source()

        self.assertEqual(self.log.read_text().splitlines(), ["attempt"])


if __name__ == "__main__":
    unittest.main()
