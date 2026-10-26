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

## More

- [bat](bat/README.md): display defaults and file previews
- [bin](bin/README.md): git helpers (`git trail`, `git start`, `git land`, ...) and other scripts
- [git](git/README.md): useful git commands
- [nvim](nvim/README.md): Neovim configuration
- [tmux](tmux/README.md): keyboard shortcuts
- [vim](vim/README.md): keyboard shortcuts
- Themes: [Claude Code](themes/claude-code/README.md), [OpenCode](themes/opencode/README.md), [Windows Terminal](themes/windows-terminal/README.md)
