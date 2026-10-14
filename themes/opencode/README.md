# OpenCode themes

These dark-mode themes match the palettes in `themes/alacritty/`.

Keep [sources and upstream notices](../SOURCES.md) with redistributed themes.

To install them for all projects, link the JSON files into the global OpenCode themes directory:

```sh
./themes/opencode/install.sh
```

The installer skips OpenCode if `opencode` is not on your `PATH`, and uses `$XDG_CONFIG_HOME` instead of `~/.config` when it is set. Existing files at the link paths are handled as in `./scripts/bootstrap`. Because the files are symlinks, `git pull` updates installed themes. To copy them instead:

```sh
mkdir -p ~/.config/opencode/themes
cp themes/opencode/*.json ~/.config/opencode/themes/
```

If you use `XDG_CONFIG_HOME`, replace `~/.config` with `$XDG_CONFIG_HOME`.
Restart OpenCode and run `/themes` to select a theme. Alternatively, set its **exact filename without `.json`** as `theme.name` in `~/.config/opencode/cli.json` and set `theme.mode` to `dark`. For example, `kanagawa-wave.json` requires `"name": "kanagawa-wave"`, not `"kanagawa"`:

```json
{
  "$schema": "https://opencode.ai/v2/cli.json",
  "theme": {
    "name": "kanagawa-wave",
    "mode": "dark"
  }
}
```

These themes provide dark mode only. If one still looks like the default, verify that the selected name matches an installed filename under `~/.config/opencode/themes/` (or `$XDG_CONFIG_HOME/opencode/themes/`), then restart OpenCode after adding the file. OpenCode also falls back when a theme fails validation; check the TUI for a **Failed to load theme** message. The files here use direct colors or hue references where OpenCode v2.0.24 rejected references such as `$text.muted` in syntax and Markdown colors. If you already installed an earlier copy, copy the corrected JSON files over it.
