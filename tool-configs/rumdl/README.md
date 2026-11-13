# rumdl

Select `tool-configs` in `./install.sh`, or run `./tool-configs/install.sh`,
to link `rumdl.toml` to `~/.config/rumdl/rumdl.toml` (respects `XDG_CONFIG_HOME`).
The [rumdl](https://github.com/rvben/rumdl) binary is managed by [mise](../../mise/README.md).

The global MD013 line-length limit is **160 characters**. Other rules keep their
defaults. This applies to `rumdl check` and [Neovim's LSP integration](../../nvim/README.md#language-servers-and-formatters).

Project configuration takes precedence over the global defaults. rumdl searches
upward from the file's directory for `.rumdl.toml`, `rumdl.toml`, `.config/rumdl.toml`,
or `[tool.rumdl]` in `pyproject.toml`, stopping at the Git project boundary.
It also supports common `.markdownlint.*` project configurations as a fallback.
Use `rumdl config file` to inspect configuration discovery, or `rumdl --config PATH`
to select a configuration explicitly.

rumdl is beta; markdownlint compatibility is broad, not exact.
