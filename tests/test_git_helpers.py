"""Exercise Git helper CLIs against temporary local repositories only."""

import os
import shutil
import subprocess
import tempfile
import time
import unittest
from pathlib import Path


REPO = Path(__file__).resolve().parents[1]


class GitHelperTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(prefix="dotfiles git ", dir="/tmp/opencode")
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        self.remote = self.root / "remote.git"
        self.work = self.root / "work"
        self.env = {**os.environ, "GIT_CONFIG_GLOBAL": "/dev/null",
                    "GIT_CONFIG_NOSYSTEM": "1", "GIT_TEMPLATE_DIR": "/dev/null"}
        self.git("init", "--bare", str(self.remote), cwd=self.root)
        self.git("init", "-b", "old-branch", str(self.work), cwd=self.root)
        self.git("config", "user.name", "Test", cwd=self.work)
        self.git("config", "user.email", "test@example.invalid", cwd=self.work)
        (self.work / "example").write_text("contents\n")
        self.git("add", "example", cwd=self.work)
        self.git("commit", "-m", "first", cwd=self.work)
        self.git("remote", "add", "origin", str(self.remote), cwd=self.work)
        self.git("push", "-u", "origin", "old-branch", cwd=self.work)

    def git(self, *args, cwd=None, check=True):
        return subprocess.run(["git", *args], cwd=cwd or self.work, env=self.env,
                              capture_output=True, text=True, check=check)

    def reject_ref(self, ref):
        hook = self.remote / "hooks" / "pre-receive"
        hook.parent.mkdir(exist_ok=True)
        hook.write_text(f'#!/bin/sh\nwhile read old new name; do\n'
                        f'  test "$name" != "{ref}" || exit 1\n'
                        'done\n')
        hook.chmod(0o755)

    def helper(self, name, *args):
        return subprocess.run([str(REPO / "bin" / name), *args], cwd=self.work,
                              env=self.env, capture_output=True, text=True, check=False)

    def has_remote_ref(self, ref):
        return self.git("--git-dir", str(self.remote), "show-ref", "--verify",
                        "--quiet", ref, check=False).returncode == 0

    def test_rejected_tag_rename_keeps_old_remote_tag(self):
        self.git("tag", "old-tag")
        self.git("push", "origin", "old-tag")
        self.reject_ref("refs/tags/new-tag")

        result = self.helper("git-rename-tag", "old-tag", "new-tag")

        self.assertNotEqual(result.returncode, 0)
        self.assertTrue(self.has_remote_ref("refs/tags/old-tag"))

    def test_successful_tag_rename_pushes_only_new_tag(self):
        self.git("tag", "old-tag")
        self.git("push", "origin", "old-tag")
        self.git("tag", "private-tag")

        result = self.helper("git-rename-tag", "old-tag", "new-tag")

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertTrue(self.has_remote_ref("refs/tags/new-tag"))
        self.assertFalse(self.has_remote_ref("refs/tags/old-tag"))
        self.assertFalse(self.has_remote_ref("refs/tags/private-tag"))

    def test_rejected_branch_rename_keeps_old_remote_and_local_branch(self):
        self.reject_ref("refs/heads/new-branch")

        result = self.helper("git-rename-branch", "old-branch", "new-branch")

        self.assertNotEqual(result.returncode, 0)
        self.assertTrue(self.has_remote_ref("refs/heads/old-branch"))
        self.assertEqual(self.git("branch", "--show-current").stdout.strip(), "old-branch")

    def test_successful_branch_rename_tracks_only_new_remote_branch(self):
        result = self.helper("git-rename-branch", "old-branch", "new-branch")

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertTrue(self.has_remote_ref("refs/heads/new-branch"))
        self.assertFalse(self.has_remote_ref("refs/heads/old-branch"))
        self.assertEqual(self.git("rev-parse", "--abbrev-ref", "--symbolic-full-name",
                                  "@{upstream}").stdout.strip(), "origin/new-branch")

    def test_no_gone_branches_is_a_successful_noop(self):
        result = self.helper("git-remove-old-local-branches")

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertTrue(self.has_remote_ref("refs/heads/old-branch"))

    def test_failed_branch_listing_is_not_reported_as_noop(self):
        fake = self.root / "commands"
        fake.mkdir()
        git = fake / "git"
        git.write_text('#!/bin/sh\n'
                       'if [ "$1" = for-each-ref ]; then exit 7; fi\n'
                       'exec "$REAL_GIT" "$@"\n')
        git.chmod(0o755)

        result = subprocess.run([str(REPO / "bin/git-remove-old-local-branches")],
                                cwd=self.work, capture_output=True, text=True, check=False,
                                env={**self.env, "REAL_GIT": shutil.which("git"),
                                     "PATH": f"{fake}:{os.environ['PATH']}"})

        self.assertNotEqual(result.returncode, 0)

    def test_gone_noncurrent_branch_is_removed(self):
        self.git("switch", "-c", "stale-branch")
        self.git("push", "-u", "origin", "stale-branch")
        self.git("switch", "old-branch")
        self.git("push", "origin", "--delete", "stale-branch")

        result = self.helper("git-remove-old-local-branches")

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertNotIn("stale-branch", self.git("branch", "--list").stdout)

    def test_ctags_failure_keeps_previous_tags(self):
        tags = self.work / ".tags"
        tags.write_text("existing tags\n")
        fake = self.root / "commands"
        fake.mkdir()
        ctags = fake / "ctags"
        ctags.write_text("#!/bin/sh\nexit 7\n")
        ctags.chmod(0o755)

        result = subprocess.run([str(REPO / "git/git-template/hooks/ctags")],
                                cwd=self.work, capture_output=True, text=True,
                                check=False, env={**self.env, "TMPDIR": str(self.root),
                                                  "PATH": f"{fake}:{os.environ['PATH']}"})

        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(tags.read_text(), "existing tags\n")

    def test_ctags_git_listing_failure_keeps_previous_tags(self):
        tags = self.work / ".tags"
        tags.write_text("existing tags\n")
        fake = self.root / "commands"
        fake.mkdir()
        git = fake / "git"
        git.write_text('#!/bin/sh\n'
                       'if [ "$1" = ls-files ] && [ "$#" -eq 1 ]; then exit 7; fi\n'
                       'exec "$REAL_GIT" "$@"\n')
        git.chmod(0o755)
        ctags = fake / "ctags"
        ctags.write_text('#!/bin/sh\n'
                          'while [ "$#" -gt 0 ]; do\n'
                          '  if [ "$1" = -f ]; then shift; printf "new tags\\n" > "$1"; fi\n'
                          '  shift\n'
                          'done\n')
        ctags.chmod(0o755)

        result = subprocess.run([str(REPO / "git/git-template/hooks/ctags")],
                                cwd=self.work, capture_output=True, text=True,
                                check=False, env={**self.env, "TMPDIR": str(self.root),
                                                  "REAL_GIT": shutil.which("git"),
                                                  "PATH": f"{fake}:{os.environ['PATH']}"})

        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(tags.read_text(), "existing tags\n")

    def test_post_checkout_hook_finds_ctags_in_a_worktree(self):
        linked = self.root / "linked"
        self.git("worktree", "add", "-b", "linked", str(linked))
        hook = self.work / ".git" / "hooks" / "ctags"
        hook.parent.mkdir(exist_ok=True)
        marker = self.root / "hook-ran"
        hook.write_text(f'#!/bin/sh\nprintf "yes\\n" > "{marker}"\n')
        hook.chmod(0o755)

        subprocess.run([str(REPO / "git/git-template/hooks/post-checkout")],
                       cwd=linked, check=True, env=self.env)

        for _ in range(30):
            if marker.exists():
                break
            time.sleep(0.01)
        self.assertTrue(marker.exists(), "post-checkout did not find the shared hook")

    def test_ctags_alias_finds_shared_hook_in_a_worktree(self):
        linked = self.root / "linked"
        self.git("worktree", "add", "-b", "linked", str(linked))
        hook = self.work / ".git" / "hooks" / "ctags"
        hook.parent.mkdir(exist_ok=True)
        marker = self.root / "alias-ran"
        hook.write_text(f'#!/bin/sh\nprintf "yes\\n" > "{marker}"\n')
        hook.chmod(0o755)

        result = subprocess.run(["git", "ctags"], cwd=linked, check=False,
                                capture_output=True, text=True,
                                env={**self.env, "GIT_CONFIG_GLOBAL":
                                     str(REPO / "git" / "gitconfig")})

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertTrue(marker.exists())


    def target(self):
        return subprocess.run(["bash", "-c", f'source "{REPO}/lib/git.sh"; git_target'],
                              cwd=self.work, env=self.env, capture_output=True,
                              text=True, check=False)

    def test_target_prefers_develop_over_main(self):
        self.git("branch", "main")
        self.git("branch", "develop")
        self.assertEqual(self.target().stdout, "develop\n")

    def test_target_falls_back_to_main(self):
        self.git("branch", "main")
        self.assertEqual(self.target().stdout, "main\n")

    def test_target_config_overrides_develop(self):
        self.git("branch", "main")
        self.git("branch", "develop")
        self.git("config", "dotfiles.target", "main")
        self.assertEqual(self.target().stdout, "main\n")

    def test_target_without_known_branch_fails(self):
        result = self.target()
        self.assertEqual(result.returncode, 1)
        self.assertIn("No local develop, main or master", result.stderr)

    def test_start_branches_from_develop(self):
        self.git("branch", "main")
        self.git("switch", "-c", "develop")
        (self.work / "develop-only").write_text("x\n")
        self.git("add", "develop-only")
        self.git("commit", "-m", "develop")
        result = self.helper("git-start", "feature")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(self.git("rev-parse", "feature").stdout,
                         self.git("rev-parse", "develop").stdout)

    def test_trail_marks_unpushed_and_fork_point(self):
        self.git("branch", "develop")
        self.git("switch", "-c", "feature")
        self.git("commit", "--allow-empty", "-m", "local")
        result = self.helper("git-trail")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("forked from", result.stdout)
        self.assertIn("◆", result.stdout)
        self.assertIn("local", result.stdout)

    def test_trail_on_detached_head(self):
        self.git("switch", "--detach")
        result = self.helper("git-trail")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("detached HEAD", result.stdout)
        self.assertEqual(result.stderr, "")

if __name__ == "__main__":
    unittest.main()
