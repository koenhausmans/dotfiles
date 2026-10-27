# Dotfiles

## Install

```sh
sudo apt install curl git bash vim neovim zsh fish tmux universal-ctags build-essential ripgrep fd-find bat
./install.sh
```

On a server, install only bash, vim (minimal), screen and tmux (`bin` comes with bash):

```sh
sudo apt install curl git bash vim tmux screen
./install.sh server
```

`install.sh` asks per component: `y` yes, `Y` yes to all, `n` skip.
Existing files are skipped, backed up or overwritten on request; re-running is safe.
For file conflicts, uppercase `S`/`O`/`B` applies skip/overwrite/backup across all
remaining components in this run; lowercase `s`/`o`/`b` applies to one file.

| Component | Installs |
|---|---|
| bash, zsh, fish, git, tmux, screen | links the configuration |
| vim | full configuration; minimal (`vimrc.minimal`) with `server` |
| nvim | Neovim configuration |
| fzf | latest `.deb` release (checksum verified, needs `sudo`) |
| tools | links Ubuntu's `fdfind` as `fd` |
| bat | links Ubuntu's `batcat` as `bat` plus shared display and paging defaults |
| fnm | fnm in `~/.local/bin` plus the latest Node.js LTS |
| uv | uv in `~/.local/bin` (checksum verified) plus `ruff` |
| themes | Claude Code and OpenCode themes |

Prompts use Powerline glyphs; use a Nerd Font such as Pragmasevka ([setup](themes/windows-terminal/README.md#font-and-appearance)).
Windows Terminal ([README](themes/windows-terminal/README.md)), [Alacritty](themes/alacritty/) and [PuTTY](themes/putty/) themes are installed by hand.

## Local customizations

Machine-specific settings go in files that aren't tracked in this repo:
`~/.bashrc.local`, `~/.zshrc.local`, `~/.config/fish/config.local.fish`,
`~/.gitconfig.local`, `~/.tmux.conf.local`, `~/.screenrc.local`, `~/.vimrc.local`.

The fish template `fish/config.local.fish.template` lists the prompt options.

## More

- [bat](bat/README.md): display defaults and file previews
- [Bash](bash/README.md) and [Zsh](zsh/README.md): shell setup and managed dependencies
- [bin](bin/README.md): git helpers (`git trail`, `git start`, `git land`, ...) and other scripts
- [fzf](fzf/README.md): package installation details
- [fish](fish/README.md): prompt behavior and customization
- [git](git/README.md): useful git commands
- [nvim](nvim/README.md): Neovim configuration
- [tmux](tmux/README.md): keyboard shortcuts
- [vim](vim/README.md): keyboard shortcuts
- Themes: [Claude Code](themes/claude-code/README.md), [OpenCode](themes/opencode/README.md), [Windows Terminal](themes/windows-terminal/README.md)
