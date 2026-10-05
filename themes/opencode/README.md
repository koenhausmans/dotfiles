# OpenCode themes

These dark-mode themes match the palettes in `themes/alacritty/`:

| File | Palette source and upstream notices |
| --- | --- |
| `gruvbox-dark.json` | [Gruvbox](https://github.com/morhetz/gruvbox), [MIT/X11 statement](https://github.com/morhetz/gruvbox/blob/master/README.md#license) |
| `gruvbox-material.json` | [Gruvbox Material](https://github.com/sainnhe/gruvbox-material) mixed with [Gruvbox](https://github.com/morhetz/gruvbox), [MIT notice](../licenses/gruvbox-material-LICENSE) |
| `kanagawa-wave.json` | [Kanagawa Wave](https://github.com/rebelot/kanagawa.nvim), [MIT notice](../licenses/kanagawa.nvim-LICENSE) |
| `sonokai-shusia.json` | [Sonokai Shusia](https://github.com/sainnhe/sonokai), [MIT notice](../licenses/sonokai-LICENSE) |
| `tokyonight-night.json` | [TokyoNight Night](https://github.com/folke/tokyonight.nvim), [Apache-2.0](../licenses/tokyonight.nvim-LICENSE); [original by Enkia](https://github.com/tokyo-night/tokyo-night-vscode-theme), [MIT notice](../licenses/tokyo-night-vscode-LICENSE.txt) |

The JSON files are strict theme data, so keep these references and the linked upstream notices alongside them when redistributing them. See [provenance and remaining license uncertainties](../SOURCES.md). These upstream notices do not assign a license to the new OpenCode files or to this dotfiles repository.

To install them for all projects, copy the JSON files to the global OpenCode themes directory:

```sh
mkdir -p ~/.config/opencode/themes
cp themes/opencode/*.json ~/.config/opencode/themes/
```

If you use `XDG_CONFIG_HOME`, replace `~/.config` with `$XDG_CONFIG_HOME`.
Restart OpenCode and run `/themes` to select a theme. Alternatively, set its filename without `.json` as `theme.name` in `~/.config/opencode/cli.json` and set `theme.mode` to `dark`. These themes provide dark mode only.
