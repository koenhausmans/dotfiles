# Dotfiles

## Install

```sh
sudo apt install curl git bash vim neovim zsh fish tmux universal-ctags build-essential ripgrep fd-find bat
./install.sh
```

Neovim requires **0.11.3+**; the distribution package may be older. See
[Neovim setup](nvim/README.md#install-a-newer-neovim) for a newer stable release.

On a server, install only bash, vim (minimal), screen, tmux and zoxide (`bin` comes with bash):

```sh
sudo apt install curl git bash vim tmux screen
./install.sh server
```

`install.sh` asks per component: `y` yes, `Y` yes to all, `n` skip.
Existing files are skipped, backed up or overwritten on request; re-running is safe.
For file conflicts, uppercase `S`/`O`/`B` applies skip/overwrite/backup across all
remaining components in this run; lowercase `s`/`o`/`b` applies to one file.
Choose `D` to view an existing → incoming diff, then choose an action.

| Component | Installs |
|---|---|
| bash, zsh, fish, git, tmux, screen | links the configuration |
| zoxide | zoxide in `~/.local/bin` with a one-time `z.sh` history import |
| vim | full configuration; minimal (`vimrc.minimal`) with `server` |
| nvim | Neovim configuration |
| fzf | latest `.deb` release (checksum verified, needs `sudo`) |
| tools | links Ubuntu's `fdfind` as `fd` |
| bat | links Ubuntu's `batcat` as `bat` plus shared display and paging defaults |
| fnm | fnm in `~/.local/bin` plus the latest Node.js LTS |
| uv | uv in `~/.local/bin` (checksum verified) plus `ruff` |
| opencode | links global instructions and copies configuration with conflict prompts |
| themes | Claude Code and OpenCode themes |

Prompts use Powerline glyphs; use a Nerd Font such as Pragmasevka ([setup](themes/windows-terminal/README.md#font-and-appearance)).
Windows Terminal ([README](themes/windows-terminal/README.md)), [Alacritty](themes/alacritty/) and [PuTTY](themes/putty/) themes are installed by hand.

## Local customizations

Machine-specific settings go in files that aren't tracked in this repo:
`~/.bashrc.local`, `~/.zshrc.local`, `~/.config/fish/config.local.fish`,
`~/.gitconfig.local`, `~/.tmux.conf.local`, `~/.screenrc.local`, `~/.vimrc.local`.

The fish template `fish/config.local.fish.template` lists the prompt options.
OpenCode settings stay local in `~/.config/opencode/opencode.json(c)` (or under
`$XDG_CONFIG_HOME`); see [OpenCode setup](opencode/README.md).

## More

- [bat](bat/README.md): display defaults and file previews
- [Bash](bash/README.md) and [Zsh](zsh/README.md): shell setup and managed dependencies
- [zoxide](zoxide/README.md): directory navigation and history migration
- [bin](bin/README.md): git helpers (`git trail`, `git start`, `git land`, ...) and other scripts
- [fish](fish/README.md): prompt behavior and customization
- [git](git/README.md): Git-specific configuration
- [nvim](nvim/README.md): Neovim configuration
- [OpenCode](opencode/README.md): global instructions and local configuration
- [Screen](screen/README.md): sessions and detachment
- [tmux](tmux/README.md): keyboard shortcuts
- [vim](vim/README.md): keyboard shortcuts
- Themes: [Claude Code](themes/claude-code/README.md), [OpenCode](themes/opencode/README.md), [Windows Terminal](themes/windows-terminal/README.md)
