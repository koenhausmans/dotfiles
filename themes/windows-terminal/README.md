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

## Font and appearance

Install [Pragmasevka Nerd Font](https://github.com/shytikov/pragmasevka/releases)
on Windows: download the Nerd Font archive and install its `.ttf` files. Its
Nerd Font glyphs cover the Powerline prompts.

Add these settings under `"profiles"` → `"defaults"`, or set them in the
Settings UI under **Defaults** (or a single profile) → **Appearance**:

```jsonc
"defaults": {
    "font": {
        "face": "Pragmasevka Nerd Font",
        "weight": "thin",
        "cellHeight": "1.3"
    },
    "padding": "2",
    "scrollbarState": "hidden"
}
```

| Settings UI | JSON key | Value |
| --- | --- | --- |
| Font face | `font.face` | `Pragmasevka Nerd Font` |
| Font weight | `font.weight` | `Thin` |
| Line height | `font.cellHeight` | `1.3` |
| Padding | `padding` | `2` |
| Scrollbar visibility | `scrollbarState` | `Hidden` |

## Available themes

| File | Scheme name |
| --- | --- |
| `kanagawa-wave.json` | `Kanagawa Wave` |
| `gruvbox-material.json` | `Gruvbox Material` |
| `tokyonight-night.json` | `Tokyo Night` |
| `sonokai-shusia.json` | `Sonokai Shusia` |
| `gruvbox-dark.json` | `Gruvbox Dark` |

Keep [sources and upstream notices](../SOURCES.md) with redistributed schemes.
