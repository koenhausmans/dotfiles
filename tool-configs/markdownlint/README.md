# Markdownlint

Select `tool-configs` in `./install.sh`, or run `./tool-configs/install.sh`,
to link `markdownlintrc` to `~/.markdownlintrc`.
The `markdownlint-cli` binary is managed by [mise](../../mise/README.md).

The global MD013 line-length limit is **160 characters**. Other rules keep their
defaults. This applies to CLI runs and [Neovim linting](../../nvim/README.md#language-servers-and-formatters).

Project rules in `.markdownlint.jsonc`, `.markdownlint.json`, `.markdownlint.yaml`,
or `.markdownlint.yml` in the working directory override the global defaults.
An explicit `markdownlint --config` selects that configuration instead.
