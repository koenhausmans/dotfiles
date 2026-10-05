# Windows Terminal Themes

## Installation

1. Open Windows Terminal and go to **Settings → Open JSON file** (`Ctrl+,` then the JSON button in the bottom-left corner).

2. Find the `"schemes"` array and paste the contents of the desired `.json` file into it:

   ```jsonc
   "schemes": [
       // ... existing schemes ...
       {
           "name": "Kanagawa Wave",
           "background": "#1F1F28",
           // etc.
       }
   ]
   ```

3. To apply the scheme to a profile, add `"colorScheme"` to the profile entry under `"profiles"` → `"list"`:

   ```jsonc
   "profiles": {
       "list": [
           {
               "name": "PowerShell",
               "colorScheme": "Kanagawa Wave"
           }
       ]
   }
   ```

   To apply it to all profiles at once, add it under `"profiles"` → `"defaults"` instead:

   ```jsonc
   "profiles": {
       "defaults": {
           "colorScheme": "Kanagawa Wave"
       }
   }
   ```

## Available themes

| File | Scheme name | Palette source and upstream notices |
|---|---|---|
| `kanagawa-wave.json` | `Kanagawa Wave` | [Kanagawa Wave](https://github.com/rebelot/kanagawa.nvim), [MIT notice](../licenses/kanagawa.nvim-LICENSE) |
| `gruvbox-material.json` | `Gruvbox Material` | [Gruvbox Material](https://github.com/sainnhe/gruvbox-material) mixed with [Gruvbox](https://github.com/morhetz/gruvbox), [MIT notice](../licenses/gruvbox-material-LICENSE) |
| `tokyonight-night.json` | `Tokyo Night` | Adapted from [TokyoNight Night](https://github.com/folke/tokyonight.nvim) (bright colors differ from its Windows Terminal export), [Apache-2.0](../licenses/tokyonight.nvim-LICENSE); [original by Enkia](https://github.com/tokyo-night/tokyo-night-vscode-theme), [MIT notice](../licenses/tokyo-night-vscode-LICENSE.txt) |
| `sonokai-shusia.json` | `Sonokai Shusia` | [Sonokai Shusia](https://github.com/sainnhe/sonokai), [MIT notice](../licenses/sonokai-LICENSE) |
| `gruvbox-dark.json` | `Gruvbox Dark` | [Gruvbox](https://github.com/morhetz/gruvbox), [MIT/X11 statement](https://github.com/morhetz/gruvbox/blob/master/README.md#license) |

The JSON files contain no comments so they can be pasted into Windows Terminal settings. Keep these source and license references with the schemes when redistributing them. See [provenance and remaining license uncertainties](../SOURCES.md); the linked notices describe upstream works, not a license for this dotfiles repository.
