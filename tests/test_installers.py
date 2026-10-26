"""Installer CLI checks using harmless stand-in component installers."""

import errno
import hashlib
import os
import pty
import re
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
        shutil.copy2(REPO / "install.sh", self.root / "install.sh")
        shutil.copytree(REPO / "lib", self.root / "lib")
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

    def run_command(self, command, replies, *args, env=None):
        pid, fd = pty.fork()
        if pid == 0:
            environment = {**os.environ, "INSTALL_LOG": str(self.log), **(env or {})}
            os.execve(str(command), [str(command), *args], environment)
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

    def run_installer(self, replies):
        return self.run_command(self.root / "install.sh", replies)

    def nvim_installer(self):
        folder = self.root / "nvim"
        folder.mkdir()
        shutil.copy2(REPO / "nvim" / "install.sh", folder / "install.sh")
        (folder / "init.vim").write_text('" fixture\n')
        return folder / "install.sh"

    def themes_installer(self):
        shutil.copytree(REPO / "themes", self.root / "themes")
        return self.root / "themes" / "install.sh"

    def tool_path(self, *tools):
        """Return a PATH with the commands theme installers use and stand-in tools."""
        folder = Path(tempfile.mkdtemp(dir=self.root))
        for name in ("bash", "dirname", "ln", "mkdir", "mv", "readlink", "rm"):
            (folder / name).symlink_to(shutil.which(name))
        for name in tools:
            (folder / name).write_text("#!/usr/bin/env bash\n")
            (folder / name).chmod(0o755)
        return str(folder)

    def run_theme_installer(self, installer, *tools, **env):
        environment = {key: value for key, value in os.environ.items()
                       if key not in ("CLAUDE_CONFIG_DIR", "XDG_CONFIG_HOME")}
        environment.update(HOME=str(self.root), PATH=self.tool_path(*tools), **env)
        return subprocess.run([str(installer)], capture_output=True, text=True, check=False,
                              env=environment, start_new_session=True)

    def run_fzf_installer(self, *, installed="", checksum=None):
        """Run fzf/install.sh with stand-ins for the download and package tools."""
        folder = self.root / "fzf"
        folder.mkdir()
        shutil.copy2(REPO / "fzf" / "install.sh", folder / "install.sh")
        commands = self.root / "commands"
        commands.mkdir()
        tools = {
            "curl": 'printf "curl:%s\\n" "$*" >> "$INSTALL_LOG"\n'
                    'while (( $# )); do\n'
                    '    case $1 in\n'
                    '        -w) printf "https://github.com/junegunn/fzf/releases/tag/v0.74.5"; exit 0 ;;\n'
                    '        -o) out=$2; shift ;;\n'
                    '    esac\n'
                    '    shift\n'
                    'done\n'
                    'case $out in\n'
                    '    *.deb) printf "package" > "$out" ;;\n'
                    '    *.txt) printf "%s  fzf_0.74.5_amd64.deb\\n" "$FAKE_CHECKSUM" > "$out" ;;\n'
                    'esac\n',
            "dpkg": 'if [[ $1 == --print-architecture ]]; then echo amd64; exit; fi\n'
                    'printf "dpkg:%s\\n" "$1" >> "$INSTALL_LOG"\n',
            "dpkg-query": '[[ -n $FAKE_INSTALLED ]] && printf "%s" "$FAKE_INSTALLED"\n',
            "sudo": 'exec "$@"\n',
        }
        for name, body in tools.items():
            (commands / name).write_text("#!/usr/bin/env bash\n" + body)
            (commands / name).chmod(0o755)
        if checksum is None:
            checksum = hashlib.sha256(b"package").hexdigest()
        return subprocess.run([str(folder / "install.sh")], capture_output=True, text=True,
                              check=False, env={**os.environ,
                                  "HOME": str(self.root), "INSTALL_LOG": str(self.log),
                                  "FAKE_INSTALLED": installed, "FAKE_CHECKSUM": checksum,
                                  "PATH": f"{commands}:{os.environ['PATH']}"})

    def test_yes_to_all_runs_only_known_components_in_order(self):
        self.component("bash")
        self.component("fish")
        self.component("themes")
        self.component("bash", nested=True)
        self.component("unexpected")

        status, output = self.run_installer("Y\n")

        self.assertEqual(status, 0, output)
        self.assertEqual(self.log.read_text().splitlines(), [
            "bash:<>",
            "fish:<>",
            "themes:<>",
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

    def test_component_prompt_colors_the_target_and_choices(self):
        self.component("bash")

        status, output = self.run_installer("n")

        self.assertEqual(status, 0, output)
        self.assertIn("\x1b[1;36mbash/install.sh\x1b[0m", output)
        self.assertIn("\x1b[0;32m[y]\x1b[0mes", output)
        self.assertIn("\x1b[1;32m[Y]\x1b[0mes to all", output)
        self.assertIn("\x1b[0;34m[n]\x1b[0mo", output)
        self.assertFalse(self.log.exists())

    def test_link_conflict_identifies_home_path_and_colored_choices(self):
        installer = self.nvim_installer()
        destination = self.root / ".config" / "nvim" / "init.vim"
        destination.parent.mkdir(parents=True)
        destination.write_text("existing\n")

        status, output = self.run_command(installer, "s\n", env={"HOME": str(self.root)})

        self.assertEqual(status, 0, output)
        self.assertIn("[ \x1b[0;33m??\x1b[0m ] File already exists:", output)
        self.assertIn("\x1b[1;36m~/.config/nvim/init.vim\x1b[0m", output)
        self.assertIn("Link from: ~/nvim/init.vim", output)
        for choice in ("\x1b[0;34m[s]\x1b[0m", "\x1b[1;34m[S]\x1b[0m",
                       "\x1b[0;31m[o]\x1b[0m", "\x1b[1;31m[O]\x1b[0m",
                       "\x1b[0;32m[b]\x1b[0m", "\x1b[1;32m[B]\x1b[0m"):
            self.assertIn(choice, output)
        self.assertIn("Skipped: ~/.config/nvim/init.vim", output)
        self.assertEqual(destination.read_text(), "existing\n")

    def test_link_backup_and_repeat_install_keep_files_safe(self):
        installer = self.nvim_installer()
        destination = self.root / ".config" / "nvim" / "init.vim"
        destination.parent.mkdir(parents=True)
        destination.write_text("existing\n")

        status, output = self.run_command(installer, "b\n", env={"HOME": str(self.root)})

        self.assertEqual(status, 0, output)
        self.assertEqual((destination.parent / "init.vim.backup").read_text(), "existing\n")
        self.assertTrue(destination.is_symlink())
        self.assertEqual(destination.resolve(), self.root / "nvim" / "init.vim")
        self.assertIn("Backed up: ~/.config/nvim/init.vim.backup", output)
        self.assertIn("Linked: ~/.config/nvim/init.vim -> ~/nvim/init.vim", output)

        status, output = self.run_command(installer, "", env={"HOME": str(self.root)})

        self.assertEqual(status, 0, output)
        self.assertIn("Already linked: ~/.config/nvim/init.vim", output)
        self.assertNotIn("File already exists:", output)

    def test_link_conflict_without_terminal_does_not_change_existing_file(self):
        installer = self.nvim_installer()
        destination = self.root / ".config" / "nvim" / "init.vim"
        destination.parent.mkdir(parents=True)
        destination.write_text("existing\n")

        result = subprocess.run([str(installer)], capture_output=True, text=True,
                                check=False, env={**os.environ, "HOME": str(self.root)})

        self.assertNotEqual(result.returncode, 0)
        self.assertIn("Cannot choose what to do with ~/.config/nvim/init.vim", result.stderr)
        self.assertEqual(destination.read_text(), "existing\n")

    def test_paths_outside_home_and_backslashes_are_printed_literally(self):
        self.nvim_installer()
        home = self.root / "home"
        home.mkdir()
        destination = self.root / "elsewhere" / "nvim" / "init\\e[31m.vim"
        destination.parent.mkdir(parents=True)
        destination.write_text("existing\n")
        # Call the link helper through a stand-in installer with a custom destination.
        wrapper = self.root / "nvim" / "custom-install.sh"
        wrapper.write_text('#!/usr/bin/env bash\n'
                           'source "$(dirname "$0")/../lib/links.sh"\n'
                           'link_files "$1" "$2"\n')
        wrapper.chmod(0o755)

        status, output = self.run_command(wrapper, "s\n", str(self.root / "nvim" / "init.vim"), str(destination),
                                          env={"HOME": str(home)})

        self.assertEqual(status, 0, output)
        self.assertIn(str(destination), output)
        self.assertNotIn("~", output)
        self.assertEqual(destination.read_text(), "existing\n")

    def test_arguments_are_rejected(self):
        result = subprocess.run([str(self.root / "install.sh"), "minimal"],
                                capture_output=True, text=True, check=False)

        self.assertEqual(result.returncode, 1)
        self.assertIn("Usage:", result.stderr)

    def test_bash_and_zsh_sync_shared_z_repo_once(self):
        for name in ("bash", "zsh"):
            shutil.copytree(REPO / name, self.root / name)
        commands = self.root / "commands"
        commands.mkdir()
        git = commands / "git"
        git.write_text('#!/usr/bin/env bash\n'
                       'printf "%s\\n" "$*" >> "$INSTALL_LOG"\n'
                       'if [[ $1 == clone ]]; then mkdir -p "${@: -1}"; fi\n')
        git.chmod(0o755)

        status, output = self.run_command(self.root / "install.sh", "Y\n", env={
            "HOME": str(self.root), "PATH": f"{commands}:{os.environ['PATH']}"})

        self.assertEqual(status, 0, output)
        self.assertTrue((self.root / ".bashrc").is_symlink())
        self.assertTrue((self.root / ".zshrc").is_symlink())
        z_calls = [line for line in self.log.read_text().splitlines()
                   if re.search(r"share/z( |$)", line)]
        self.assertEqual(len(z_calls), 1)

    def run_vim_installer(self, replies, env=None):
        shutil.copytree(REPO / "vim", self.root / "vim")
        commands = self.root / "commands"
        commands.mkdir(exist_ok=True)
        wget = commands / "wget"
        wget.write_text('#!/usr/bin/env bash\n'
                        'printf "wget:%s\\n" "$*" >> "$INSTALL_LOG"\n')
        wget.chmod(0o755)
        environment = {"HOME": str(self.root), "PATH": f"{commands}:{os.environ['PATH']}",
                       **(env or {})}
        return self.run_command(self.root / "vim" / "install.sh", replies, env=environment)

    def test_vim_minimal_answer_links_minimal_config_and_fetches_colorscheme(self):
        status, output = self.run_vim_installer("y\n")

        self.assertEqual(status, 0, output)
        self.assertEqual((self.root / ".vimrc").resolve(), self.root / "vim" / "vimrc.minimal")
        self.assertIn("apprentice.vim", self.log.read_text())

    def test_vim_full_answer_links_full_config_without_download(self):
        status, output = self.run_vim_installer("n\n")

        self.assertEqual(status, 0, output)
        self.assertEqual((self.root / ".vimrc").resolve(), self.root / "vim" / "vimrc")
        self.assertFalse(self.log.exists())

    def test_vim_question_without_terminal_changes_nothing(self):
        shutil.copytree(REPO / "vim", self.root / "vim")

        result = subprocess.run([str(self.root / "vim" / "install.sh")], capture_output=True,
                                text=True, check=False,
                                env={**os.environ, "HOME": str(self.root)})

        self.assertNotEqual(result.returncode, 0)
        self.assertIn("without a terminal", result.stderr)
        self.assertFalse((self.root / ".vimrc").exists())

    def test_zsh_stops_after_a_failed_clone(self):
        folder = self.root / "zsh"
        shutil.copytree(REPO / "zsh", folder)
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

    def test_fzf_deb_is_installed_after_checksum_check(self):
        result = self.run_fzf_installer()

        self.assertEqual(result.returncode, 0, result.stderr)
        log = self.log.read_text()
        self.assertIn("releases/download/v0.74.5/fzf_0.74.5_amd64.deb", log)
        self.assertIn("releases/download/v0.74.5/fzf_0.74.5_checksums.txt", log)
        self.assertIn("dpkg:-i", log)
        self.assertNotIn("can be removed", result.stdout)

    def test_current_fzf_is_not_reinstalled(self):
        result = self.run_fzf_installer(installed="0.74.5")

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("already installed", result.stdout)
        self.assertEqual(len(self.log.read_text().splitlines()), 1)

    def test_fzf_checksum_mismatch_is_not_installed(self):
        result = self.run_fzf_installer(checksum="0" * 64)

        self.assertNotEqual(result.returncode, 0)
        self.assertIn("Checksum mismatch", result.stderr)
        self.assertNotIn("dpkg:-i", self.log.read_text())

    def test_old_fzf_checkout_is_reported_but_kept(self):
        (self.root / ".fzf").mkdir()

        result = self.run_fzf_installer()

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("can be removed", result.stdout)
        self.assertTrue((self.root / ".fzf").is_dir())

    def test_theme_installers_skip_tools_that_are_not_installed(self):
        installer = self.themes_installer()

        result = self.run_theme_installer(installer)

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("Claude Code is not installed, skipping its themes", result.stdout)
        self.assertIn("OpenCode is not installed, skipping its themes", result.stdout)
        for config in (".claude", ".config"):
            self.assertFalse((self.root / config).exists(), config)

    def test_theme_installers_link_themes_for_installed_tools_once(self):
        installer = self.themes_installer()
        themes = sorted(path.name for path in (REPO / "themes" / "opencode").glob("*.json"))
        linked = self.root / "xdg" / "opencode" / "themes"

        result = self.run_theme_installer(installer, "opencode", XDG_CONFIG_HOME=str(self.root / "xdg"))

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("Claude Code is not installed", result.stdout)
        self.assertEqual(sorted(path.name for path in linked.iterdir()), themes)
        for name in themes:
            self.assertEqual((linked / name).resolve(), self.root / "themes" / "opencode" / name)

        result = self.run_theme_installer(installer, "opencode", XDG_CONFIG_HOME=str(self.root / "xdg"))

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stdout.count("Already linked:"), len(themes))

    def test_claude_code_themes_follow_claude_config_dir(self):
        self.themes_installer()
        themes = sorted(path.name for path in (REPO / "themes" / "claude-code").glob("*.json"))
        linked = self.root / "claude config" / "themes"

        result = self.run_theme_installer(self.root / "themes" / "claude-code" / "install.sh", "claude",
                                          CLAUDE_CONFIG_DIR=str(self.root / "claude config"))

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(sorted(path.name for path in linked.iterdir()), themes)
        self.assertFalse((self.root / ".claude").exists())

    def run_tools_installer(self, path):
        shutil.copytree(REPO / "tools", self.root / "tools", dirs_exist_ok=True)
        return subprocess.run([str(self.root / "tools" / "install.sh")], capture_output=True,
                              text=True, check=False, start_new_session=True,
                              env={**os.environ, "HOME": str(self.root),
                                   "PATH": path})

    def test_tools_links_ubuntu_names_once(self):
        path = self.tool_path("fdfind", "batcat")
        first = self.run_tools_installer(path)
        self.assertEqual(first.returncode, 0, first.stderr)
        bin_dir = self.root / ".local" / "bin"
        self.assertEqual(os.readlink(bin_dir / "fd").rsplit("/", 1)[1], "fdfind")
        self.assertEqual(os.readlink(bin_dir / "bat").rsplit("/", 1)[1], "batcat")
        second = self.run_tools_installer(path)
        self.assertEqual(second.returncode, 0, second.stderr)
        self.assertIn("Already linked", second.stdout)

    def test_tools_skips_missing_and_native_commands(self):
        result = self.run_tools_installer(self.tool_path("fd"))
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("Already available: fd", result.stdout)
        self.assertIn("Skipping bat", result.stdout)
        self.assertFalse((self.root / ".local" / "bin").exists())

    def run_uv_installer(self, *, installed=False, checksum=None):
        """Run uv/install.sh with a stand-in download and a fake uv release."""
        folder = self.root / "uv"
        folder.mkdir(exist_ok=True)
        shutil.copy2(REPO / "uv" / "install.sh", folder / "install.sh")
        release = self.root / "release"
        asset = release / "uv-x86_64-unknown-linux-gnu"
        asset.mkdir(parents=True, exist_ok=True)
        (asset / "uv").write_text(
            '#!/usr/bin/env bash\n'
            'case $1 in\n'
            '    --version) echo "uv 0.13.5 (x86_64-unknown-linux-gnu)" ;;\n'
            '    tool) printf "uv:%s\\n" "$*" >> "$INSTALL_LOG"\n'
            '          [[ $2 == list && -n $FAKE_RUFF ]] && echo "ruff v0.14.0" ;;\n'
            'esac\n'
            'exit 0\n')
        (asset / "uvx").write_text("#!/usr/bin/env bash\n")
        for name in ("uv", "uvx"):
            (asset / name).chmod(0o755)
        tarball = release / "uv-x86_64-unknown-linux-gnu.tar.gz"
        subprocess.run(["tar", "-czf", str(tarball), "-C", str(release), asset.name], check=True)
        if checksum is None:
            checksum = hashlib.sha256(tarball.read_bytes()).hexdigest()
        (release / (tarball.name + ".sha256")).write_text(f"{checksum}  {tarball.name}\n")
        if installed:
            bin_dir = self.root / ".local" / "bin"
            bin_dir.mkdir(parents=True, exist_ok=True)
            shutil.copy2(asset / "uv", bin_dir / "uv")
        commands = self.root / "commands"
        commands.mkdir(exist_ok=True)
        (commands / "curl").write_text(
            '#!/usr/bin/env bash\n'
            'printf "curl:%s\\n" "$*" >> "$INSTALL_LOG"\n'
            'while (( $# )); do\n'
            '    case $1 in\n'
            '        -w) printf "https://github.com/astral-sh/uv/releases/tag/0.13.5"; exit 0 ;;\n'
            '        -o) out=$2; shift ;;\n'
            '    esac\n'
            '    shift\n'
            'done\n'
            'cp "$FAKE_RELEASE/${out##*/}" "$out"\n')
        (commands / "curl").chmod(0o755)
        return subprocess.run([str(folder / "install.sh")], capture_output=True, text=True,
                              check=False, env={**os.environ,
                                  "HOME": str(self.root), "INSTALL_LOG": str(self.log),
                                  "FAKE_RELEASE": str(release), "FAKE_RUFF": "",
                                  "PATH": f"{commands}:{os.environ['PATH']}"})

    def test_uv_is_installed_after_checksum_check_with_ruff(self):
        result = self.run_uv_installer()

        self.assertEqual(result.returncode, 0, result.stderr)
        bin_dir = self.root / ".local" / "bin"
        self.assertTrue(os.access(bin_dir / "uv", os.X_OK))
        self.assertTrue(os.access(bin_dir / "uvx", os.X_OK))
        log = self.log.read_text()
        self.assertIn("releases/download/0.13.5/uv-x86_64-unknown-linux-gnu.tar.gz.sha256", log)
        self.assertIn("uv:tool install ruff", log)

    def test_current_uv_is_not_downloaded_again(self):
        result = self.run_uv_installer(installed=True)

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("uv 0.13.5 is already installed", result.stdout)
        self.assertNotIn("releases/download", self.log.read_text())

    def test_uv_checksum_mismatch_is_not_installed(self):
        result = self.run_uv_installer(checksum="0" * 64)

        self.assertNotEqual(result.returncode, 0)
        self.assertIn("Checksum mismatch", result.stderr)
        self.assertFalse((self.root / ".local" / "bin" / "uv").exists())

if __name__ == "__main__":
    unittest.main()
