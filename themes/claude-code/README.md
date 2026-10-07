# Claude Code themes

These five dark themes adapt the palettes in `themes/alacritty/` and the semantic colors in `themes/opencode/` to [Claude Code's custom theme format](https://code.claude.com/docs/en/terminal-config#create-a-custom-theme). Claude Code applies each file's `overrides` on top of its built-in `dark` theme; it does not set your terminal's background or ANSI palette. Select the matching terminal palette for a consistent appearance.

| File | Palette source and upstream notices |
| --- | --- |
| `gruvbox-dark.json` | [Gruvbox](https://github.com/morhetz/gruvbox), [MIT/X11 statement](https://github.com/morhetz/gruvbox/blob/master/README.md#license) |
| `gruvbox-material.json` | [Gruvbox Material](https://github.com/sainnhe/gruvbox-material) mixed with [Gruvbox](https://github.com/morhetz/gruvbox), [MIT notice](../licenses/gruvbox-material-LICENSE) |
| `kanagawa-wave.json` | [Kanagawa Wave](https://github.com/rebelot/kanagawa.nvim), [MIT notice](../licenses/kanagawa.nvim-LICENSE) |
| `sonokai-shusia.json` | [Sonokai Shusia](https://github.com/sainnhe/sonokai), [MIT notice](../licenses/sonokai-LICENSE) |
| `tokyonight-night.json` | [TokyoNight Night](https://github.com/folke/tokyonight.nvim), [Apache-2.0](../licenses/tokyonight.nvim-LICENSE); [original by Enkia](https://github.com/tokyo-night/tokyo-night-vscode-theme), [MIT notice](../licenses/tokyo-night-vscode-LICENSE.txt) |

Copy the JSON files into Claude Code's global themes directory:

```sh
mkdir -p ~/.claude/themes
cp themes/claude-code/*.json ~/.claude/themes/
```

Run `/theme` inside Claude Code and select a custom theme. The filename without `.json` is its slug: for example, `kanagawa-wave.json` is saved as `custom:kanagawa-wave` in Claude Code's `theme` preference. If Claude Code was running before `~/.claude/themes/` was created, restart it once.

The files are strict JSON; keep these source and license references alongside them when redistributing. See [provenance and remaining license uncertainties](../SOURCES.md). Upstream notices do not declare a license for these new files or this dotfiles repository.
