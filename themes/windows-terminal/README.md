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

| File | Scheme name |
|---|---|
| `kanagawa-wave.json` | `Kanagawa Wave` |
| `gruvbox-material.json` | `Gruvbox Material` |
| `tokyonight-night.json` | `Tokyo Night` |
| `sonokai-shusia.json` | `Sonokai Shusia` |
| `gruvbox-dark.json` | `Gruvbox Dark` |
