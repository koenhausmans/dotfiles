"""Checks for small command-line utilities."""

import subprocess
import tempfile
import unittest
from pathlib import Path


REPO = Path(__file__).resolve().parents[1]
DISK_USAGE = REPO / "bin" / "sorted_disk_usage"


class SortedDiskUsageTests(unittest.TestCase):
    def test_path_with_spaces_is_one_argument(self):
        with tempfile.TemporaryDirectory(prefix="disk usage ", dir="/tmp/opencode") as path:
            result = subprocess.run([str(DISK_USAGE), path], capture_output=True,
                                    text=True, check=False)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertIn(path, result.stdout)

    def test_invalid_size_and_missing_path_fail(self):
        for arguments in (["--size"], ["--size=bad"], ["/no/such/directory"]):
            with self.subTest(arguments=arguments):
                result = subprocess.run([str(DISK_USAGE), *arguments],
                                        capture_output=True, text=True, check=False)
                self.assertNotEqual(result.returncode, 0)


if __name__ == "__main__":
    unittest.main()
