# Antigravity CLI colors

[Antigravity CLI's `colorScheme` setting](https://antigravity.google/docs/cli/reference/#configuration-keys-settingsjson) offers built-in schemes and `terminal`, which inherits your terminal's colors. The CLI does not document importing custom theme JSON files. Do not install the files in `themes/opencode/` or `themes/claude-code/` as Antigravity CLI themes.

To use a matching palette, select one of the five schemes in [`themes/alacritty/`](../alacritty/) or [`themes/windows-terminal/`](../windows-terminal/README.md) in your terminal. Then set `colorScheme` to `terminal` in `~/.gemini/antigravity-cli/settings.json`, preserving your other settings:

```json
{
  "colorScheme": "terminal"
}
```

`./themes/antigravity-cli/install.sh` makes this change for you. It skips Antigravity CLI if `agy` is not on your `PATH`, creates the settings file if needed, and keeps your other settings. If a different `colorScheme` is already set, it asks before replacing it; without a terminal, it leaves the file unchanged and fails. It also refuses to change a settings file that is not plain JSON (for example, one with comments).

You can also use `/config` in Antigravity CLI to choose the **terminal** scheme. This uses your terminal's palette; see [sources and upstream notices](../SOURCES.md).
