# Antigravity CLI colors

[Antigravity CLI's `colorScheme` setting](https://antigravity.google/docs/cli/reference/#configuration-keys-settingsjson) offers built-in schemes and `terminal`, which inherits your terminal's colors. The CLI does not document importing custom theme JSON files. Do not install the files in `themes/opencode/` or `themes/claude-code/` as Antigravity CLI themes.

To use a matching palette, select one of the five schemes in [`themes/alacritty/`](../alacritty/) or [`themes/windows-terminal/`](../windows-terminal/README.md) in your terminal. Then set `colorScheme` to `terminal` in `~/.gemini/antigravity-cli/settings.json`, preserving your other settings:

```json
{
  "colorScheme": "terminal"
}
```

You can also use `/config` in Antigravity CLI to choose the **terminal** scheme. This is terminal-palette inheritance, not a custom semantic theme: Antigravity CLI controls how it uses the terminal's colors. The terminal palettes' upstream attribution and license references are recorded in [`themes/SOURCES.md`](../SOURCES.md) and [`themes/licenses/`](../licenses/); these notices do not license the original dotfiles work.
