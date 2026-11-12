# Tool configuration

Select `tool-configs` in `./install.sh`, or run from the dotfiles root:

```sh
./tool-configs/install.sh
```

Installs configuration only; binaries are managed by [mise](../mise/README.md).
The server profile excludes this component. Existing files use the shared
skip, overwrite, backup, and diff prompts.

- [bat](bat/README.md): display defaults and file previews.
- [Markdownlint](markdownlint/README.md): global lint rules for Markdown.
- [OpenCode](opencode/README.md): global instructions and initial configuration.
