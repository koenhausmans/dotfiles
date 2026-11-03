# OpenCode

Install global instructions and initial configuration (not the OpenCode binary):

```sh
./opencode/install.sh
```

The full `./install.sh` also offers this component; the server profile excludes it.
Files go into `${XDG_CONFIG_HOME:-$HOME/.config}/opencode`:

- `AGENTS.md` is symlinked. It requests concise, complete replies in Caveman lite
  style. Repository updates apply to the linked instructions.
- `opencode.jsonc` is copied. If only `opencode.json` exists, the installer uses
  that path instead. Defaults enable experimental todo tracking and artifacts.
  Experimental options can change between OpenCode releases.
- `cli.json` is copied. Defaults select the
  `kanagawa-wave` dark theme and hide the session sidebar. Install the custom theme
  with `./themes/opencode/install.sh`.

Edit the installed config files for local preferences. Identical copies are left
alone without prompting. For differing files or other conflicts, the installer
asks whether to skip, overwrite, or back up to `.backup`. Choose `D` to view an
existing → incoming diff and return to the prompt (also available for links).
Choose skip to preserve local edits; overwrite and backup replace the whole file,
not merge settings. Uppercase `S`/`O`/`B` applies the choice to remaining conflicts
across links and copies. Matching instruction symlinks are left alone.
JSONC supports comments and trailing commas; JSON uses standard JSON syntax.
Both formats configure the same settings. Keep one format rather than both.

See [OpenCode configuration](https://opencode.ai/v2/docs/config) for options and
[OpenCode themes](../themes/opencode/README.md) for theme installation.
