# Claude Code themes

These five dark themes adapt the palettes in `themes/alacritty/` and the semantic colors in `themes/opencode/` to [Claude Code's custom theme format](https://code.claude.com/docs/en/terminal-config#create-a-custom-theme). Claude Code applies each file's `overrides` on top of its built-in `dark` theme; it does not set your terminal's background or ANSI palette. Select the matching terminal palette for a consistent appearance.

Keep [sources and upstream notices](../SOURCES.md) with redistributed themes.

Link the JSON files into Claude Code's global themes directory with:

```sh
./themes/claude-code/install.sh
```

The installer skips Claude Code if `claude` is not on your `PATH`. It links into `$CLAUDE_CONFIG_DIR/themes` when that variable is set. Existing files at the link paths are handled as in `./scripts/bootstrap`. Because the files are symlinks, `git pull` updates installed themes. To copy them instead:

```sh
mkdir -p ~/.claude/themes
cp themes/claude-code/*.json ~/.claude/themes/
```

Run `/theme` inside Claude Code and select a custom theme. The filename without `.json` is its slug: for example, `kanagawa-wave.json` is saved as `custom:kanagawa-wave` in Claude Code's `theme` preference. If Claude Code was running before `~/.claude/themes/` was created, restart it once.
