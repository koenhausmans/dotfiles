# Dotfiles

## Install

```sh
sudo apt install curl git bash vim neovim zsh fish tmux exuberant-ctags build-essential ripgrep fd-find bat
./install.sh
```

`install.sh` asks per component: `y` yes, `Y` yes to all, `n` skip.
Existing files are skipped, backed up or overwritten on request; re-running is safe.

| Component | Installs |
|---|---|
| bash, zsh, fish, git, tmux, screen | links the configuration |
| vim | full or minimal (`vimrc.minimal`) configuration |
| nvim | Neovim configuration |
| fzf | latest `.deb` release (checksum verified, needs `sudo`) |
| tools | links Ubuntu's `fdfind` and `batcat` as `fd` and `bat` |
| bat | links shared display and paging defaults |
| fnm | fnm in `~/.local/bin` plus the latest Node.js LTS |
| uv | uv in `~/.local/bin` (checksum verified) plus `ruff` |
| themes | Claude Code and OpenCode themes |

Prompts use Powerline glyphs; pick a terminal font that has them.
Windows Terminal ([README](themes/windows-terminal/README.md)), [Alacritty](themes/alacritty/) and [PuTTY](themes/putty/) themes are installed by hand.

## Local customizations

Machine-specific settings go in files that aren't tracked in this repo:
`~/.bashrc.local`, `~/.zshrc.local`, `~/.config/fish/config.local.fish`,
`~/.gitconfig.local`, `~/.tmux.conf.local`, `~/.screenrc.local`, `~/.vimrc.local`.

The fish template `fish/config.local.fish.template` lists the prompt options.

## File previews with bat

The `bat` component links `bat/config` to `${XDG_CONFIG_HOME:-~/.config}/bat/config`.
It enables line numbers and Git-change markers, with automatic paging for long
terminal output. It does not replace `cat` or change the global pager.

When `bat` or Ubuntu's `batcat` is available, the fzf **Ctrl-T** file picker in
Bash, Zsh, and Fish previews the first 300 lines with syntax highlighting.
Directories show a listing instead. History and directory pickers are unchanged.
Vim and Neovim use fzf.vim's built-in bat detection for their existing previews.

Existing `FZF_CTRL_T_OPTS` values are kept. Set it in your local shell config to
customize the preview, or set it to an empty string to disable it. Bat's
`BAT_THEME`, `BAT_STYLE`, and `BAT_CONFIG_PATH` variables can customize normal
bat invocations; file previews use a fixed style and never open a pager.

## More

- [bin](bin/README.md): git helpers (`git trail`, `git start`, `git land`, ...) and other scripts
- [git](git/README.md): useful git commands
- [nvim](nvim/README.md): Neovim configuration
- [tmux](tmux/README.md): keyboard shortcuts
- [vim](vim/README.md): keyboard shortcuts
- Themes: [Claude Code](themes/claude-code/README.md), [OpenCode](themes/opencode/README.md), [Windows Terminal](themes/windows-terminal/README.md)
